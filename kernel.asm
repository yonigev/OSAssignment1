
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc d0 b6 10 80       	mov    $0x8010b6d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 95 2a 10 80       	mov    $0x80102a95,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	53                   	push   %ebx
80100038:	83 ec 0c             	sub    $0xc,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003b:	68 e0 6c 10 80       	push   $0x80106ce0
80100040:	68 e0 b6 10 80       	push   $0x8010b6e0
80100045:	e8 3e 3f 00 00       	call   80103f88 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004a:	c7 05 2c fe 10 80 dc 	movl   $0x8010fddc,0x8010fe2c
80100051:	fd 10 80 
  bcache.head.next = &bcache.head;
80100054:	c7 05 30 fe 10 80 dc 	movl   $0x8010fddc,0x8010fe30
8010005b:	fd 10 80 
8010005e:	83 c4 10             	add    $0x10,%esp
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100061:	bb 14 b7 10 80       	mov    $0x8010b714,%ebx
    b->next = bcache.head.next;
80100066:	a1 30 fe 10 80       	mov    0x8010fe30,%eax
8010006b:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
8010006e:	c7 43 50 dc fd 10 80 	movl   $0x8010fddc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100075:	83 ec 08             	sub    $0x8,%esp
80100078:	68 e7 6c 10 80       	push   $0x80106ce7
8010007d:	8d 43 0c             	lea    0xc(%ebx),%eax
80100080:	50                   	push   %eax
80100081:	e8 1b 3e 00 00       	call   80103ea1 <initsleeplock>
    bcache.head.next->prev = b;
80100086:	a1 30 fe 10 80       	mov    0x8010fe30,%eax
8010008b:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010008e:	89 1d 30 fe 10 80    	mov    %ebx,0x8010fe30

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100094:	81 c3 5c 02 00 00    	add    $0x25c,%ebx
8010009a:	83 c4 10             	add    $0x10,%esp
8010009d:	81 fb dc fd 10 80    	cmp    $0x8010fddc,%ebx
801000a3:	75 c1                	jne    80100066 <binit+0x32>
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000a8:	c9                   	leave  
801000a9:	c3                   	ret    

801000aa <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000aa:	55                   	push   %ebp
801000ab:	89 e5                	mov    %esp,%ebp
801000ad:	57                   	push   %edi
801000ae:	56                   	push   %esi
801000af:	53                   	push   %ebx
801000b0:	83 ec 18             	sub    $0x18,%esp
801000b3:	8b 75 08             	mov    0x8(%ebp),%esi
801000b6:	8b 7d 0c             	mov    0xc(%ebp),%edi
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;

  acquire(&bcache.lock);
801000b9:	68 e0 b6 10 80       	push   $0x8010b6e0
801000be:	e8 a9 3f 00 00       	call   8010406c <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000c3:	8b 1d 30 fe 10 80    	mov    0x8010fe30,%ebx
801000c9:	83 c4 10             	add    $0x10,%esp
801000cc:	81 fb dc fd 10 80    	cmp    $0x8010fddc,%ebx
801000d2:	74 36                	je     8010010a <bread+0x60>
    if(b->dev == dev && b->blockno == blockno){
801000d4:	3b 73 04             	cmp    0x4(%ebx),%esi
801000d7:	75 26                	jne    801000ff <bread+0x55>
801000d9:	3b 7b 08             	cmp    0x8(%ebx),%edi
801000dc:	75 21                	jne    801000ff <bread+0x55>
      b->refcnt++;
801000de:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
801000e2:	83 ec 0c             	sub    $0xc,%esp
801000e5:	68 e0 b6 10 80       	push   $0x8010b6e0
801000ea:	e8 42 40 00 00       	call   80104131 <release>
      acquiresleep(&b->lock);
801000ef:	8d 43 0c             	lea    0xc(%ebx),%eax
801000f2:	89 04 24             	mov    %eax,(%esp)
801000f5:	e8 da 3d 00 00       	call   80103ed4 <acquiresleep>
801000fa:	83 c4 10             	add    $0x10,%esp
801000fd:	eb 6c                	jmp    8010016b <bread+0xc1>
  struct buf *b;

  acquire(&bcache.lock);

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000ff:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100102:	81 fb dc fd 10 80    	cmp    $0x8010fddc,%ebx
80100108:	75 ca                	jne    801000d4 <bread+0x2a>
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
8010010a:	8b 1d 2c fe 10 80    	mov    0x8010fe2c,%ebx
80100110:	81 fb dc fd 10 80    	cmp    $0x8010fddc,%ebx
80100116:	74 46                	je     8010015e <bread+0xb4>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
80100118:	83 7b 4c 00          	cmpl   $0x0,0x4c(%ebx)
8010011c:	75 35                	jne    80100153 <bread+0xa9>
8010011e:	f6 03 04             	testb  $0x4,(%ebx)
80100121:	75 30                	jne    80100153 <bread+0xa9>
      b->dev = dev;
80100123:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
80100126:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
80100129:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
8010012f:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100136:	83 ec 0c             	sub    $0xc,%esp
80100139:	68 e0 b6 10 80       	push   $0x8010b6e0
8010013e:	e8 ee 3f 00 00       	call   80104131 <release>
      acquiresleep(&b->lock);
80100143:	8d 43 0c             	lea    0xc(%ebx),%eax
80100146:	89 04 24             	mov    %eax,(%esp)
80100149:	e8 86 3d 00 00       	call   80103ed4 <acquiresleep>
8010014e:	83 c4 10             	add    $0x10,%esp
80100151:	eb 18                	jmp    8010016b <bread+0xc1>
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100153:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100156:	81 fb dc fd 10 80    	cmp    $0x8010fddc,%ebx
8010015c:	75 ba                	jne    80100118 <bread+0x6e>
      release(&bcache.lock);
      acquiresleep(&b->lock);
      return b;
    }
  }
  panic("bget: no buffers");
8010015e:	83 ec 0c             	sub    $0xc,%esp
80100161:	68 ee 6c 10 80       	push   $0x80106cee
80100166:	e8 e2 01 00 00       	call   8010034d <panic>
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
8010016b:	f6 03 02             	testb  $0x2,(%ebx)
8010016e:	75 0c                	jne    8010017c <bread+0xd2>
    iderw(b);
80100170:	83 ec 0c             	sub    $0xc,%esp
80100173:	53                   	push   %ebx
80100174:	e8 1b 1d 00 00       	call   80101e94 <iderw>
80100179:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
8010017c:	89 d8                	mov    %ebx,%eax
8010017e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100181:	5b                   	pop    %ebx
80100182:	5e                   	pop    %esi
80100183:	5f                   	pop    %edi
80100184:	5d                   	pop    %ebp
80100185:	c3                   	ret    

80100186 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
80100186:	55                   	push   %ebp
80100187:	89 e5                	mov    %esp,%ebp
80100189:	53                   	push   %ebx
8010018a:	83 ec 10             	sub    $0x10,%esp
8010018d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
80100190:	8d 43 0c             	lea    0xc(%ebx),%eax
80100193:	50                   	push   %eax
80100194:	e8 c8 3d 00 00       	call   80103f61 <holdingsleep>
80100199:	83 c4 10             	add    $0x10,%esp
8010019c:	85 c0                	test   %eax,%eax
8010019e:	75 0d                	jne    801001ad <bwrite+0x27>
    panic("bwrite");
801001a0:	83 ec 0c             	sub    $0xc,%esp
801001a3:	68 ff 6c 10 80       	push   $0x80106cff
801001a8:	e8 a0 01 00 00       	call   8010034d <panic>
  b->flags |= B_DIRTY;
801001ad:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001b0:	83 ec 0c             	sub    $0xc,%esp
801001b3:	53                   	push   %ebx
801001b4:	e8 db 1c 00 00       	call   80101e94 <iderw>
}
801001b9:	83 c4 10             	add    $0x10,%esp
801001bc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001bf:	c9                   	leave  
801001c0:	c3                   	ret    

801001c1 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001c1:	55                   	push   %ebp
801001c2:	89 e5                	mov    %esp,%ebp
801001c4:	56                   	push   %esi
801001c5:	53                   	push   %ebx
801001c6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001c9:	8d 73 0c             	lea    0xc(%ebx),%esi
801001cc:	83 ec 0c             	sub    $0xc,%esp
801001cf:	56                   	push   %esi
801001d0:	e8 8c 3d 00 00       	call   80103f61 <holdingsleep>
801001d5:	83 c4 10             	add    $0x10,%esp
801001d8:	85 c0                	test   %eax,%eax
801001da:	75 0d                	jne    801001e9 <brelse+0x28>
    panic("brelse");
801001dc:	83 ec 0c             	sub    $0xc,%esp
801001df:	68 06 6d 10 80       	push   $0x80106d06
801001e4:	e8 64 01 00 00       	call   8010034d <panic>

  releasesleep(&b->lock);
801001e9:	83 ec 0c             	sub    $0xc,%esp
801001ec:	56                   	push   %esi
801001ed:	e8 34 3d 00 00       	call   80103f26 <releasesleep>

  acquire(&bcache.lock);
801001f2:	c7 04 24 e0 b6 10 80 	movl   $0x8010b6e0,(%esp)
801001f9:	e8 6e 3e 00 00       	call   8010406c <acquire>
  b->refcnt--;
801001fe:	8b 43 4c             	mov    0x4c(%ebx),%eax
80100201:	83 e8 01             	sub    $0x1,%eax
80100204:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
80100207:	83 c4 10             	add    $0x10,%esp
8010020a:	85 c0                	test   %eax,%eax
8010020c:	75 2f                	jne    8010023d <brelse+0x7c>
    // no one is waiting for it.
    b->next->prev = b->prev;
8010020e:	8b 43 54             	mov    0x54(%ebx),%eax
80100211:	8b 53 50             	mov    0x50(%ebx),%edx
80100214:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100217:	8b 43 50             	mov    0x50(%ebx),%eax
8010021a:	8b 53 54             	mov    0x54(%ebx),%edx
8010021d:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100220:	a1 30 fe 10 80       	mov    0x8010fe30,%eax
80100225:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
80100228:	c7 43 50 dc fd 10 80 	movl   $0x8010fddc,0x50(%ebx)
    bcache.head.next->prev = b;
8010022f:	a1 30 fe 10 80       	mov    0x8010fe30,%eax
80100234:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100237:	89 1d 30 fe 10 80    	mov    %ebx,0x8010fe30
  }
  
  release(&bcache.lock);
8010023d:	83 ec 0c             	sub    $0xc,%esp
80100240:	68 e0 b6 10 80       	push   $0x8010b6e0
80100245:	e8 e7 3e 00 00       	call   80104131 <release>
}
8010024a:	83 c4 10             	add    $0x10,%esp
8010024d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100250:	5b                   	pop    %ebx
80100251:	5e                   	pop    %esi
80100252:	5d                   	pop    %ebp
80100253:	c3                   	ret    

80100254 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100254:	55                   	push   %ebp
80100255:	89 e5                	mov    %esp,%ebp
80100257:	57                   	push   %edi
80100258:	56                   	push   %esi
80100259:	53                   	push   %ebx
8010025a:	83 ec 28             	sub    $0x28,%esp
8010025d:	8b 7d 08             	mov    0x8(%ebp),%edi
80100260:	8b 75 0c             	mov    0xc(%ebp),%esi
80100263:	8b 5d 10             	mov    0x10(%ebp),%ebx
  uint target;
  int c;

  iunlock(ip);
80100266:	57                   	push   %edi
80100267:	e8 50 13 00 00       	call   801015bc <iunlock>
  target = n;
8010026c:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  acquire(&cons.lock);
8010026f:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100276:	e8 f1 3d 00 00       	call   8010406c <acquire>
  while(n > 0){
8010027b:	83 c4 10             	add    $0x10,%esp
8010027e:	85 db                	test   %ebx,%ebx
80100280:	0f 8f 8f 00 00 00    	jg     80100315 <consoleread+0xc1>
80100286:	e9 9d 00 00 00       	jmp    80100328 <consoleread+0xd4>
    while(input.r == input.w){
      if(myproc()->killed){
8010028b:	e8 0a 31 00 00       	call   8010339a <myproc>
80100290:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80100294:	74 22                	je     801002b8 <consoleread+0x64>
        release(&cons.lock);
80100296:	83 ec 0c             	sub    $0xc,%esp
80100299:	68 20 a5 10 80       	push   $0x8010a520
8010029e:	e8 8e 3e 00 00       	call   80104131 <release>
        ilock(ip);
801002a3:	89 3c 24             	mov    %edi,(%esp)
801002a6:	e8 4f 12 00 00       	call   801014fa <ilock>
        return -1;
801002ab:	83 c4 10             	add    $0x10,%esp
801002ae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801002b3:	e9 8d 00 00 00       	jmp    80100345 <consoleread+0xf1>
      }
      sleep(&input.r, &cons.lock);
801002b8:	83 ec 08             	sub    $0x8,%esp
801002bb:	68 20 a5 10 80       	push   $0x8010a520
801002c0:	68 c0 00 11 80       	push   $0x801100c0
801002c5:	e8 9e 36 00 00       	call   80103968 <sleep>

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
801002ca:	a1 c0 00 11 80       	mov    0x801100c0,%eax
801002cf:	83 c4 10             	add    $0x10,%esp
801002d2:	3b 05 c4 00 11 80    	cmp    0x801100c4,%eax
801002d8:	74 b1                	je     8010028b <consoleread+0x37>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
801002da:	8d 50 01             	lea    0x1(%eax),%edx
801002dd:	89 15 c0 00 11 80    	mov    %edx,0x801100c0
801002e3:	89 c2                	mov    %eax,%edx
801002e5:	83 e2 7f             	and    $0x7f,%edx
801002e8:	0f b6 8a 40 00 11 80 	movzbl -0x7feeffc0(%edx),%ecx
801002ef:	0f be d1             	movsbl %cl,%edx
    if(c == C('D')){  // EOF
801002f2:	83 fa 04             	cmp    $0x4,%edx
801002f5:	75 0c                	jne    80100303 <consoleread+0xaf>
      if(n < target){
801002f7:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
801002fa:	76 2c                	jbe    80100328 <consoleread+0xd4>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
801002fc:	a3 c0 00 11 80       	mov    %eax,0x801100c0
80100301:	eb 25                	jmp    80100328 <consoleread+0xd4>
      }
      break;
    }
    *dst++ = c;
80100303:	83 c6 01             	add    $0x1,%esi
80100306:	88 4e ff             	mov    %cl,-0x1(%esi)
    --n;
80100309:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
8010030c:	83 fa 0a             	cmp    $0xa,%edx
8010030f:	74 17                	je     80100328 <consoleread+0xd4>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100311:	85 db                	test   %ebx,%ebx
80100313:	74 13                	je     80100328 <consoleread+0xd4>
    while(input.r == input.w){
80100315:	a1 c0 00 11 80       	mov    0x801100c0,%eax
8010031a:	3b 05 c4 00 11 80    	cmp    0x801100c4,%eax
80100320:	0f 84 65 ff ff ff    	je     8010028b <consoleread+0x37>
80100326:	eb b2                	jmp    801002da <consoleread+0x86>
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&cons.lock);
80100328:	83 ec 0c             	sub    $0xc,%esp
8010032b:	68 20 a5 10 80       	push   $0x8010a520
80100330:	e8 fc 3d 00 00       	call   80104131 <release>
  ilock(ip);
80100335:	89 3c 24             	mov    %edi,(%esp)
80100338:	e8 bd 11 00 00       	call   801014fa <ilock>

  return target - n;
8010033d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100340:	29 d8                	sub    %ebx,%eax
80100342:	83 c4 10             	add    $0x10,%esp
}
80100345:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100348:	5b                   	pop    %ebx
80100349:	5e                   	pop    %esi
8010034a:	5f                   	pop    %edi
8010034b:	5d                   	pop    %ebp
8010034c:	c3                   	ret    

8010034d <panic>:
    release(&cons.lock);
}

void
panic(char *s)
{
8010034d:	55                   	push   %ebp
8010034e:	89 e5                	mov    %esp,%ebp
80100350:	56                   	push   %esi
80100351:	53                   	push   %ebx
80100352:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100355:	fa                   	cli    
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
80100356:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
8010035d:	00 00 00 
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
80100360:	e8 dd 20 00 00       	call   80102442 <lapicid>
80100365:	83 ec 08             	sub    $0x8,%esp
80100368:	50                   	push   %eax
80100369:	68 0d 6d 10 80       	push   $0x80106d0d
8010036e:	e8 76 02 00 00       	call   801005e9 <cprintf>
  cprintf(s);
80100373:	83 c4 04             	add    $0x4,%esp
80100376:	ff 75 08             	pushl  0x8(%ebp)
80100379:	e8 6b 02 00 00       	call   801005e9 <cprintf>
  cprintf("\n");
8010037e:	c7 04 24 8f 76 10 80 	movl   $0x8010768f,(%esp)
80100385:	e8 5f 02 00 00       	call   801005e9 <cprintf>
  getcallerpcs(&s, pcs);
8010038a:	83 c4 08             	add    $0x8,%esp
8010038d:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100390:	53                   	push   %ebx
80100391:	8d 45 08             	lea    0x8(%ebp),%eax
80100394:	50                   	push   %eax
80100395:	e8 09 3c 00 00       	call   80103fa3 <getcallerpcs>
8010039a:	8d 75 f8             	lea    -0x8(%ebp),%esi
8010039d:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
801003a0:	83 ec 08             	sub    $0x8,%esp
801003a3:	ff 33                	pushl  (%ebx)
801003a5:	68 21 6d 10 80       	push   $0x80106d21
801003aa:	e8 3a 02 00 00       	call   801005e9 <cprintf>
801003af:	83 c3 04             	add    $0x4,%ebx
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801003b2:	83 c4 10             	add    $0x10,%esp
801003b5:	39 f3                	cmp    %esi,%ebx
801003b7:	75 e7                	jne    801003a0 <panic+0x53>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801003b9:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
801003c0:	00 00 00 
801003c3:	eb fe                	jmp    801003c3 <panic+0x76>

801003c5 <consputc>:
}

void
consputc(int c)
{
  if(panicked){
801003c5:	83 3d 58 a5 10 80 00 	cmpl   $0x0,0x8010a558
801003cc:	74 03                	je     801003d1 <consputc+0xc>
801003ce:	fa                   	cli    
801003cf:	eb fe                	jmp    801003cf <consputc+0xa>
  crt[pos] = ' ' | 0x0700;
}

void
consputc(int c)
{
801003d1:	55                   	push   %ebp
801003d2:	89 e5                	mov    %esp,%ebp
801003d4:	56                   	push   %esi
801003d5:	53                   	push   %ebx
801003d6:	89 c6                	mov    %eax,%esi
    cli();
    for(;;)
      ;
  }

  if(c == BACKSPACE){
801003d8:	3d 00 01 00 00       	cmp    $0x100,%eax
801003dd:	75 27                	jne    80100406 <consputc+0x41>
    uartputc('\b'); uartputc(' '); uartputc('\b');
801003df:	83 ec 0c             	sub    $0xc,%esp
801003e2:	6a 08                	push   $0x8
801003e4:	e8 18 55 00 00       	call   80105901 <uartputc>
801003e9:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801003f0:	e8 0c 55 00 00       	call   80105901 <uartputc>
801003f5:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801003fc:	e8 00 55 00 00       	call   80105901 <uartputc>
80100401:	83 c4 10             	add    $0x10,%esp
80100404:	eb 0c                	jmp    80100412 <consputc+0x4d>
  } else
    uartputc(c);
80100406:	83 ec 0c             	sub    $0xc,%esp
80100409:	50                   	push   %eax
8010040a:	e8 f2 54 00 00       	call   80105901 <uartputc>
8010040f:	83 c4 10             	add    $0x10,%esp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100412:	ba d4 03 00 00       	mov    $0x3d4,%edx
80100417:	b8 0e 00 00 00       	mov    $0xe,%eax
8010041c:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010041d:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100422:	89 ca                	mov    %ecx,%edx
80100424:	ec                   	in     (%dx),%al
{
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
  pos = inb(CRTPORT+1) << 8;
80100425:	0f b6 d8             	movzbl %al,%ebx
80100428:	c1 e3 08             	shl    $0x8,%ebx
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010042b:	ba d4 03 00 00       	mov    $0x3d4,%edx
80100430:	b8 0f 00 00 00       	mov    $0xf,%eax
80100435:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100436:	89 ca                	mov    %ecx,%edx
80100438:	ec                   	in     (%dx),%al
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);
80100439:	0f b6 c0             	movzbl %al,%eax
8010043c:	09 c3                	or     %eax,%ebx

  if(c == '\n')
8010043e:	83 fe 0a             	cmp    $0xa,%esi
80100441:	75 19                	jne    8010045c <consputc+0x97>
    pos += 80 - pos%80;
80100443:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100448:	89 d8                	mov    %ebx,%eax
8010044a:	f7 ea                	imul   %edx
8010044c:	89 d0                	mov    %edx,%eax
8010044e:	c1 f8 05             	sar    $0x5,%eax
80100451:	8d 04 80             	lea    (%eax,%eax,4),%eax
80100454:	c1 e0 04             	shl    $0x4,%eax
80100457:	8d 58 50             	lea    0x50(%eax),%ebx
8010045a:	eb 27                	jmp    80100483 <consputc+0xbe>
  else if(c == BACKSPACE){
8010045c:	81 fe 00 01 00 00    	cmp    $0x100,%esi
80100462:	75 0c                	jne    80100470 <consputc+0xab>
    if(pos > 0) --pos;
80100464:	85 db                	test   %ebx,%ebx
80100466:	0f 9f c0             	setg   %al
80100469:	0f b6 c0             	movzbl %al,%eax
8010046c:	29 c3                	sub    %eax,%ebx
8010046e:	eb 13                	jmp    80100483 <consputc+0xbe>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100470:	89 f0                	mov    %esi,%eax
80100472:	0f b6 c0             	movzbl %al,%eax
80100475:	80 cc 07             	or     $0x7,%ah
80100478:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
8010047f:	80 
80100480:	8d 5b 01             	lea    0x1(%ebx),%ebx

  if(pos < 0 || pos > 25*80)
80100483:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
80100489:	76 0d                	jbe    80100498 <consputc+0xd3>
    panic("pos under/overflow");
8010048b:	83 ec 0c             	sub    $0xc,%esp
8010048e:	68 25 6d 10 80       	push   $0x80106d25
80100493:	e8 b5 fe ff ff       	call   8010034d <panic>

  if((pos/80) >= 24){  // Scroll up.
80100498:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
8010049e:	7e 39                	jle    801004d9 <consputc+0x114>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004a0:	83 ec 04             	sub    $0x4,%esp
801004a3:	68 60 0e 00 00       	push   $0xe60
801004a8:	68 a0 80 0b 80       	push   $0x800b80a0
801004ad:	68 00 80 0b 80       	push   $0x800b8000
801004b2:	e8 5b 3d 00 00       	call   80104212 <memmove>
    pos -= 80;
801004b7:	83 eb 50             	sub    $0x50,%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801004ba:	83 c4 0c             	add    $0xc,%esp
801004bd:	b8 80 07 00 00       	mov    $0x780,%eax
801004c2:	29 d8                	sub    %ebx,%eax
801004c4:	01 c0                	add    %eax,%eax
801004c6:	50                   	push   %eax
801004c7:	6a 00                	push   $0x0
801004c9:	8d 84 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%eax
801004d0:	50                   	push   %eax
801004d1:	e8 a2 3c 00 00       	call   80104178 <memset>
801004d6:	83 c4 10             	add    $0x10,%esp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004d9:	ba d4 03 00 00       	mov    $0x3d4,%edx
801004de:	b8 0e 00 00 00       	mov    $0xe,%eax
801004e3:	ee                   	out    %al,(%dx)
801004e4:	89 d8                	mov    %ebx,%eax
801004e6:	c1 f8 08             	sar    $0x8,%eax
801004e9:	ba d5 03 00 00       	mov    $0x3d5,%edx
801004ee:	ee                   	out    %al,(%dx)
801004ef:	ba d4 03 00 00       	mov    $0x3d4,%edx
801004f4:	b8 0f 00 00 00       	mov    $0xf,%eax
801004f9:	ee                   	out    %al,(%dx)
801004fa:	ba d5 03 00 00       	mov    $0x3d5,%edx
801004ff:	89 d8                	mov    %ebx,%eax
80100501:	ee                   	out    %al,(%dx)

  outb(CRTPORT, 14);
  outb(CRTPORT+1, pos>>8);
  outb(CRTPORT, 15);
  outb(CRTPORT+1, pos);
  crt[pos] = ' ' | 0x0700;
80100502:	66 c7 84 1b 00 80 0b 	movw   $0x720,-0x7ff48000(%ebx,%ebx,1)
80100509:	80 20 07 
  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
  cgaputc(c);
}
8010050c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010050f:	5b                   	pop    %ebx
80100510:	5e                   	pop    %esi
80100511:	5d                   	pop    %ebp
80100512:	c3                   	ret    

80100513 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100513:	55                   	push   %ebp
80100514:	89 e5                	mov    %esp,%ebp
80100516:	57                   	push   %edi
80100517:	56                   	push   %esi
80100518:	53                   	push   %ebx
80100519:	83 ec 1c             	sub    $0x1c,%esp
8010051c:	89 d6                	mov    %edx,%esi
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
8010051e:	85 c9                	test   %ecx,%ecx
80100520:	74 0f                	je     80100531 <printint+0x1e>
80100522:	89 c1                	mov    %eax,%ecx
80100524:	c1 e9 1f             	shr    $0x1f,%ecx
80100527:	85 c0                	test   %eax,%eax
80100529:	79 06                	jns    80100531 <printint+0x1e>
    x = -xx;
8010052b:	f7 d8                	neg    %eax
8010052d:	89 c2                	mov    %eax,%edx
8010052f:	eb 02                	jmp    80100533 <printint+0x20>
  else
    x = xx;
80100531:	89 c2                	mov    %eax,%edx

  i = 0;
80100533:	bf 00 00 00 00       	mov    $0x0,%edi
80100538:	eb 02                	jmp    8010053c <printint+0x29>
  do{
    buf[i++] = digits[x % base];
8010053a:	89 df                	mov    %ebx,%edi
8010053c:	8d 5f 01             	lea    0x1(%edi),%ebx
8010053f:	89 d0                	mov    %edx,%eax
80100541:	ba 00 00 00 00       	mov    $0x0,%edx
80100546:	f7 f6                	div    %esi
80100548:	0f b6 92 50 6d 10 80 	movzbl -0x7fef92b0(%edx),%edx
8010054f:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
80100553:	89 c2                	mov    %eax,%edx
80100555:	85 c0                	test   %eax,%eax
80100557:	75 e1                	jne    8010053a <printint+0x27>

  if(sign)
80100559:	85 c9                	test   %ecx,%ecx
8010055b:	74 08                	je     80100565 <printint+0x52>
    buf[i++] = '-';
8010055d:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
80100562:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
80100565:	89 d8                	mov    %ebx,%eax
80100567:	83 e8 01             	sub    $0x1,%eax
8010056a:	78 16                	js     80100582 <printint+0x6f>
8010056c:	8d 5c 1d d7          	lea    -0x29(%ebp,%ebx,1),%ebx
80100570:	8d 75 d7             	lea    -0x29(%ebp),%esi
    consputc(buf[i]);
80100573:	0f be 03             	movsbl (%ebx),%eax
80100576:	e8 4a fe ff ff       	call   801003c5 <consputc>
8010057b:	83 eb 01             	sub    $0x1,%ebx
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
8010057e:	39 f3                	cmp    %esi,%ebx
80100580:	75 f1                	jne    80100573 <printint+0x60>
    consputc(buf[i]);
}
80100582:	83 c4 1c             	add    $0x1c,%esp
80100585:	5b                   	pop    %ebx
80100586:	5e                   	pop    %esi
80100587:	5f                   	pop    %edi
80100588:	5d                   	pop    %ebp
80100589:	c3                   	ret    

8010058a <consolewrite>:
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
8010058a:	55                   	push   %ebp
8010058b:	89 e5                	mov    %esp,%ebp
8010058d:	57                   	push   %edi
8010058e:	56                   	push   %esi
8010058f:	53                   	push   %ebx
80100590:	83 ec 18             	sub    $0x18,%esp
80100593:	8b 75 0c             	mov    0xc(%ebp),%esi
80100596:	8b 7d 10             	mov    0x10(%ebp),%edi
  int i;

  iunlock(ip);
80100599:	ff 75 08             	pushl  0x8(%ebp)
8010059c:	e8 1b 10 00 00       	call   801015bc <iunlock>
  acquire(&cons.lock);
801005a1:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801005a8:	e8 bf 3a 00 00       	call   8010406c <acquire>
  for(i = 0; i < n; i++)
801005ad:	83 c4 10             	add    $0x10,%esp
801005b0:	85 ff                	test   %edi,%edi
801005b2:	7e 13                	jle    801005c7 <consolewrite+0x3d>
801005b4:	89 f3                	mov    %esi,%ebx
801005b6:	01 fe                	add    %edi,%esi
    consputc(buf[i] & 0xff);
801005b8:	0f b6 03             	movzbl (%ebx),%eax
801005bb:	e8 05 fe ff ff       	call   801003c5 <consputc>
801005c0:	83 c3 01             	add    $0x1,%ebx
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
801005c3:	39 f3                	cmp    %esi,%ebx
801005c5:	75 f1                	jne    801005b8 <consolewrite+0x2e>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
801005c7:	83 ec 0c             	sub    $0xc,%esp
801005ca:	68 20 a5 10 80       	push   $0x8010a520
801005cf:	e8 5d 3b 00 00       	call   80104131 <release>
  ilock(ip);
801005d4:	83 c4 04             	add    $0x4,%esp
801005d7:	ff 75 08             	pushl  0x8(%ebp)
801005da:	e8 1b 0f 00 00       	call   801014fa <ilock>

  return n;
}
801005df:	89 f8                	mov    %edi,%eax
801005e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801005e4:	5b                   	pop    %ebx
801005e5:	5e                   	pop    %esi
801005e6:	5f                   	pop    %edi
801005e7:	5d                   	pop    %ebp
801005e8:	c3                   	ret    

801005e9 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
801005e9:	55                   	push   %ebp
801005ea:	89 e5                	mov    %esp,%ebp
801005ec:	57                   	push   %edi
801005ed:	56                   	push   %esi
801005ee:	53                   	push   %ebx
801005ef:	83 ec 1c             	sub    $0x1c,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
801005f2:	a1 54 a5 10 80       	mov    0x8010a554,%eax
801005f7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
801005fa:	85 c0                	test   %eax,%eax
801005fc:	74 10                	je     8010060e <cprintf+0x25>
    acquire(&cons.lock);
801005fe:	83 ec 0c             	sub    $0xc,%esp
80100601:	68 20 a5 10 80       	push   $0x8010a520
80100606:	e8 61 3a 00 00       	call   8010406c <acquire>
8010060b:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
8010060e:	8b 45 08             	mov    0x8(%ebp),%eax
80100611:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100614:	85 c0                	test   %eax,%eax
80100616:	74 14                	je     8010062c <cprintf+0x43>
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100618:	0f b6 00             	movzbl (%eax),%eax
8010061b:	8d 75 0c             	lea    0xc(%ebp),%esi
8010061e:	bb 00 00 00 00       	mov    $0x0,%ebx
80100623:	85 c0                	test   %eax,%eax
80100625:	75 12                	jne    80100639 <cprintf+0x50>
80100627:	e9 df 00 00 00       	jmp    8010070b <cprintf+0x122>
  locking = cons.locking;
  if(locking)
    acquire(&cons.lock);

  if (fmt == 0)
    panic("null fmt");
8010062c:	83 ec 0c             	sub    $0xc,%esp
8010062f:	68 3f 6d 10 80       	push   $0x80106d3f
80100634:	e8 14 fd ff ff       	call   8010034d <panic>

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    if(c != '%'){
80100639:	83 f8 25             	cmp    $0x25,%eax
8010063c:	74 0a                	je     80100648 <cprintf+0x5f>
      consputc(c);
8010063e:	e8 82 fd ff ff       	call   801003c5 <consputc>
      continue;
80100643:	e9 b1 00 00 00       	jmp    801006f9 <cprintf+0x110>
    }
    c = fmt[++i] & 0xff;
80100648:	83 c3 01             	add    $0x1,%ebx
8010064b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010064e:	0f b6 3c 18          	movzbl (%eax,%ebx,1),%edi
    if(c == 0)
80100652:	85 ff                	test   %edi,%edi
80100654:	0f 84 b1 00 00 00    	je     8010070b <cprintf+0x122>
      break;
    switch(c){
8010065a:	83 ff 70             	cmp    $0x70,%edi
8010065d:	74 35                	je     80100694 <cprintf+0xab>
8010065f:	83 ff 70             	cmp    $0x70,%edi
80100662:	7f 0c                	jg     80100670 <cprintf+0x87>
80100664:	83 ff 25             	cmp    $0x25,%edi
80100667:	74 6f                	je     801006d8 <cprintf+0xef>
80100669:	83 ff 64             	cmp    $0x64,%edi
8010066c:	74 0e                	je     8010067c <cprintf+0x93>
8010066e:	eb 74                	jmp    801006e4 <cprintf+0xfb>
80100670:	83 ff 73             	cmp    $0x73,%edi
80100673:	74 37                	je     801006ac <cprintf+0xc3>
80100675:	83 ff 78             	cmp    $0x78,%edi
80100678:	74 1a                	je     80100694 <cprintf+0xab>
8010067a:	eb 68                	jmp    801006e4 <cprintf+0xfb>
    case 'd':
      printint(*argp++, 10, 1);
8010067c:	8d 7e 04             	lea    0x4(%esi),%edi
8010067f:	b9 01 00 00 00       	mov    $0x1,%ecx
80100684:	ba 0a 00 00 00       	mov    $0xa,%edx
80100689:	8b 06                	mov    (%esi),%eax
8010068b:	e8 83 fe ff ff       	call   80100513 <printint>
80100690:	89 fe                	mov    %edi,%esi
      break;
80100692:	eb 65                	jmp    801006f9 <cprintf+0x110>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
80100694:	8d 7e 04             	lea    0x4(%esi),%edi
80100697:	b9 00 00 00 00       	mov    $0x0,%ecx
8010069c:	ba 10 00 00 00       	mov    $0x10,%edx
801006a1:	8b 06                	mov    (%esi),%eax
801006a3:	e8 6b fe ff ff       	call   80100513 <printint>
801006a8:	89 fe                	mov    %edi,%esi
      break;
801006aa:	eb 4d                	jmp    801006f9 <cprintf+0x110>
    case 's':
      if((s = (char*)*argp++) == 0)
801006ac:	8d 7e 04             	lea    0x4(%esi),%edi
801006af:	8b 36                	mov    (%esi),%esi
        s = "(null)";
801006b1:	85 f6                	test   %esi,%esi
801006b3:	b8 38 6d 10 80       	mov    $0x80106d38,%eax
801006b8:	0f 44 f0             	cmove  %eax,%esi
      for(; *s; s++)
801006bb:	0f b6 06             	movzbl (%esi),%eax
801006be:	84 c0                	test   %al,%al
801006c0:	74 35                	je     801006f7 <cprintf+0x10e>
        consputc(*s);
801006c2:	0f be c0             	movsbl %al,%eax
801006c5:	e8 fb fc ff ff       	call   801003c5 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801006ca:	83 c6 01             	add    $0x1,%esi
801006cd:	0f b6 06             	movzbl (%esi),%eax
801006d0:	84 c0                	test   %al,%al
801006d2:	75 ee                	jne    801006c2 <cprintf+0xd9>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
801006d4:	89 fe                	mov    %edi,%esi
801006d6:	eb 21                	jmp    801006f9 <cprintf+0x110>
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
801006d8:	b8 25 00 00 00       	mov    $0x25,%eax
801006dd:	e8 e3 fc ff ff       	call   801003c5 <consputc>
      break;
801006e2:	eb 15                	jmp    801006f9 <cprintf+0x110>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
801006e4:	b8 25 00 00 00       	mov    $0x25,%eax
801006e9:	e8 d7 fc ff ff       	call   801003c5 <consputc>
      consputc(c);
801006ee:	89 f8                	mov    %edi,%eax
801006f0:	e8 d0 fc ff ff       	call   801003c5 <consputc>
      break;
801006f5:	eb 02                	jmp    801006f9 <cprintf+0x110>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
801006f7:	89 fe                	mov    %edi,%esi

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006f9:	83 c3 01             	add    $0x1,%ebx
801006fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006ff:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
80100703:	85 c0                	test   %eax,%eax
80100705:	0f 85 2e ff ff ff    	jne    80100639 <cprintf+0x50>
      consputc(c);
      break;
    }
  }

  if(locking)
8010070b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
8010070f:	74 10                	je     80100721 <cprintf+0x138>
    release(&cons.lock);
80100711:	83 ec 0c             	sub    $0xc,%esp
80100714:	68 20 a5 10 80       	push   $0x8010a520
80100719:	e8 13 3a 00 00       	call   80104131 <release>
8010071e:	83 c4 10             	add    $0x10,%esp
}
80100721:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100724:	5b                   	pop    %ebx
80100725:	5e                   	pop    %esi
80100726:	5f                   	pop    %edi
80100727:	5d                   	pop    %ebp
80100728:	c3                   	ret    

80100729 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
80100729:	55                   	push   %ebp
8010072a:	89 e5                	mov    %esp,%ebp
8010072c:	57                   	push   %edi
8010072d:	56                   	push   %esi
8010072e:	53                   	push   %ebx
8010072f:	83 ec 18             	sub    $0x18,%esp
80100732:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int c, doprocdump = 0;

  acquire(&cons.lock);
80100735:	68 20 a5 10 80       	push   $0x8010a520
8010073a:	e8 2d 39 00 00       	call   8010406c <acquire>
  while((c = getc()) >= 0){
8010073f:	83 c4 10             	add    $0x10,%esp
#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;
80100742:	be 00 00 00 00       	mov    $0x0,%esi

  acquire(&cons.lock);
  while((c = getc()) >= 0){
80100747:	e9 19 01 00 00       	jmp    80100865 <consoleintr+0x13c>
    switch(c){
8010074c:	83 ff 10             	cmp    $0x10,%edi
8010074f:	0f 84 0b 01 00 00    	je     80100860 <consoleintr+0x137>
80100755:	83 ff 10             	cmp    $0x10,%edi
80100758:	7f 0a                	jg     80100764 <consoleintr+0x3b>
8010075a:	83 ff 08             	cmp    $0x8,%edi
8010075d:	74 70                	je     801007cf <consoleintr+0xa6>
8010075f:	e9 90 00 00 00       	jmp    801007f4 <consoleintr+0xcb>
80100764:	83 ff 15             	cmp    $0x15,%edi
80100767:	74 0a                	je     80100773 <consoleintr+0x4a>
80100769:	83 ff 7f             	cmp    $0x7f,%edi
8010076c:	74 61                	je     801007cf <consoleintr+0xa6>
8010076e:	e9 81 00 00 00       	jmp    801007f4 <consoleintr+0xcb>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100773:	a1 c8 00 11 80       	mov    0x801100c8,%eax
80100778:	3b 05 c4 00 11 80    	cmp    0x801100c4,%eax
8010077e:	0f 84 e1 00 00 00    	je     80100865 <consoleintr+0x13c>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100784:	83 e8 01             	sub    $0x1,%eax
80100787:	89 c2                	mov    %eax,%edx
80100789:	83 e2 7f             	and    $0x7f,%edx
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010078c:	80 ba 40 00 11 80 0a 	cmpb   $0xa,-0x7feeffc0(%edx)
80100793:	0f 84 cc 00 00 00    	je     80100865 <consoleintr+0x13c>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
80100799:	a3 c8 00 11 80       	mov    %eax,0x801100c8
        consputc(BACKSPACE);
8010079e:	b8 00 01 00 00       	mov    $0x100,%eax
801007a3:	e8 1d fc ff ff       	call   801003c5 <consputc>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
801007a8:	a1 c8 00 11 80       	mov    0x801100c8,%eax
801007ad:	3b 05 c4 00 11 80    	cmp    0x801100c4,%eax
801007b3:	0f 84 ac 00 00 00    	je     80100865 <consoleintr+0x13c>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801007b9:	83 e8 01             	sub    $0x1,%eax
801007bc:	89 c2                	mov    %eax,%edx
801007be:	83 e2 7f             	and    $0x7f,%edx
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
801007c1:	80 ba 40 00 11 80 0a 	cmpb   $0xa,-0x7feeffc0(%edx)
801007c8:	75 cf                	jne    80100799 <consoleintr+0x70>
801007ca:	e9 96 00 00 00       	jmp    80100865 <consoleintr+0x13c>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
801007cf:	a1 c8 00 11 80       	mov    0x801100c8,%eax
801007d4:	3b 05 c4 00 11 80    	cmp    0x801100c4,%eax
801007da:	0f 84 85 00 00 00    	je     80100865 <consoleintr+0x13c>
        input.e--;
801007e0:	83 e8 01             	sub    $0x1,%eax
801007e3:	a3 c8 00 11 80       	mov    %eax,0x801100c8
        consputc(BACKSPACE);
801007e8:	b8 00 01 00 00       	mov    $0x100,%eax
801007ed:	e8 d3 fb ff ff       	call   801003c5 <consputc>
801007f2:	eb 71                	jmp    80100865 <consoleintr+0x13c>
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
801007f4:	85 ff                	test   %edi,%edi
801007f6:	74 6d                	je     80100865 <consoleintr+0x13c>
801007f8:	a1 c8 00 11 80       	mov    0x801100c8,%eax
801007fd:	89 c2                	mov    %eax,%edx
801007ff:	2b 15 c0 00 11 80    	sub    0x801100c0,%edx
80100805:	83 fa 7f             	cmp    $0x7f,%edx
80100808:	77 5b                	ja     80100865 <consoleintr+0x13c>
        c = (c == '\r') ? '\n' : c;
8010080a:	83 ff 0d             	cmp    $0xd,%edi
8010080d:	74 7d                	je     8010088c <consoleintr+0x163>
        input.buf[input.e++ % INPUT_BUF] = c;
8010080f:	8d 50 01             	lea    0x1(%eax),%edx
80100812:	89 15 c8 00 11 80    	mov    %edx,0x801100c8
80100818:	83 e0 7f             	and    $0x7f,%eax
8010081b:	89 f9                	mov    %edi,%ecx
8010081d:	88 88 40 00 11 80    	mov    %cl,-0x7feeffc0(%eax)
        consputc(c);
80100823:	89 f8                	mov    %edi,%eax
80100825:	e8 9b fb ff ff       	call   801003c5 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
8010082a:	83 ff 0a             	cmp    $0xa,%edi
8010082d:	74 15                	je     80100844 <consoleintr+0x11b>
8010082f:	83 ff 04             	cmp    $0x4,%edi
80100832:	74 10                	je     80100844 <consoleintr+0x11b>
80100834:	a1 c0 00 11 80       	mov    0x801100c0,%eax
80100839:	83 e8 80             	sub    $0xffffff80,%eax
8010083c:	39 05 c8 00 11 80    	cmp    %eax,0x801100c8
80100842:	75 21                	jne    80100865 <consoleintr+0x13c>
          input.w = input.e;
80100844:	a1 c8 00 11 80       	mov    0x801100c8,%eax
80100849:	a3 c4 00 11 80       	mov    %eax,0x801100c4
          wakeup(&input.r);
8010084e:	83 ec 0c             	sub    $0xc,%esp
80100851:	68 c0 00 11 80       	push   $0x801100c0
80100856:	e8 65 34 00 00       	call   80103cc0 <wakeup>
8010085b:	83 c4 10             	add    $0x10,%esp
8010085e:	eb 05                	jmp    80100865 <consoleintr+0x13c>
  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
80100860:	be 01 00 00 00       	mov    $0x1,%esi
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
80100865:	ff d3                	call   *%ebx
80100867:	89 c7                	mov    %eax,%edi
80100869:	85 c0                	test   %eax,%eax
8010086b:	0f 89 db fe ff ff    	jns    8010074c <consoleintr+0x23>
        }
      }
      break;
    }
  }
  release(&cons.lock);
80100871:	83 ec 0c             	sub    $0xc,%esp
80100874:	68 20 a5 10 80       	push   $0x8010a520
80100879:	e8 b3 38 00 00       	call   80104131 <release>
  if(doprocdump) {
8010087e:	83 c4 10             	add    $0x10,%esp
80100881:	85 f6                	test   %esi,%esi
80100883:	74 26                	je     801008ab <consoleintr+0x182>
    procdump();  // now call procdump() wo. cons.lock held
80100885:	e8 e2 34 00 00       	call   80103d6c <procdump>
  }
}
8010088a:	eb 1f                	jmp    801008ab <consoleintr+0x182>
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010088c:	8d 50 01             	lea    0x1(%eax),%edx
8010088f:	89 15 c8 00 11 80    	mov    %edx,0x801100c8
80100895:	83 e0 7f             	and    $0x7f,%eax
80100898:	c6 80 40 00 11 80 0a 	movb   $0xa,-0x7feeffc0(%eax)
        consputc(c);
8010089f:	b8 0a 00 00 00       	mov    $0xa,%eax
801008a4:	e8 1c fb ff ff       	call   801003c5 <consputc>
801008a9:	eb 99                	jmp    80100844 <consoleintr+0x11b>
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
  }
}
801008ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
801008ae:	5b                   	pop    %ebx
801008af:	5e                   	pop    %esi
801008b0:	5f                   	pop    %edi
801008b1:	5d                   	pop    %ebp
801008b2:	c3                   	ret    

801008b3 <consoleinit>:
  return n;
}

void
consoleinit(void)
{
801008b3:	55                   	push   %ebp
801008b4:	89 e5                	mov    %esp,%ebp
801008b6:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801008b9:	68 48 6d 10 80       	push   $0x80106d48
801008be:	68 20 a5 10 80       	push   $0x8010a520
801008c3:	e8 c0 36 00 00       	call   80103f88 <initlock>

  devsw[CONSOLE].write = consolewrite;
801008c8:	c7 05 8c 0a 11 80 8a 	movl   $0x8010058a,0x80110a8c
801008cf:	05 10 80 
  devsw[CONSOLE].read = consoleread;
801008d2:	c7 05 88 0a 11 80 54 	movl   $0x80100254,0x80110a88
801008d9:	02 10 80 
  cons.locking = 1;
801008dc:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
801008e3:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
801008e6:	83 c4 08             	add    $0x8,%esp
801008e9:	6a 00                	push   $0x0
801008eb:	6a 01                	push   $0x1
801008ed:	e8 17 17 00 00       	call   80102009 <ioapicenable>
}
801008f2:	83 c4 10             	add    $0x10,%esp
801008f5:	c9                   	leave  
801008f6:	c3                   	ret    

801008f7 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
801008f7:	55                   	push   %ebp
801008f8:	89 e5                	mov    %esp,%ebp
801008fa:	57                   	push   %edi
801008fb:	56                   	push   %esi
801008fc:	53                   	push   %ebx
801008fd:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100903:	e8 92 2a 00 00       	call   8010339a <myproc>
80100908:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
8010090e:	e8 9d 1e 00 00       	call   801027b0 <begin_op>

  if((ip = namei(path)) == 0){
80100913:	83 ec 0c             	sub    $0xc,%esp
80100916:	ff 75 08             	pushl  0x8(%ebp)
80100919:	e8 74 13 00 00       	call   80101c92 <namei>
8010091e:	83 c4 10             	add    $0x10,%esp
80100921:	85 c0                	test   %eax,%eax
80100923:	75 1f                	jne    80100944 <exec+0x4d>
    end_op();
80100925:	e8 00 1f 00 00       	call   8010282a <end_op>
    cprintf("exec: fail\n");
8010092a:	83 ec 0c             	sub    $0xc,%esp
8010092d:	68 61 6d 10 80       	push   $0x80106d61
80100932:	e8 b2 fc ff ff       	call   801005e9 <cprintf>
    return -1;
80100937:	83 c4 10             	add    $0x10,%esp
8010093a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010093f:	e9 3a 03 00 00       	jmp    80100c7e <exec+0x387>
80100944:	89 c3                	mov    %eax,%ebx
  }
  ilock(ip);
80100946:	83 ec 0c             	sub    $0xc,%esp
80100949:	50                   	push   %eax
8010094a:	e8 ab 0b 00 00       	call   801014fa <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
8010094f:	6a 34                	push   $0x34
80100951:	6a 00                	push   $0x0
80100953:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100959:	50                   	push   %eax
8010095a:	53                   	push   %ebx
8010095b:	e8 28 0e 00 00       	call   80101788 <readi>
80100960:	83 c4 20             	add    $0x20,%esp
80100963:	83 f8 34             	cmp    $0x34,%eax
80100966:	0f 85 a2 02 00 00    	jne    80100c0e <exec+0x317>
    goto bad;
  if(elf.magic != ELF_MAGIC)
8010096c:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100973:	45 4c 46 
80100976:	0f 85 92 02 00 00    	jne    80100c0e <exec+0x317>
    goto bad;

  if((pgdir = setupkvm()) == 0)
8010097c:	e8 ec 60 00 00       	call   80106a6d <setupkvm>
80100981:	89 c7                	mov    %eax,%edi
80100983:	85 c0                	test   %eax,%eax
80100985:	0f 84 83 02 00 00    	je     80100c0e <exec+0x317>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
8010098b:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80100991:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100998:	00 
80100999:	0f 84 d5 00 00 00    	je     80100a74 <exec+0x17d>
8010099f:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
801009a6:	00 00 00 
801009a9:	be 00 00 00 00       	mov    $0x0,%esi
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
801009ae:	89 bd f0 fe ff ff    	mov    %edi,-0x110(%ebp)
801009b4:	89 c7                	mov    %eax,%edi
801009b6:	6a 20                	push   $0x20
801009b8:	50                   	push   %eax
801009b9:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
801009bf:	50                   	push   %eax
801009c0:	53                   	push   %ebx
801009c1:	e8 c2 0d 00 00       	call   80101788 <readi>
801009c6:	83 c4 10             	add    $0x10,%esp
801009c9:	83 f8 20             	cmp    $0x20,%eax
801009cc:	0f 85 69 02 00 00    	jne    80100c3b <exec+0x344>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
801009d2:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
801009d9:	75 7c                	jne    80100a57 <exec+0x160>
      continue;
    if(ph.memsz < ph.filesz)
801009db:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
801009e1:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
801009e7:	0f 82 56 02 00 00    	jb     80100c43 <exec+0x34c>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
801009ed:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
801009f3:	0f 82 52 02 00 00    	jb     80100c4b <exec+0x354>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
801009f9:	83 ec 04             	sub    $0x4,%esp
801009fc:	50                   	push   %eax
801009fd:	ff b5 ec fe ff ff    	pushl  -0x114(%ebp)
80100a03:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100a09:	e8 05 5f 00 00       	call   80106913 <allocuvm>
80100a0e:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100a14:	83 c4 10             	add    $0x10,%esp
80100a17:	85 c0                	test   %eax,%eax
80100a19:	0f 84 34 02 00 00    	je     80100c53 <exec+0x35c>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100a1f:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100a25:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100a2a:	0f 85 2b 02 00 00    	jne    80100c5b <exec+0x364>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100a30:	83 ec 0c             	sub    $0xc,%esp
80100a33:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100a39:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100a3f:	53                   	push   %ebx
80100a40:	50                   	push   %eax
80100a41:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100a47:	e8 89 5d 00 00       	call   801067d5 <loaduvm>
80100a4c:	83 c4 20             	add    $0x20,%esp
80100a4f:	85 c0                	test   %eax,%eax
80100a51:	0f 88 0c 02 00 00    	js     80100c63 <exec+0x36c>
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a57:	83 c6 01             	add    $0x1,%esi
80100a5a:	8d 47 20             	lea    0x20(%edi),%eax
80100a5d:	0f b7 95 50 ff ff ff 	movzwl -0xb0(%ebp),%edx
80100a64:	39 f2                	cmp    %esi,%edx
80100a66:	0f 8f 48 ff ff ff    	jg     801009b4 <exec+0xbd>
80100a6c:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100a72:	eb 0a                	jmp    80100a7e <exec+0x187>

  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
80100a74:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
80100a7b:	00 00 00 
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100a7e:	83 ec 0c             	sub    $0xc,%esp
80100a81:	53                   	push   %ebx
80100a82:	e8 b6 0c 00 00       	call   8010173d <iunlockput>
  end_op();
80100a87:	e8 9e 1d 00 00       	call   8010282a <end_op>
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100a8c:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100a92:	05 ff 0f 00 00       	add    $0xfff,%eax
80100a97:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100a9c:	83 c4 0c             	add    $0xc,%esp
80100a9f:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
80100aa5:	52                   	push   %edx
80100aa6:	50                   	push   %eax
80100aa7:	57                   	push   %edi
80100aa8:	e8 66 5e 00 00       	call   80106913 <allocuvm>
80100aad:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100ab3:	83 c4 10             	add    $0x10,%esp
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
  end_op();
  ip = 0;
80100ab6:	bb 00 00 00 00       	mov    $0x0,%ebx

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100abb:	85 c0                	test   %eax,%eax
80100abd:	0f 84 a6 01 00 00    	je     80100c69 <exec+0x372>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100ac3:	83 ec 08             	sub    $0x8,%esp
80100ac6:	89 c3                	mov    %eax,%ebx
80100ac8:	2d 00 20 00 00       	sub    $0x2000,%eax
80100acd:	50                   	push   %eax
80100ace:	57                   	push   %edi
80100acf:	e8 25 60 00 00       	call   80106af9 <clearpteu>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100ad4:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ad7:	8b 00                	mov    (%eax),%eax
80100ad9:	83 c4 10             	add    $0x10,%esp
80100adc:	be 00 00 00 00       	mov    $0x0,%esi
80100ae1:	85 c0                	test   %eax,%eax
80100ae3:	75 11                	jne    80100af6 <exec+0x1ff>
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;
80100ae5:	8b 9d f0 fe ff ff    	mov    -0x110(%ebp),%ebx
80100aeb:	eb 59                	jmp    80100b46 <exec+0x24f>

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
80100aed:	83 fe 20             	cmp    $0x20,%esi
80100af0:	0f 84 30 01 00 00    	je     80100c26 <exec+0x32f>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100af6:	83 ec 0c             	sub    $0xc,%esp
80100af9:	50                   	push   %eax
80100afa:	e8 54 38 00 00       	call   80104353 <strlen>
80100aff:	f7 d0                	not    %eax
80100b01:	01 d8                	add    %ebx,%eax
80100b03:	83 e0 fc             	and    $0xfffffffc,%eax
80100b06:	89 c3                	mov    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100b08:	83 c4 04             	add    $0x4,%esp
80100b0b:	8b 45 0c             	mov    0xc(%ebp),%eax
80100b0e:	ff 34 b0             	pushl  (%eax,%esi,4)
80100b11:	e8 3d 38 00 00       	call   80104353 <strlen>
80100b16:	83 c0 01             	add    $0x1,%eax
80100b19:	50                   	push   %eax
80100b1a:	8b 45 0c             	mov    0xc(%ebp),%eax
80100b1d:	ff 34 b0             	pushl  (%eax,%esi,4)
80100b20:	53                   	push   %ebx
80100b21:	57                   	push   %edi
80100b22:	e8 20 61 00 00       	call   80106c47 <copyout>
80100b27:	83 c4 20             	add    $0x20,%esp
80100b2a:	85 c0                	test   %eax,%eax
80100b2c:	0f 88 fb 00 00 00    	js     80100c2d <exec+0x336>
      goto bad;
    ustack[3+argc] = sp;
80100b32:	89 9c b5 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%esi,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100b39:	83 c6 01             	add    $0x1,%esi
80100b3c:	8b 45 0c             	mov    0xc(%ebp),%eax
80100b3f:	8b 04 b0             	mov    (%eax,%esi,4),%eax
80100b42:	85 c0                	test   %eax,%eax
80100b44:	75 a7                	jne    80100aed <exec+0x1f6>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100b46:	c7 84 b5 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%esi,4)
80100b4d:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100b51:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100b58:	ff ff ff 
  ustack[1] = argc;
80100b5b:	89 b5 5c ff ff ff    	mov    %esi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100b61:	8d 04 b5 04 00 00 00 	lea    0x4(,%esi,4),%eax
80100b68:	89 da                	mov    %ebx,%edx
80100b6a:	29 c2                	sub    %eax,%edx
80100b6c:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%ebp)

  sp -= (3+argc+1) * 4;
80100b72:	83 c0 0c             	add    $0xc,%eax
80100b75:	89 de                	mov    %ebx,%esi
80100b77:	29 c6                	sub    %eax,%esi
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100b79:	50                   	push   %eax
80100b7a:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
80100b80:	50                   	push   %eax
80100b81:	56                   	push   %esi
80100b82:	57                   	push   %edi
80100b83:	e8 bf 60 00 00       	call   80106c47 <copyout>
80100b88:	83 c4 10             	add    $0x10,%esp
80100b8b:	85 c0                	test   %eax,%eax
80100b8d:	0f 88 a1 00 00 00    	js     80100c34 <exec+0x33d>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100b93:	8b 45 08             	mov    0x8(%ebp),%eax
80100b96:	0f b6 10             	movzbl (%eax),%edx
80100b99:	84 d2                	test   %dl,%dl
80100b9b:	74 1a                	je     80100bb7 <exec+0x2c0>
80100b9d:	83 c0 01             	add    $0x1,%eax
80100ba0:	8b 4d 08             	mov    0x8(%ebp),%ecx
    if(*s == '/')
      last = s+1;
80100ba3:	80 fa 2f             	cmp    $0x2f,%dl
80100ba6:	0f 44 c8             	cmove  %eax,%ecx
80100ba9:	83 c0 01             	add    $0x1,%eax
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100bac:	0f b6 50 ff          	movzbl -0x1(%eax),%edx
80100bb0:	84 d2                	test   %dl,%dl
80100bb2:	75 ef                	jne    80100ba3 <exec+0x2ac>
80100bb4:	89 4d 08             	mov    %ecx,0x8(%ebp)
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100bb7:	83 ec 04             	sub    $0x4,%esp
80100bba:	6a 10                	push   $0x10
80100bbc:	ff 75 08             	pushl  0x8(%ebp)
80100bbf:	8b 9d f4 fe ff ff    	mov    -0x10c(%ebp),%ebx
80100bc5:	89 d8                	mov    %ebx,%eax
80100bc7:	83 c0 6c             	add    $0x6c,%eax
80100bca:	50                   	push   %eax
80100bcb:	e8 4f 37 00 00       	call   8010431f <safestrcpy>

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
80100bd0:	89 d8                	mov    %ebx,%eax
80100bd2:	8b 5b 04             	mov    0x4(%ebx),%ebx
  curproc->pgdir = pgdir;
80100bd5:	89 78 04             	mov    %edi,0x4(%eax)
  curproc->sz = sz;
80100bd8:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
80100bde:	89 08                	mov    %ecx,(%eax)
  curproc->tf->eip = elf.entry;  // main
80100be0:	89 c1                	mov    %eax,%ecx
80100be2:	8b 40 18             	mov    0x18(%eax),%eax
80100be5:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100beb:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100bee:	8b 41 18             	mov    0x18(%ecx),%eax
80100bf1:	89 70 44             	mov    %esi,0x44(%eax)
  switchuvm(curproc);
80100bf4:	89 0c 24             	mov    %ecx,(%esp)
80100bf7:	e8 7e 5a 00 00       	call   8010667a <switchuvm>
  freevm(oldpgdir);
80100bfc:	89 1c 24             	mov    %ebx,(%esp)
80100bff:	e8 fa 5d 00 00       	call   801069fe <freevm>
  return 0;
80100c04:	83 c4 10             	add    $0x10,%esp
80100c07:	b8 00 00 00 00       	mov    $0x0,%eax
80100c0c:	eb 70                	jmp    80100c7e <exec+0x387>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100c0e:	83 ec 0c             	sub    $0xc,%esp
80100c11:	53                   	push   %ebx
80100c12:	e8 26 0b 00 00       	call   8010173d <iunlockput>
    end_op();
80100c17:	e8 0e 1c 00 00       	call   8010282a <end_op>
80100c1c:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100c1f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c24:	eb 58                	jmp    80100c7e <exec+0x387>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
  end_op();
  ip = 0;
80100c26:	bb 00 00 00 00       	mov    $0x0,%ebx
80100c2b:	eb 3c                	jmp    80100c69 <exec+0x372>
80100c2d:	bb 00 00 00 00       	mov    $0x0,%ebx
80100c32:	eb 35                	jmp    80100c69 <exec+0x372>
80100c34:	bb 00 00 00 00       	mov    $0x0,%ebx
80100c39:	eb 2e                	jmp    80100c69 <exec+0x372>
80100c3b:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c41:	eb 26                	jmp    80100c69 <exec+0x372>
80100c43:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c49:	eb 1e                	jmp    80100c69 <exec+0x372>
80100c4b:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c51:	eb 16                	jmp    80100c69 <exec+0x372>
80100c53:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c59:	eb 0e                	jmp    80100c69 <exec+0x372>
80100c5b:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c61:	eb 06                	jmp    80100c69 <exec+0x372>
80100c63:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100c69:	83 ec 0c             	sub    $0xc,%esp
80100c6c:	57                   	push   %edi
80100c6d:	e8 8c 5d 00 00       	call   801069fe <freevm>
  if(ip){
80100c72:	83 c4 10             	add    $0x10,%esp
80100c75:	85 db                	test   %ebx,%ebx
80100c77:	75 95                	jne    80100c0e <exec+0x317>
    iunlockput(ip);
    end_op();
  }
  return -1;
80100c79:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100c7e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100c81:	5b                   	pop    %ebx
80100c82:	5e                   	pop    %esi
80100c83:	5f                   	pop    %edi
80100c84:	5d                   	pop    %ebp
80100c85:	c3                   	ret    

80100c86 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100c86:	55                   	push   %ebp
80100c87:	89 e5                	mov    %esp,%ebp
80100c89:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100c8c:	68 6d 6d 10 80       	push   $0x80106d6d
80100c91:	68 e0 00 11 80       	push   $0x801100e0
80100c96:	e8 ed 32 00 00       	call   80103f88 <initlock>
}
80100c9b:	83 c4 10             	add    $0x10,%esp
80100c9e:	c9                   	leave  
80100c9f:	c3                   	ret    

80100ca0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100ca0:	55                   	push   %ebp
80100ca1:	89 e5                	mov    %esp,%ebp
80100ca3:	53                   	push   %ebx
80100ca4:	83 ec 10             	sub    $0x10,%esp
  struct file *f;

  acquire(&ftable.lock);
80100ca7:	68 e0 00 11 80       	push   $0x801100e0
80100cac:	e8 bb 33 00 00       	call   8010406c <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
80100cb1:	83 c4 10             	add    $0x10,%esp
80100cb4:	83 3d 18 01 11 80 00 	cmpl   $0x0,0x80110118
80100cbb:	74 0f                	je     80100ccc <filealloc+0x2c>
80100cbd:	bb 14 01 11 80       	mov    $0x80110114,%ebx
80100cc2:	eb 28                	jmp    80100cec <filealloc+0x4c>
80100cc4:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
80100cc8:	75 22                	jne    80100cec <filealloc+0x4c>
80100cca:	eb 05                	jmp    80100cd1 <filealloc+0x31>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100ccc:	bb 14 01 11 80       	mov    $0x80110114,%ebx
    if(f->ref == 0){
      f->ref = 1;
80100cd1:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100cd8:	83 ec 0c             	sub    $0xc,%esp
80100cdb:	68 e0 00 11 80       	push   $0x801100e0
80100ce0:	e8 4c 34 00 00       	call   80104131 <release>
      return f;
80100ce5:	83 c4 10             	add    $0x10,%esp
80100ce8:	89 d8                	mov    %ebx,%eax
80100cea:	eb 20                	jmp    80100d0c <filealloc+0x6c>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100cec:	83 c3 18             	add    $0x18,%ebx
80100cef:	81 fb 74 0a 11 80    	cmp    $0x80110a74,%ebx
80100cf5:	75 cd                	jne    80100cc4 <filealloc+0x24>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100cf7:	83 ec 0c             	sub    $0xc,%esp
80100cfa:	68 e0 00 11 80       	push   $0x801100e0
80100cff:	e8 2d 34 00 00       	call   80104131 <release>
  return 0;
80100d04:	83 c4 10             	add    $0x10,%esp
80100d07:	b8 00 00 00 00       	mov    $0x0,%eax
}
80100d0c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100d0f:	c9                   	leave  
80100d10:	c3                   	ret    

80100d11 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100d11:	55                   	push   %ebp
80100d12:	89 e5                	mov    %esp,%ebp
80100d14:	53                   	push   %ebx
80100d15:	83 ec 10             	sub    $0x10,%esp
80100d18:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100d1b:	68 e0 00 11 80       	push   $0x801100e0
80100d20:	e8 47 33 00 00       	call   8010406c <acquire>
  if(f->ref < 1)
80100d25:	8b 43 04             	mov    0x4(%ebx),%eax
80100d28:	83 c4 10             	add    $0x10,%esp
80100d2b:	85 c0                	test   %eax,%eax
80100d2d:	7f 0d                	jg     80100d3c <filedup+0x2b>
    panic("filedup");
80100d2f:	83 ec 0c             	sub    $0xc,%esp
80100d32:	68 74 6d 10 80       	push   $0x80106d74
80100d37:	e8 11 f6 ff ff       	call   8010034d <panic>
  f->ref++;
80100d3c:	83 c0 01             	add    $0x1,%eax
80100d3f:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100d42:	83 ec 0c             	sub    $0xc,%esp
80100d45:	68 e0 00 11 80       	push   $0x801100e0
80100d4a:	e8 e2 33 00 00       	call   80104131 <release>
  return f;
}
80100d4f:	89 d8                	mov    %ebx,%eax
80100d51:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100d54:	c9                   	leave  
80100d55:	c3                   	ret    

80100d56 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100d56:	55                   	push   %ebp
80100d57:	89 e5                	mov    %esp,%ebp
80100d59:	57                   	push   %edi
80100d5a:	56                   	push   %esi
80100d5b:	53                   	push   %ebx
80100d5c:	83 ec 28             	sub    $0x28,%esp
80100d5f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100d62:	68 e0 00 11 80       	push   $0x801100e0
80100d67:	e8 00 33 00 00       	call   8010406c <acquire>
  if(f->ref < 1)
80100d6c:	8b 43 04             	mov    0x4(%ebx),%eax
80100d6f:	83 c4 10             	add    $0x10,%esp
80100d72:	85 c0                	test   %eax,%eax
80100d74:	7f 0d                	jg     80100d83 <fileclose+0x2d>
    panic("fileclose");
80100d76:	83 ec 0c             	sub    $0xc,%esp
80100d79:	68 7c 6d 10 80       	push   $0x80106d7c
80100d7e:	e8 ca f5 ff ff       	call   8010034d <panic>
  if(--f->ref > 0){
80100d83:	83 e8 01             	sub    $0x1,%eax
80100d86:	89 43 04             	mov    %eax,0x4(%ebx)
80100d89:	85 c0                	test   %eax,%eax
80100d8b:	7e 12                	jle    80100d9f <fileclose+0x49>
    release(&ftable.lock);
80100d8d:	83 ec 0c             	sub    $0xc,%esp
80100d90:	68 e0 00 11 80       	push   $0x801100e0
80100d95:	e8 97 33 00 00       	call   80104131 <release>
80100d9a:	83 c4 10             	add    $0x10,%esp
80100d9d:	eb 64                	jmp    80100e03 <fileclose+0xad>
    return;
  }
  ff = *f;
80100d9f:	8b 33                	mov    (%ebx),%esi
80100da1:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100da5:	88 45 e7             	mov    %al,-0x19(%ebp)
80100da8:	8b 7b 0c             	mov    0xc(%ebx),%edi
80100dab:	8b 43 10             	mov    0x10(%ebx),%eax
80100dae:	89 45 e0             	mov    %eax,-0x20(%ebp)
  f->ref = 0;
80100db1:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
  f->type = FD_NONE;
80100db8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  release(&ftable.lock);
80100dbe:	83 ec 0c             	sub    $0xc,%esp
80100dc1:	68 e0 00 11 80       	push   $0x801100e0
80100dc6:	e8 66 33 00 00       	call   80104131 <release>

  if(ff.type == FD_PIPE)
80100dcb:	83 c4 10             	add    $0x10,%esp
80100dce:	83 fe 01             	cmp    $0x1,%esi
80100dd1:	75 13                	jne    80100de6 <fileclose+0x90>
    pipeclose(ff.pipe, ff.writable);
80100dd3:	83 ec 08             	sub    $0x8,%esp
80100dd6:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
80100dda:	50                   	push   %eax
80100ddb:	57                   	push   %edi
80100ddc:	e8 de 20 00 00       	call   80102ebf <pipeclose>
80100de1:	83 c4 10             	add    $0x10,%esp
80100de4:	eb 1d                	jmp    80100e03 <fileclose+0xad>
  else if(ff.type == FD_INODE){
80100de6:	83 fe 02             	cmp    $0x2,%esi
80100de9:	75 18                	jne    80100e03 <fileclose+0xad>
    begin_op();
80100deb:	e8 c0 19 00 00       	call   801027b0 <begin_op>
    iput(ff.ip);
80100df0:	83 ec 0c             	sub    $0xc,%esp
80100df3:	ff 75 e0             	pushl  -0x20(%ebp)
80100df6:	e8 06 08 00 00       	call   80101601 <iput>
    end_op();
80100dfb:	e8 2a 1a 00 00       	call   8010282a <end_op>
80100e00:	83 c4 10             	add    $0x10,%esp
  }
}
80100e03:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e06:	5b                   	pop    %ebx
80100e07:	5e                   	pop    %esi
80100e08:	5f                   	pop    %edi
80100e09:	5d                   	pop    %ebp
80100e0a:	c3                   	ret    

80100e0b <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100e0b:	55                   	push   %ebp
80100e0c:	89 e5                	mov    %esp,%ebp
80100e0e:	53                   	push   %ebx
80100e0f:	83 ec 04             	sub    $0x4,%esp
80100e12:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100e15:	83 3b 02             	cmpl   $0x2,(%ebx)
80100e18:	75 2e                	jne    80100e48 <filestat+0x3d>
    ilock(f->ip);
80100e1a:	83 ec 0c             	sub    $0xc,%esp
80100e1d:	ff 73 10             	pushl  0x10(%ebx)
80100e20:	e8 d5 06 00 00       	call   801014fa <ilock>
    stati(f->ip, st);
80100e25:	83 c4 08             	add    $0x8,%esp
80100e28:	ff 75 0c             	pushl  0xc(%ebp)
80100e2b:	ff 73 10             	pushl  0x10(%ebx)
80100e2e:	e8 2a 09 00 00       	call   8010175d <stati>
    iunlock(f->ip);
80100e33:	83 c4 04             	add    $0x4,%esp
80100e36:	ff 73 10             	pushl  0x10(%ebx)
80100e39:	e8 7e 07 00 00       	call   801015bc <iunlock>
    return 0;
80100e3e:	83 c4 10             	add    $0x10,%esp
80100e41:	b8 00 00 00 00       	mov    $0x0,%eax
80100e46:	eb 05                	jmp    80100e4d <filestat+0x42>
  }
  return -1;
80100e48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100e4d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e50:	c9                   	leave  
80100e51:	c3                   	ret    

80100e52 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100e52:	55                   	push   %ebp
80100e53:	89 e5                	mov    %esp,%ebp
80100e55:	56                   	push   %esi
80100e56:	53                   	push   %ebx
80100e57:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;

  if(f->readable == 0)
80100e5a:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100e5e:	74 69                	je     80100ec9 <fileread+0x77>
    return -1;
  if(f->type == FD_PIPE)
80100e60:	8b 03                	mov    (%ebx),%eax
80100e62:	83 f8 01             	cmp    $0x1,%eax
80100e65:	75 16                	jne    80100e7d <fileread+0x2b>
    return piperead(f->pipe, addr, n);
80100e67:	83 ec 04             	sub    $0x4,%esp
80100e6a:	ff 75 10             	pushl  0x10(%ebp)
80100e6d:	ff 75 0c             	pushl  0xc(%ebp)
80100e70:	ff 73 0c             	pushl  0xc(%ebx)
80100e73:	e8 d8 21 00 00       	call   80103050 <piperead>
80100e78:	83 c4 10             	add    $0x10,%esp
80100e7b:	eb 51                	jmp    80100ece <fileread+0x7c>
  if(f->type == FD_INODE){
80100e7d:	83 f8 02             	cmp    $0x2,%eax
80100e80:	75 3a                	jne    80100ebc <fileread+0x6a>
    ilock(f->ip);
80100e82:	83 ec 0c             	sub    $0xc,%esp
80100e85:	ff 73 10             	pushl  0x10(%ebx)
80100e88:	e8 6d 06 00 00       	call   801014fa <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100e8d:	ff 75 10             	pushl  0x10(%ebp)
80100e90:	ff 73 14             	pushl  0x14(%ebx)
80100e93:	ff 75 0c             	pushl  0xc(%ebp)
80100e96:	ff 73 10             	pushl  0x10(%ebx)
80100e99:	e8 ea 08 00 00       	call   80101788 <readi>
80100e9e:	89 c6                	mov    %eax,%esi
80100ea0:	83 c4 20             	add    $0x20,%esp
80100ea3:	85 c0                	test   %eax,%eax
80100ea5:	7e 03                	jle    80100eaa <fileread+0x58>
      f->off += r;
80100ea7:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100eaa:	83 ec 0c             	sub    $0xc,%esp
80100ead:	ff 73 10             	pushl  0x10(%ebx)
80100eb0:	e8 07 07 00 00       	call   801015bc <iunlock>
    return r;
80100eb5:	83 c4 10             	add    $0x10,%esp
80100eb8:	89 f0                	mov    %esi,%eax
80100eba:	eb 12                	jmp    80100ece <fileread+0x7c>
  }
  panic("fileread");
80100ebc:	83 ec 0c             	sub    $0xc,%esp
80100ebf:	68 86 6d 10 80       	push   $0x80106d86
80100ec4:	e8 84 f4 ff ff       	call   8010034d <panic>
fileread(struct file *f, char *addr, int n)
{
  int r;

  if(f->readable == 0)
    return -1;
80100ec9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100ece:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100ed1:	5b                   	pop    %ebx
80100ed2:	5e                   	pop    %esi
80100ed3:	5d                   	pop    %ebp
80100ed4:	c3                   	ret    

80100ed5 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100ed5:	55                   	push   %ebp
80100ed6:	89 e5                	mov    %esp,%ebp
80100ed8:	57                   	push   %edi
80100ed9:	56                   	push   %esi
80100eda:	53                   	push   %ebx
80100edb:	83 ec 1c             	sub    $0x1c,%esp
80100ede:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;

  if(f->writable == 0)
80100ee1:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
80100ee5:	0f 84 cb 00 00 00    	je     80100fb6 <filewrite+0xe1>
    return -1;
  if(f->type == FD_PIPE)
80100eeb:	8b 06                	mov    (%esi),%eax
80100eed:	83 f8 01             	cmp    $0x1,%eax
80100ef0:	75 19                	jne    80100f0b <filewrite+0x36>
    return pipewrite(f->pipe, addr, n);
80100ef2:	83 ec 04             	sub    $0x4,%esp
80100ef5:	ff 75 10             	pushl  0x10(%ebp)
80100ef8:	ff 75 0c             	pushl  0xc(%ebp)
80100efb:	ff 76 0c             	pushl  0xc(%esi)
80100efe:	e8 48 20 00 00       	call   80102f4b <pipewrite>
80100f03:	83 c4 10             	add    $0x10,%esp
80100f06:	e9 b0 00 00 00       	jmp    80100fbb <filewrite+0xe6>
  if(f->type == FD_INODE){
80100f0b:	83 f8 02             	cmp    $0x2,%eax
80100f0e:	0f 85 95 00 00 00    	jne    80100fa9 <filewrite+0xd4>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80100f14:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100f18:	7e 7d                	jle    80100f97 <filewrite+0xc2>
80100f1a:	bf 00 00 00 00       	mov    $0x0,%edi
      int n1 = n - i;
80100f1f:	8b 45 10             	mov    0x10(%ebp),%eax
80100f22:	29 f8                	sub    %edi,%eax
80100f24:	3d 00 06 00 00       	cmp    $0x600,%eax
80100f29:	ba 00 06 00 00       	mov    $0x600,%edx
80100f2e:	0f 4f c2             	cmovg  %edx,%eax
80100f31:	89 c3                	mov    %eax,%ebx
80100f33:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(n1 > max)
        n1 = max;

      begin_op();
80100f36:	e8 75 18 00 00       	call   801027b0 <begin_op>
      ilock(f->ip);
80100f3b:	83 ec 0c             	sub    $0xc,%esp
80100f3e:	ff 76 10             	pushl  0x10(%esi)
80100f41:	e8 b4 05 00 00       	call   801014fa <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80100f46:	53                   	push   %ebx
80100f47:	ff 76 14             	pushl  0x14(%esi)
80100f4a:	89 f8                	mov    %edi,%eax
80100f4c:	03 45 0c             	add    0xc(%ebp),%eax
80100f4f:	50                   	push   %eax
80100f50:	ff 76 10             	pushl  0x10(%esi)
80100f53:	e8 33 09 00 00       	call   8010188b <writei>
80100f58:	89 c3                	mov    %eax,%ebx
80100f5a:	83 c4 20             	add    $0x20,%esp
80100f5d:	85 c0                	test   %eax,%eax
80100f5f:	7e 03                	jle    80100f64 <filewrite+0x8f>
        f->off += r;
80100f61:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
80100f64:	83 ec 0c             	sub    $0xc,%esp
80100f67:	ff 76 10             	pushl  0x10(%esi)
80100f6a:	e8 4d 06 00 00       	call   801015bc <iunlock>
      end_op();
80100f6f:	e8 b6 18 00 00       	call   8010282a <end_op>

      if(r < 0)
80100f74:	83 c4 10             	add    $0x10,%esp
80100f77:	85 db                	test   %ebx,%ebx
80100f79:	78 21                	js     80100f9c <filewrite+0xc7>
        break;
      if(r != n1)
80100f7b:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
80100f7e:	74 0d                	je     80100f8d <filewrite+0xb8>
        panic("short filewrite");
80100f80:	83 ec 0c             	sub    $0xc,%esp
80100f83:	68 8f 6d 10 80       	push   $0x80106d8f
80100f88:	e8 c0 f3 ff ff       	call   8010034d <panic>
      i += r;
80100f8d:	03 7d e4             	add    -0x1c(%ebp),%edi
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80100f90:	39 7d 10             	cmp    %edi,0x10(%ebp)
80100f93:	7f 8a                	jg     80100f1f <filewrite+0x4a>
80100f95:	eb 05                	jmp    80100f9c <filewrite+0xc7>
80100f97:	bf 00 00 00 00       	mov    $0x0,%edi
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
80100f9c:	39 7d 10             	cmp    %edi,0x10(%ebp)
80100f9f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100fa4:	0f 44 c7             	cmove  %edi,%eax
80100fa7:	eb 12                	jmp    80100fbb <filewrite+0xe6>
  }
  panic("filewrite");
80100fa9:	83 ec 0c             	sub    $0xc,%esp
80100fac:	68 95 6d 10 80       	push   $0x80106d95
80100fb1:	e8 97 f3 ff ff       	call   8010034d <panic>
filewrite(struct file *f, char *addr, int n)
{
  int r;

  if(f->writable == 0)
    return -1;
80100fb6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
80100fbb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fbe:	5b                   	pop    %ebx
80100fbf:	5e                   	pop    %esi
80100fc0:	5f                   	pop    %edi
80100fc1:	5d                   	pop    %ebp
80100fc2:	c3                   	ret    

80100fc3 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80100fc3:	55                   	push   %ebp
80100fc4:	89 e5                	mov    %esp,%ebp
80100fc6:	57                   	push   %edi
80100fc7:	56                   	push   %esi
80100fc8:	53                   	push   %ebx
80100fc9:	83 ec 2c             	sub    $0x2c,%esp
80100fcc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80100fcf:	83 3d e0 0a 11 80 00 	cmpl   $0x0,0x80110ae0
80100fd6:	0f 84 d1 00 00 00    	je     801010ad <balloc+0xea>
80100fdc:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80100fe3:	83 ec 08             	sub    $0x8,%esp
80100fe6:	8b 7d d8             	mov    -0x28(%ebp),%edi
80100fe9:	89 f8                	mov    %edi,%eax
80100feb:	05 ff 0f 00 00       	add    $0xfff,%eax
80100ff0:	89 fe                	mov    %edi,%esi
80100ff2:	85 ff                	test   %edi,%edi
80100ff4:	0f 49 c7             	cmovns %edi,%eax
80100ff7:	c1 f8 0c             	sar    $0xc,%eax
80100ffa:	03 05 f8 0a 11 80    	add    0x80110af8,%eax
80101000:	50                   	push   %eax
80101001:	ff 75 d4             	pushl  -0x2c(%ebp)
80101004:	e8 a1 f0 ff ff       	call   801000aa <bread>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101009:	8b 0d e0 0a 11 80    	mov    0x80110ae0,%ecx
8010100f:	83 c4 10             	add    $0x10,%esp
80101012:	39 cf                	cmp    %ecx,%edi
80101014:	73 75                	jae    8010108b <balloc+0xc8>
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101016:	0f b6 50 5c          	movzbl 0x5c(%eax),%edx
8010101a:	f6 c2 01             	test   $0x1,%dl
8010101d:	74 43                	je     80101062 <balloc+0x9f>
8010101f:	29 f9                	sub    %edi,%ecx
80101021:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101024:	bb 01 00 00 00       	mov    $0x1,%ebx
80101029:	eb 55                	jmp    80101080 <balloc+0xbd>
      m = 1 << (bi % 8);
8010102b:	89 da                	mov    %ebx,%edx
8010102d:	c1 fa 1f             	sar    $0x1f,%edx
80101030:	c1 ea 1d             	shr    $0x1d,%edx
80101033:	8d 0c 13             	lea    (%ebx,%edx,1),%ecx
80101036:	83 e1 07             	and    $0x7,%ecx
80101039:	29 d1                	sub    %edx,%ecx
8010103b:	bf 01 00 00 00       	mov    $0x1,%edi
80101040:	d3 e7                	shl    %cl,%edi
80101042:	89 f9                	mov    %edi,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101044:	8d 53 07             	lea    0x7(%ebx),%edx
80101047:	85 db                	test   %ebx,%ebx
80101049:	0f 49 d3             	cmovns %ebx,%edx
8010104c:	c1 fa 03             	sar    $0x3,%edx
8010104f:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101052:	0f b6 54 10 5c       	movzbl 0x5c(%eax,%edx,1),%edx
80101057:	0f b6 fa             	movzbl %dl,%edi
8010105a:	85 cf                	test   %ecx,%edi
8010105c:	75 17                	jne    80101075 <balloc+0xb2>
8010105e:	89 c6                	mov    %eax,%esi
80101060:	eb 58                	jmp    801010ba <balloc+0xf7>
80101062:	89 c6                	mov    %eax,%esi
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101064:	89 7d e0             	mov    %edi,-0x20(%ebp)
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101067:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
8010106e:	b9 01 00 00 00       	mov    $0x1,%ecx
80101073:	eb 45                	jmp    801010ba <balloc+0xf7>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101075:	83 c3 01             	add    $0x1,%ebx
80101078:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
8010107e:	74 0b                	je     8010108b <balloc+0xc8>
80101080:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
80101083:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101086:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
80101089:	75 a0                	jne    8010102b <balloc+0x68>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
8010108b:	83 ec 0c             	sub    $0xc,%esp
8010108e:	50                   	push   %eax
8010108f:	e8 2d f1 ff ff       	call   801001c1 <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101094:	81 45 d8 00 10 00 00 	addl   $0x1000,-0x28(%ebp)
8010109b:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010109e:	83 c4 10             	add    $0x10,%esp
801010a1:	39 05 e0 0a 11 80    	cmp    %eax,0x80110ae0
801010a7:	0f 87 36 ff ff ff    	ja     80100fe3 <balloc+0x20>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
801010ad:	83 ec 0c             	sub    $0xc,%esp
801010b0:	68 9f 6d 10 80       	push   $0x80106d9f
801010b5:	e8 93 f2 ff ff       	call   8010034d <panic>
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
801010ba:	09 ca                	or     %ecx,%edx
801010bc:	8b 45 dc             	mov    -0x24(%ebp),%eax
801010bf:	88 54 06 5c          	mov    %dl,0x5c(%esi,%eax,1)
        log_write(bp);
801010c3:	83 ec 0c             	sub    $0xc,%esp
801010c6:	56                   	push   %esi
801010c7:	e8 aa 18 00 00       	call   80102976 <log_write>
        brelse(bp);
801010cc:	89 34 24             	mov    %esi,(%esp)
801010cf:	e8 ed f0 ff ff       	call   801001c1 <brelse>
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
801010d4:	83 c4 08             	add    $0x8,%esp
801010d7:	ff 75 e0             	pushl  -0x20(%ebp)
801010da:	ff 75 d4             	pushl  -0x2c(%ebp)
801010dd:	e8 c8 ef ff ff       	call   801000aa <bread>
801010e2:	89 c6                	mov    %eax,%esi
  memset(bp->data, 0, BSIZE);
801010e4:	83 c4 0c             	add    $0xc,%esp
801010e7:	68 00 02 00 00       	push   $0x200
801010ec:	6a 00                	push   $0x0
801010ee:	8d 40 5c             	lea    0x5c(%eax),%eax
801010f1:	50                   	push   %eax
801010f2:	e8 81 30 00 00       	call   80104178 <memset>
  log_write(bp);
801010f7:	89 34 24             	mov    %esi,(%esp)
801010fa:	e8 77 18 00 00       	call   80102976 <log_write>
  brelse(bp);
801010ff:	89 34 24             	mov    %esi,(%esp)
80101102:	e8 ba f0 ff ff       	call   801001c1 <brelse>
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
80101107:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010110a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010110d:	5b                   	pop    %ebx
8010110e:	5e                   	pop    %esi
8010110f:	5f                   	pop    %edi
80101110:	5d                   	pop    %ebp
80101111:	c3                   	ret    

80101112 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101112:	55                   	push   %ebp
80101113:	89 e5                	mov    %esp,%ebp
80101115:	57                   	push   %edi
80101116:	56                   	push   %esi
80101117:	53                   	push   %ebx
80101118:	83 ec 1c             	sub    $0x1c,%esp
8010111b:	89 c6                	mov    %eax,%esi
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010111d:	83 fa 0b             	cmp    $0xb,%edx
80101120:	77 18                	ja     8010113a <bmap+0x28>
80101122:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
80101125:	8b 57 5c             	mov    0x5c(%edi),%edx
80101128:	89 d0                	mov    %edx,%eax
8010112a:	85 d2                	test   %edx,%edx
8010112c:	75 7f                	jne    801011ad <bmap+0x9b>
      ip->addrs[bn] = addr = balloc(ip->dev);
8010112e:	8b 06                	mov    (%esi),%eax
80101130:	e8 8e fe ff ff       	call   80100fc3 <balloc>
80101135:	89 47 5c             	mov    %eax,0x5c(%edi)
80101138:	eb 73                	jmp    801011ad <bmap+0x9b>
    return addr;
  }
  bn -= NDIRECT;
8010113a:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
8010113d:	83 fb 7f             	cmp    $0x7f,%ebx
80101140:	77 5e                	ja     801011a0 <bmap+0x8e>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101142:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101148:	85 c0                	test   %eax,%eax
8010114a:	75 0d                	jne    80101159 <bmap+0x47>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
8010114c:	8b 06                	mov    (%esi),%eax
8010114e:	e8 70 fe ff ff       	call   80100fc3 <balloc>
80101153:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
    bp = bread(ip->dev, addr);
80101159:	83 ec 08             	sub    $0x8,%esp
8010115c:	50                   	push   %eax
8010115d:	ff 36                	pushl  (%esi)
8010115f:	e8 46 ef ff ff       	call   801000aa <bread>
80101164:	89 c7                	mov    %eax,%edi
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101166:	8d 44 98 5c          	lea    0x5c(%eax,%ebx,4),%eax
8010116a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010116d:	8b 18                	mov    (%eax),%ebx
8010116f:	83 c4 10             	add    $0x10,%esp
80101172:	85 db                	test   %ebx,%ebx
80101174:	75 1a                	jne    80101190 <bmap+0x7e>
      a[bn] = addr = balloc(ip->dev);
80101176:	8b 06                	mov    (%esi),%eax
80101178:	e8 46 fe ff ff       	call   80100fc3 <balloc>
8010117d:	89 c3                	mov    %eax,%ebx
8010117f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101182:	89 18                	mov    %ebx,(%eax)
      log_write(bp);
80101184:	83 ec 0c             	sub    $0xc,%esp
80101187:	57                   	push   %edi
80101188:	e8 e9 17 00 00       	call   80102976 <log_write>
8010118d:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101190:	83 ec 0c             	sub    $0xc,%esp
80101193:	57                   	push   %edi
80101194:	e8 28 f0 ff ff       	call   801001c1 <brelse>
    return addr;
80101199:	83 c4 10             	add    $0x10,%esp
8010119c:	89 d8                	mov    %ebx,%eax
8010119e:	eb 0d                	jmp    801011ad <bmap+0x9b>
  }

  panic("bmap: out of range");
801011a0:	83 ec 0c             	sub    $0xc,%esp
801011a3:	68 b5 6d 10 80       	push   $0x80106db5
801011a8:	e8 a0 f1 ff ff       	call   8010034d <panic>
}
801011ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011b0:	5b                   	pop    %ebx
801011b1:	5e                   	pop    %esi
801011b2:	5f                   	pop    %edi
801011b3:	5d                   	pop    %ebp
801011b4:	c3                   	ret    

801011b5 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801011b5:	55                   	push   %ebp
801011b6:	89 e5                	mov    %esp,%ebp
801011b8:	57                   	push   %edi
801011b9:	56                   	push   %esi
801011ba:	53                   	push   %ebx
801011bb:	83 ec 28             	sub    $0x28,%esp
801011be:	89 c6                	mov    %eax,%esi
801011c0:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
801011c3:	68 00 0b 11 80       	push   $0x80110b00
801011c8:	e8 9f 2e 00 00       	call   8010406c <acquire>
801011cd:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
801011d0:	bf 00 00 00 00       	mov    $0x0,%edi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801011d5:	bb 34 0b 11 80       	mov    $0x80110b34,%ebx
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801011da:	8b 43 08             	mov    0x8(%ebx),%eax
801011dd:	85 c0                	test   %eax,%eax
801011df:	7e 26                	jle    80101207 <iget+0x52>
801011e1:	39 33                	cmp    %esi,(%ebx)
801011e3:	75 22                	jne    80101207 <iget+0x52>
801011e5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801011e8:	39 4b 04             	cmp    %ecx,0x4(%ebx)
801011eb:	75 1a                	jne    80101207 <iget+0x52>
      ip->ref++;
801011ed:	83 c0 01             	add    $0x1,%eax
801011f0:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
801011f3:	83 ec 0c             	sub    $0xc,%esp
801011f6:	68 00 0b 11 80       	push   $0x80110b00
801011fb:	e8 31 2f 00 00       	call   80104131 <release>
      return ip;
80101200:	83 c4 10             	add    $0x10,%esp
80101203:	89 df                	mov    %ebx,%edi
80101205:	eb 53                	jmp    8010125a <iget+0xa5>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101207:	85 c0                	test   %eax,%eax
80101209:	75 0a                	jne    80101215 <iget+0x60>
8010120b:	85 ff                	test   %edi,%edi
8010120d:	0f 94 c0             	sete   %al
80101210:	84 c0                	test   %al,%al
80101212:	0f 45 fb             	cmovne %ebx,%edi

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101215:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010121b:	81 fb 54 27 11 80    	cmp    $0x80112754,%ebx
80101221:	75 b7                	jne    801011da <iget+0x25>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101223:	85 ff                	test   %edi,%edi
80101225:	75 0d                	jne    80101234 <iget+0x7f>
    panic("iget: no inodes");
80101227:	83 ec 0c             	sub    $0xc,%esp
8010122a:	68 c8 6d 10 80       	push   $0x80106dc8
8010122f:	e8 19 f1 ff ff       	call   8010034d <panic>

  ip = empty;
  ip->dev = dev;
80101234:	89 37                	mov    %esi,(%edi)
  ip->inum = inum;
80101236:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101239:	89 47 04             	mov    %eax,0x4(%edi)
  ip->ref = 1;
8010123c:	c7 47 08 01 00 00 00 	movl   $0x1,0x8(%edi)
  ip->valid = 0;
80101243:	c7 47 4c 00 00 00 00 	movl   $0x0,0x4c(%edi)
  release(&icache.lock);
8010124a:	83 ec 0c             	sub    $0xc,%esp
8010124d:	68 00 0b 11 80       	push   $0x80110b00
80101252:	e8 da 2e 00 00       	call   80104131 <release>

  return ip;
80101257:	83 c4 10             	add    $0x10,%esp
}
8010125a:	89 f8                	mov    %edi,%eax
8010125c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010125f:	5b                   	pop    %ebx
80101260:	5e                   	pop    %esi
80101261:	5f                   	pop    %edi
80101262:	5d                   	pop    %ebp
80101263:	c3                   	ret    

80101264 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101264:	55                   	push   %ebp
80101265:	89 e5                	mov    %esp,%ebp
80101267:	53                   	push   %ebx
80101268:	83 ec 0c             	sub    $0xc,%esp
  struct buf *bp;

  bp = bread(dev, 1);
8010126b:	6a 01                	push   $0x1
8010126d:	ff 75 08             	pushl  0x8(%ebp)
80101270:	e8 35 ee ff ff       	call   801000aa <bread>
80101275:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101277:	83 c4 0c             	add    $0xc,%esp
8010127a:	6a 1c                	push   $0x1c
8010127c:	8d 40 5c             	lea    0x5c(%eax),%eax
8010127f:	50                   	push   %eax
80101280:	ff 75 0c             	pushl  0xc(%ebp)
80101283:	e8 8a 2f 00 00       	call   80104212 <memmove>
  brelse(bp);
80101288:	89 1c 24             	mov    %ebx,(%esp)
8010128b:	e8 31 ef ff ff       	call   801001c1 <brelse>
}
80101290:	83 c4 10             	add    $0x10,%esp
80101293:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101296:	c9                   	leave  
80101297:	c3                   	ret    

80101298 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101298:	55                   	push   %ebp
80101299:	89 e5                	mov    %esp,%ebp
8010129b:	56                   	push   %esi
8010129c:	53                   	push   %ebx
8010129d:	89 c6                	mov    %eax,%esi
8010129f:	89 d3                	mov    %edx,%ebx
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
801012a1:	83 ec 08             	sub    $0x8,%esp
801012a4:	68 e0 0a 11 80       	push   $0x80110ae0
801012a9:	50                   	push   %eax
801012aa:	e8 b5 ff ff ff       	call   80101264 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
801012af:	83 c4 08             	add    $0x8,%esp
801012b2:	89 d8                	mov    %ebx,%eax
801012b4:	c1 e8 0c             	shr    $0xc,%eax
801012b7:	03 05 f8 0a 11 80    	add    0x80110af8,%eax
801012bd:	50                   	push   %eax
801012be:	56                   	push   %esi
801012bf:	e8 e6 ed ff ff       	call   801000aa <bread>
801012c4:	89 c6                	mov    %eax,%esi
  bi = b % BPB;
801012c6:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
  m = 1 << (bi % 8);
801012cc:	89 d9                	mov    %ebx,%ecx
801012ce:	83 e1 07             	and    $0x7,%ecx
801012d1:	b8 01 00 00 00       	mov    $0x1,%eax
801012d6:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
801012d8:	83 c4 10             	add    $0x10,%esp
801012db:	c1 fb 03             	sar    $0x3,%ebx
801012de:	0f b6 54 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%edx
801012e3:	0f b6 ca             	movzbl %dl,%ecx
801012e6:	85 c1                	test   %eax,%ecx
801012e8:	75 0d                	jne    801012f7 <bfree+0x5f>
    panic("freeing free block");
801012ea:	83 ec 0c             	sub    $0xc,%esp
801012ed:	68 d8 6d 10 80       	push   $0x80106dd8
801012f2:	e8 56 f0 ff ff       	call   8010034d <panic>
  bp->data[bi/8] &= ~m;
801012f7:	f7 d0                	not    %eax
801012f9:	21 d0                	and    %edx,%eax
801012fb:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
801012ff:	83 ec 0c             	sub    $0xc,%esp
80101302:	56                   	push   %esi
80101303:	e8 6e 16 00 00       	call   80102976 <log_write>
  brelse(bp);
80101308:	89 34 24             	mov    %esi,(%esp)
8010130b:	e8 b1 ee ff ff       	call   801001c1 <brelse>
}
80101310:	83 c4 10             	add    $0x10,%esp
80101313:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101316:	5b                   	pop    %ebx
80101317:	5e                   	pop    %esi
80101318:	5d                   	pop    %ebp
80101319:	c3                   	ret    

8010131a <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
8010131a:	55                   	push   %ebp
8010131b:	89 e5                	mov    %esp,%ebp
8010131d:	56                   	push   %esi
8010131e:	53                   	push   %ebx
  int i = 0;
  
  initlock(&icache.lock, "icache");
8010131f:	83 ec 08             	sub    $0x8,%esp
80101322:	68 eb 6d 10 80       	push   $0x80106deb
80101327:	68 00 0b 11 80       	push   $0x80110b00
8010132c:	e8 57 2c 00 00       	call   80103f88 <initlock>
80101331:	bb 40 0b 11 80       	mov    $0x80110b40,%ebx
80101336:	be 60 27 11 80       	mov    $0x80112760,%esi
8010133b:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NINODE; i++) {
    initsleeplock(&icache.inode[i].lock, "inode");
8010133e:	83 ec 08             	sub    $0x8,%esp
80101341:	68 f2 6d 10 80       	push   $0x80106df2
80101346:	53                   	push   %ebx
80101347:	e8 55 2b 00 00       	call   80103ea1 <initsleeplock>
8010134c:	81 c3 90 00 00 00    	add    $0x90,%ebx
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
80101352:	83 c4 10             	add    $0x10,%esp
80101355:	39 f3                	cmp    %esi,%ebx
80101357:	75 e5                	jne    8010133e <iinit+0x24>
    initsleeplock(&icache.inode[i].lock, "inode");
  }

  readsb(dev, &sb);
80101359:	83 ec 08             	sub    $0x8,%esp
8010135c:	68 e0 0a 11 80       	push   $0x80110ae0
80101361:	ff 75 08             	pushl  0x8(%ebp)
80101364:	e8 fb fe ff ff       	call   80101264 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101369:	ff 35 f8 0a 11 80    	pushl  0x80110af8
8010136f:	ff 35 f4 0a 11 80    	pushl  0x80110af4
80101375:	ff 35 f0 0a 11 80    	pushl  0x80110af0
8010137b:	ff 35 ec 0a 11 80    	pushl  0x80110aec
80101381:	ff 35 e8 0a 11 80    	pushl  0x80110ae8
80101387:	ff 35 e4 0a 11 80    	pushl  0x80110ae4
8010138d:	ff 35 e0 0a 11 80    	pushl  0x80110ae0
80101393:	68 58 6e 10 80       	push   $0x80106e58
80101398:	e8 4c f2 ff ff       	call   801005e9 <cprintf>
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
8010139d:	83 c4 30             	add    $0x30,%esp
801013a0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801013a3:	5b                   	pop    %ebx
801013a4:	5e                   	pop    %esi
801013a5:	5d                   	pop    %ebp
801013a6:	c3                   	ret    

801013a7 <ialloc>:
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
801013a7:	55                   	push   %ebp
801013a8:	89 e5                	mov    %esp,%ebp
801013aa:	57                   	push   %edi
801013ab:	56                   	push   %esi
801013ac:	53                   	push   %ebx
801013ad:	83 ec 1c             	sub    $0x1c,%esp
801013b0:	8b 45 0c             	mov    0xc(%ebp),%eax
801013b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801013b6:	83 3d e8 0a 11 80 01 	cmpl   $0x1,0x80110ae8
801013bd:	76 4d                	jbe    8010140c <ialloc+0x65>
801013bf:	bb 01 00 00 00       	mov    $0x1,%ebx
801013c4:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
    bp = bread(dev, IBLOCK(inum, sb));
801013c7:	83 ec 08             	sub    $0x8,%esp
801013ca:	89 d8                	mov    %ebx,%eax
801013cc:	c1 e8 03             	shr    $0x3,%eax
801013cf:	03 05 f4 0a 11 80    	add    0x80110af4,%eax
801013d5:	50                   	push   %eax
801013d6:	ff 75 08             	pushl  0x8(%ebp)
801013d9:	e8 cc ec ff ff       	call   801000aa <bread>
801013de:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + inum%IPB;
801013e0:	89 d8                	mov    %ebx,%eax
801013e2:	83 e0 07             	and    $0x7,%eax
801013e5:	c1 e0 06             	shl    $0x6,%eax
801013e8:	8d 7c 06 5c          	lea    0x5c(%esi,%eax,1),%edi
    if(dip->type == 0){  // a free inode
801013ec:	83 c4 10             	add    $0x10,%esp
801013ef:	66 83 3f 00          	cmpw   $0x0,(%edi)
801013f3:	74 24                	je     80101419 <ialloc+0x72>
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
801013f5:	83 ec 0c             	sub    $0xc,%esp
801013f8:	56                   	push   %esi
801013f9:	e8 c3 ed ff ff       	call   801001c1 <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801013fe:	83 c3 01             	add    $0x1,%ebx
80101401:	83 c4 10             	add    $0x10,%esp
80101404:	39 1d e8 0a 11 80    	cmp    %ebx,0x80110ae8
8010140a:	77 b8                	ja     801013c4 <ialloc+0x1d>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
8010140c:	83 ec 0c             	sub    $0xc,%esp
8010140f:	68 f8 6d 10 80       	push   $0x80106df8
80101414:	e8 34 ef ff ff       	call   8010034d <panic>

  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
80101419:	83 ec 04             	sub    $0x4,%esp
8010141c:	6a 40                	push   $0x40
8010141e:	6a 00                	push   $0x0
80101420:	57                   	push   %edi
80101421:	e8 52 2d 00 00       	call   80104178 <memset>
      dip->type = type;
80101426:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
8010142a:	66 89 07             	mov    %ax,(%edi)
      log_write(bp);   // mark it allocated on the disk
8010142d:	89 34 24             	mov    %esi,(%esp)
80101430:	e8 41 15 00 00       	call   80102976 <log_write>
      brelse(bp);
80101435:	89 34 24             	mov    %esi,(%esp)
80101438:	e8 84 ed ff ff       	call   801001c1 <brelse>
      return iget(dev, inum);
8010143d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101440:	8b 45 08             	mov    0x8(%ebp),%eax
80101443:	e8 6d fd ff ff       	call   801011b5 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
80101448:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010144b:	5b                   	pop    %ebx
8010144c:	5e                   	pop    %esi
8010144d:	5f                   	pop    %edi
8010144e:	5d                   	pop    %ebp
8010144f:	c3                   	ret    

80101450 <iupdate>:
// Must be called after every change to an ip->xxx field
// that lives on disk, since i-node cache is write-through.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
80101450:	55                   	push   %ebp
80101451:	89 e5                	mov    %esp,%ebp
80101453:	56                   	push   %esi
80101454:	53                   	push   %ebx
80101455:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101458:	83 ec 08             	sub    $0x8,%esp
8010145b:	8b 43 04             	mov    0x4(%ebx),%eax
8010145e:	c1 e8 03             	shr    $0x3,%eax
80101461:	03 05 f4 0a 11 80    	add    0x80110af4,%eax
80101467:	50                   	push   %eax
80101468:	ff 33                	pushl  (%ebx)
8010146a:	e8 3b ec ff ff       	call   801000aa <bread>
8010146f:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101471:	8b 43 04             	mov    0x4(%ebx),%eax
80101474:	83 e0 07             	and    $0x7,%eax
80101477:	c1 e0 06             	shl    $0x6,%eax
8010147a:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
8010147e:	0f b7 53 50          	movzwl 0x50(%ebx),%edx
80101482:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101485:	0f b7 53 52          	movzwl 0x52(%ebx),%edx
80101489:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
8010148d:	0f b7 53 54          	movzwl 0x54(%ebx),%edx
80101491:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
80101495:	0f b7 53 56          	movzwl 0x56(%ebx),%edx
80101499:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
8010149d:	8b 53 58             	mov    0x58(%ebx),%edx
801014a0:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801014a3:	83 c4 0c             	add    $0xc,%esp
801014a6:	6a 34                	push   $0x34
801014a8:	83 c3 5c             	add    $0x5c,%ebx
801014ab:	53                   	push   %ebx
801014ac:	83 c0 0c             	add    $0xc,%eax
801014af:	50                   	push   %eax
801014b0:	e8 5d 2d 00 00       	call   80104212 <memmove>
  log_write(bp);
801014b5:	89 34 24             	mov    %esi,(%esp)
801014b8:	e8 b9 14 00 00       	call   80102976 <log_write>
  brelse(bp);
801014bd:	89 34 24             	mov    %esi,(%esp)
801014c0:	e8 fc ec ff ff       	call   801001c1 <brelse>
}
801014c5:	83 c4 10             	add    $0x10,%esp
801014c8:	8d 65 f8             	lea    -0x8(%ebp),%esp
801014cb:	5b                   	pop    %ebx
801014cc:	5e                   	pop    %esi
801014cd:	5d                   	pop    %ebp
801014ce:	c3                   	ret    

801014cf <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
801014cf:	55                   	push   %ebp
801014d0:	89 e5                	mov    %esp,%ebp
801014d2:	53                   	push   %ebx
801014d3:	83 ec 10             	sub    $0x10,%esp
801014d6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801014d9:	68 00 0b 11 80       	push   $0x80110b00
801014de:	e8 89 2b 00 00       	call   8010406c <acquire>
  ip->ref++;
801014e3:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801014e7:	c7 04 24 00 0b 11 80 	movl   $0x80110b00,(%esp)
801014ee:	e8 3e 2c 00 00       	call   80104131 <release>
  return ip;
}
801014f3:	89 d8                	mov    %ebx,%eax
801014f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801014f8:	c9                   	leave  
801014f9:	c3                   	ret    

801014fa <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
801014fa:	55                   	push   %ebp
801014fb:	89 e5                	mov    %esp,%ebp
801014fd:	56                   	push   %esi
801014fe:	53                   	push   %ebx
801014ff:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101502:	85 db                	test   %ebx,%ebx
80101504:	74 06                	je     8010150c <ilock+0x12>
80101506:	83 7b 08 00          	cmpl   $0x0,0x8(%ebx)
8010150a:	7f 0d                	jg     80101519 <ilock+0x1f>
    panic("ilock");
8010150c:	83 ec 0c             	sub    $0xc,%esp
8010150f:	68 0a 6e 10 80       	push   $0x80106e0a
80101514:	e8 34 ee ff ff       	call   8010034d <panic>

  acquiresleep(&ip->lock);
80101519:	83 ec 0c             	sub    $0xc,%esp
8010151c:	8d 43 0c             	lea    0xc(%ebx),%eax
8010151f:	50                   	push   %eax
80101520:	e8 af 29 00 00       	call   80103ed4 <acquiresleep>

  if(ip->valid == 0){
80101525:	83 c4 10             	add    $0x10,%esp
80101528:	83 7b 4c 00          	cmpl   $0x0,0x4c(%ebx)
8010152c:	0f 85 83 00 00 00    	jne    801015b5 <ilock+0xbb>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101532:	83 ec 08             	sub    $0x8,%esp
80101535:	8b 43 04             	mov    0x4(%ebx),%eax
80101538:	c1 e8 03             	shr    $0x3,%eax
8010153b:	03 05 f4 0a 11 80    	add    0x80110af4,%eax
80101541:	50                   	push   %eax
80101542:	ff 33                	pushl  (%ebx)
80101544:	e8 61 eb ff ff       	call   801000aa <bread>
80101549:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010154b:	8b 43 04             	mov    0x4(%ebx),%eax
8010154e:	83 e0 07             	and    $0x7,%eax
80101551:	c1 e0 06             	shl    $0x6,%eax
80101554:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101558:	0f b7 10             	movzwl (%eax),%edx
8010155b:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
8010155f:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101563:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
80101567:	0f b7 50 04          	movzwl 0x4(%eax),%edx
8010156b:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
8010156f:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101573:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
80101577:	8b 50 08             	mov    0x8(%eax),%edx
8010157a:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010157d:	83 c4 0c             	add    $0xc,%esp
80101580:	6a 34                	push   $0x34
80101582:	83 c0 0c             	add    $0xc,%eax
80101585:	50                   	push   %eax
80101586:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101589:	50                   	push   %eax
8010158a:	e8 83 2c 00 00       	call   80104212 <memmove>
    brelse(bp);
8010158f:	89 34 24             	mov    %esi,(%esp)
80101592:	e8 2a ec ff ff       	call   801001c1 <brelse>
    ip->valid = 1;
80101597:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
8010159e:	83 c4 10             	add    $0x10,%esp
801015a1:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
801015a6:	75 0d                	jne    801015b5 <ilock+0xbb>
      panic("ilock: no type");
801015a8:	83 ec 0c             	sub    $0xc,%esp
801015ab:	68 10 6e 10 80       	push   $0x80106e10
801015b0:	e8 98 ed ff ff       	call   8010034d <panic>
  }
}
801015b5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801015b8:	5b                   	pop    %ebx
801015b9:	5e                   	pop    %esi
801015ba:	5d                   	pop    %ebp
801015bb:	c3                   	ret    

801015bc <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
801015bc:	55                   	push   %ebp
801015bd:	89 e5                	mov    %esp,%ebp
801015bf:	56                   	push   %esi
801015c0:	53                   	push   %ebx
801015c1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801015c4:	85 db                	test   %ebx,%ebx
801015c6:	74 19                	je     801015e1 <iunlock+0x25>
801015c8:	8d 73 0c             	lea    0xc(%ebx),%esi
801015cb:	83 ec 0c             	sub    $0xc,%esp
801015ce:	56                   	push   %esi
801015cf:	e8 8d 29 00 00       	call   80103f61 <holdingsleep>
801015d4:	83 c4 10             	add    $0x10,%esp
801015d7:	85 c0                	test   %eax,%eax
801015d9:	74 06                	je     801015e1 <iunlock+0x25>
801015db:	83 7b 08 00          	cmpl   $0x0,0x8(%ebx)
801015df:	7f 0d                	jg     801015ee <iunlock+0x32>
    panic("iunlock");
801015e1:	83 ec 0c             	sub    $0xc,%esp
801015e4:	68 1f 6e 10 80       	push   $0x80106e1f
801015e9:	e8 5f ed ff ff       	call   8010034d <panic>

  releasesleep(&ip->lock);
801015ee:	83 ec 0c             	sub    $0xc,%esp
801015f1:	56                   	push   %esi
801015f2:	e8 2f 29 00 00       	call   80103f26 <releasesleep>
}
801015f7:	83 c4 10             	add    $0x10,%esp
801015fa:	8d 65 f8             	lea    -0x8(%ebp),%esp
801015fd:	5b                   	pop    %ebx
801015fe:	5e                   	pop    %esi
801015ff:	5d                   	pop    %ebp
80101600:	c3                   	ret    

80101601 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101601:	55                   	push   %ebp
80101602:	89 e5                	mov    %esp,%ebp
80101604:	57                   	push   %edi
80101605:	56                   	push   %esi
80101606:	53                   	push   %ebx
80101607:	83 ec 28             	sub    $0x28,%esp
8010160a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
8010160d:	8d 73 0c             	lea    0xc(%ebx),%esi
80101610:	56                   	push   %esi
80101611:	e8 be 28 00 00       	call   80103ed4 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101616:	83 c4 10             	add    $0x10,%esp
80101619:	83 7b 4c 00          	cmpl   $0x0,0x4c(%ebx)
8010161d:	0f 84 ea 00 00 00    	je     8010170d <iput+0x10c>
80101623:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101628:	0f 85 df 00 00 00    	jne    8010170d <iput+0x10c>
    acquire(&icache.lock);
8010162e:	83 ec 0c             	sub    $0xc,%esp
80101631:	68 00 0b 11 80       	push   $0x80110b00
80101636:	e8 31 2a 00 00       	call   8010406c <acquire>
    int r = ip->ref;
8010163b:	8b 7b 08             	mov    0x8(%ebx),%edi
    release(&icache.lock);
8010163e:	c7 04 24 00 0b 11 80 	movl   $0x80110b00,(%esp)
80101645:	e8 e7 2a 00 00       	call   80104131 <release>
    if(r == 1){
8010164a:	83 c4 10             	add    $0x10,%esp
8010164d:	83 ff 01             	cmp    $0x1,%edi
80101650:	0f 85 b7 00 00 00    	jne    8010170d <iput+0x10c>
80101656:	8d 7b 5c             	lea    0x5c(%ebx),%edi
80101659:	8d 83 8c 00 00 00    	lea    0x8c(%ebx),%eax
8010165f:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80101662:	89 c6                	mov    %eax,%esi
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    if(ip->addrs[i]){
80101664:	8b 17                	mov    (%edi),%edx
80101666:	85 d2                	test   %edx,%edx
80101668:	74 0d                	je     80101677 <iput+0x76>
      bfree(ip->dev, ip->addrs[i]);
8010166a:	8b 03                	mov    (%ebx),%eax
8010166c:	e8 27 fc ff ff       	call   80101298 <bfree>
      ip->addrs[i] = 0;
80101671:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
80101677:	83 c7 04             	add    $0x4,%edi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
8010167a:	39 fe                	cmp    %edi,%esi
8010167c:	75 e6                	jne    80101664 <iput+0x63>
8010167e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
80101681:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101687:	85 c0                	test   %eax,%eax
80101689:	74 5a                	je     801016e5 <iput+0xe4>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
8010168b:	83 ec 08             	sub    $0x8,%esp
8010168e:	50                   	push   %eax
8010168f:	ff 33                	pushl  (%ebx)
80101691:	e8 14 ea ff ff       	call   801000aa <bread>
80101696:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101699:	8d 78 5c             	lea    0x5c(%eax),%edi
8010169c:	05 5c 02 00 00       	add    $0x25c,%eax
801016a1:	83 c4 10             	add    $0x10,%esp
801016a4:	89 75 e0             	mov    %esi,-0x20(%ebp)
801016a7:	89 c6                	mov    %eax,%esi
    for(j = 0; j < NINDIRECT; j++){
      if(a[j])
801016a9:	8b 17                	mov    (%edi),%edx
801016ab:	85 d2                	test   %edx,%edx
801016ad:	74 07                	je     801016b6 <iput+0xb5>
        bfree(ip->dev, a[j]);
801016af:	8b 03                	mov    (%ebx),%eax
801016b1:	e8 e2 fb ff ff       	call   80101298 <bfree>
801016b6:	83 c7 04             	add    $0x4,%edi
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
801016b9:	39 fe                	cmp    %edi,%esi
801016bb:	75 ec                	jne    801016a9 <iput+0xa8>
801016bd:	8b 75 e0             	mov    -0x20(%ebp),%esi
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
801016c0:	83 ec 0c             	sub    $0xc,%esp
801016c3:	ff 75 e4             	pushl  -0x1c(%ebp)
801016c6:	e8 f6 ea ff ff       	call   801001c1 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801016cb:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801016d1:	8b 03                	mov    (%ebx),%eax
801016d3:	e8 c0 fb ff ff       	call   80101298 <bfree>
    ip->addrs[NDIRECT] = 0;
801016d8:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
801016df:	00 00 00 
801016e2:	83 c4 10             	add    $0x10,%esp
  }

  ip->size = 0;
801016e5:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
801016ec:	83 ec 0c             	sub    $0xc,%esp
801016ef:	53                   	push   %ebx
801016f0:	e8 5b fd ff ff       	call   80101450 <iupdate>
    int r = ip->ref;
    release(&icache.lock);
    if(r == 1){
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
      ip->type = 0;
801016f5:	66 c7 43 50 00 00    	movw   $0x0,0x50(%ebx)
      iupdate(ip);
801016fb:	89 1c 24             	mov    %ebx,(%esp)
801016fe:	e8 4d fd ff ff       	call   80101450 <iupdate>
      ip->valid = 0;
80101703:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
8010170a:	83 c4 10             	add    $0x10,%esp
    }
  }
  releasesleep(&ip->lock);
8010170d:	83 ec 0c             	sub    $0xc,%esp
80101710:	56                   	push   %esi
80101711:	e8 10 28 00 00       	call   80103f26 <releasesleep>

  acquire(&icache.lock);
80101716:	c7 04 24 00 0b 11 80 	movl   $0x80110b00,(%esp)
8010171d:	e8 4a 29 00 00       	call   8010406c <acquire>
  ip->ref--;
80101722:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101726:	c7 04 24 00 0b 11 80 	movl   $0x80110b00,(%esp)
8010172d:	e8 ff 29 00 00       	call   80104131 <release>
}
80101732:	83 c4 10             	add    $0x10,%esp
80101735:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101738:	5b                   	pop    %ebx
80101739:	5e                   	pop    %esi
8010173a:	5f                   	pop    %edi
8010173b:	5d                   	pop    %ebp
8010173c:	c3                   	ret    

8010173d <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
8010173d:	55                   	push   %ebp
8010173e:	89 e5                	mov    %esp,%ebp
80101740:	53                   	push   %ebx
80101741:	83 ec 10             	sub    $0x10,%esp
80101744:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101747:	53                   	push   %ebx
80101748:	e8 6f fe ff ff       	call   801015bc <iunlock>
  iput(ip);
8010174d:	89 1c 24             	mov    %ebx,(%esp)
80101750:	e8 ac fe ff ff       	call   80101601 <iput>
}
80101755:	83 c4 10             	add    $0x10,%esp
80101758:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010175b:	c9                   	leave  
8010175c:	c3                   	ret    

8010175d <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
8010175d:	55                   	push   %ebp
8010175e:	89 e5                	mov    %esp,%ebp
80101760:	8b 55 08             	mov    0x8(%ebp),%edx
80101763:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101766:	8b 0a                	mov    (%edx),%ecx
80101768:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010176b:	8b 4a 04             	mov    0x4(%edx),%ecx
8010176e:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101771:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101775:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101778:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010177c:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101780:	8b 52 58             	mov    0x58(%edx),%edx
80101783:	89 50 10             	mov    %edx,0x10(%eax)
}
80101786:	5d                   	pop    %ebp
80101787:	c3                   	ret    

80101788 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101788:	55                   	push   %ebp
80101789:	89 e5                	mov    %esp,%ebp
8010178b:	57                   	push   %edi
8010178c:	56                   	push   %esi
8010178d:	53                   	push   %ebx
8010178e:	83 ec 1c             	sub    $0x1c,%esp
80101791:	8b 7d 10             	mov    0x10(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101794:	8b 45 08             	mov    0x8(%ebp),%eax
80101797:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
8010179c:	75 34                	jne    801017d2 <readi+0x4a>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
8010179e:	0f b7 40 52          	movzwl 0x52(%eax),%eax
801017a2:	66 83 f8 09          	cmp    $0x9,%ax
801017a6:	0f 87 bd 00 00 00    	ja     80101869 <readi+0xe1>
801017ac:	98                   	cwtl   
801017ad:	8b 04 c5 80 0a 11 80 	mov    -0x7feef580(,%eax,8),%eax
801017b4:	85 c0                	test   %eax,%eax
801017b6:	0f 84 b4 00 00 00    	je     80101870 <readi+0xe8>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
801017bc:	83 ec 04             	sub    $0x4,%esp
801017bf:	ff 75 14             	pushl  0x14(%ebp)
801017c2:	ff 75 0c             	pushl  0xc(%ebp)
801017c5:	ff 75 08             	pushl  0x8(%ebp)
801017c8:	ff d0                	call   *%eax
801017ca:	83 c4 10             	add    $0x10,%esp
801017cd:	e9 b1 00 00 00       	jmp    80101883 <readi+0xfb>
  }

  if(off > ip->size || off + n < off)
801017d2:	8b 45 08             	mov    0x8(%ebp),%eax
801017d5:	8b 40 58             	mov    0x58(%eax),%eax
801017d8:	39 f8                	cmp    %edi,%eax
801017da:	0f 82 97 00 00 00    	jb     80101877 <readi+0xef>
801017e0:	89 fa                	mov    %edi,%edx
801017e2:	03 55 14             	add    0x14(%ebp),%edx
801017e5:	0f 82 93 00 00 00    	jb     8010187e <readi+0xf6>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801017eb:	89 c1                	mov    %eax,%ecx
801017ed:	29 f9                	sub    %edi,%ecx
801017ef:	39 d0                	cmp    %edx,%eax
801017f1:	0f 43 4d 14          	cmovae 0x14(%ebp),%ecx
801017f5:	89 4d 14             	mov    %ecx,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801017f8:	85 c9                	test   %ecx,%ecx
801017fa:	74 68                	je     80101864 <readi+0xdc>
801017fc:	be 00 00 00 00       	mov    $0x0,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101801:	89 fa                	mov    %edi,%edx
80101803:	c1 ea 09             	shr    $0x9,%edx
80101806:	8b 45 08             	mov    0x8(%ebp),%eax
80101809:	e8 04 f9 ff ff       	call   80101112 <bmap>
8010180e:	83 ec 08             	sub    $0x8,%esp
80101811:	50                   	push   %eax
80101812:	8b 45 08             	mov    0x8(%ebp),%eax
80101815:	ff 30                	pushl  (%eax)
80101817:	e8 8e e8 ff ff       	call   801000aa <bread>
8010181c:	89 c1                	mov    %eax,%ecx
    m = min(n - tot, BSIZE - off%BSIZE);
8010181e:	89 f8                	mov    %edi,%eax
80101820:	25 ff 01 00 00       	and    $0x1ff,%eax
80101825:	bb 00 02 00 00       	mov    $0x200,%ebx
8010182a:	29 c3                	sub    %eax,%ebx
8010182c:	8b 55 14             	mov    0x14(%ebp),%edx
8010182f:	29 f2                	sub    %esi,%edx
80101831:	83 c4 0c             	add    $0xc,%esp
80101834:	39 d3                	cmp    %edx,%ebx
80101836:	0f 47 da             	cmova  %edx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101839:	53                   	push   %ebx
8010183a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010183d:	8d 44 01 5c          	lea    0x5c(%ecx,%eax,1),%eax
80101841:	50                   	push   %eax
80101842:	ff 75 0c             	pushl  0xc(%ebp)
80101845:	e8 c8 29 00 00       	call   80104212 <memmove>
    brelse(bp);
8010184a:	83 c4 04             	add    $0x4,%esp
8010184d:	ff 75 e4             	pushl  -0x1c(%ebp)
80101850:	e8 6c e9 ff ff       	call   801001c1 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101855:	01 de                	add    %ebx,%esi
80101857:	01 df                	add    %ebx,%edi
80101859:	01 5d 0c             	add    %ebx,0xc(%ebp)
8010185c:	83 c4 10             	add    $0x10,%esp
8010185f:	39 75 14             	cmp    %esi,0x14(%ebp)
80101862:	77 9d                	ja     80101801 <readi+0x79>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101864:	8b 45 14             	mov    0x14(%ebp),%eax
80101867:	eb 1a                	jmp    80101883 <readi+0xfb>
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
80101869:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010186e:	eb 13                	jmp    80101883 <readi+0xfb>
80101870:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101875:	eb 0c                	jmp    80101883 <readi+0xfb>
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
    return -1;
80101877:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010187c:	eb 05                	jmp    80101883 <readi+0xfb>
8010187e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
80101883:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101886:	5b                   	pop    %ebx
80101887:	5e                   	pop    %esi
80101888:	5f                   	pop    %edi
80101889:	5d                   	pop    %ebp
8010188a:	c3                   	ret    

8010188b <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
8010188b:	55                   	push   %ebp
8010188c:	89 e5                	mov    %esp,%ebp
8010188e:	57                   	push   %edi
8010188f:	56                   	push   %esi
80101890:	53                   	push   %ebx
80101891:	83 ec 1c             	sub    $0x1c,%esp
80101894:	8b 75 10             	mov    0x10(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101897:	8b 45 08             	mov    0x8(%ebp),%eax
8010189a:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
8010189f:	75 34                	jne    801018d5 <writei+0x4a>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
801018a1:	0f b7 40 52          	movzwl 0x52(%eax),%eax
801018a5:	66 83 f8 09          	cmp    $0x9,%ax
801018a9:	0f 87 dc 00 00 00    	ja     8010198b <writei+0x100>
801018af:	98                   	cwtl   
801018b0:	8b 04 c5 84 0a 11 80 	mov    -0x7feef57c(,%eax,8),%eax
801018b7:	85 c0                	test   %eax,%eax
801018b9:	0f 84 d3 00 00 00    	je     80101992 <writei+0x107>
      return -1;
    return devsw[ip->major].write(ip, src, n);
801018bf:	83 ec 04             	sub    $0x4,%esp
801018c2:	ff 75 14             	pushl  0x14(%ebp)
801018c5:	ff 75 0c             	pushl  0xc(%ebp)
801018c8:	ff 75 08             	pushl  0x8(%ebp)
801018cb:	ff d0                	call   *%eax
801018cd:	83 c4 10             	add    $0x10,%esp
801018d0:	e9 dc 00 00 00       	jmp    801019b1 <writei+0x126>
  }

  if(off > ip->size || off + n < off)
801018d5:	8b 45 08             	mov    0x8(%ebp),%eax
801018d8:	39 70 58             	cmp    %esi,0x58(%eax)
801018db:	0f 82 b8 00 00 00    	jb     80101999 <writei+0x10e>
    return -1;
  if(off + n > MAXFILE*BSIZE)
801018e1:	89 f0                	mov    %esi,%eax
801018e3:	03 45 14             	add    0x14(%ebp),%eax
801018e6:	0f 82 b4 00 00 00    	jb     801019a0 <writei+0x115>
801018ec:	3d 00 18 01 00       	cmp    $0x11800,%eax
801018f1:	0f 87 a9 00 00 00    	ja     801019a0 <writei+0x115>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801018f7:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
801018fb:	0f 84 85 00 00 00    	je     80101986 <writei+0xfb>
80101901:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101908:	89 f2                	mov    %esi,%edx
8010190a:	c1 ea 09             	shr    $0x9,%edx
8010190d:	8b 45 08             	mov    0x8(%ebp),%eax
80101910:	e8 fd f7 ff ff       	call   80101112 <bmap>
80101915:	83 ec 08             	sub    $0x8,%esp
80101918:	50                   	push   %eax
80101919:	8b 45 08             	mov    0x8(%ebp),%eax
8010191c:	ff 30                	pushl  (%eax)
8010191e:	e8 87 e7 ff ff       	call   801000aa <bread>
80101923:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101925:	89 f0                	mov    %esi,%eax
80101927:	25 ff 01 00 00       	and    $0x1ff,%eax
8010192c:	bb 00 02 00 00       	mov    $0x200,%ebx
80101931:	29 c3                	sub    %eax,%ebx
80101933:	8b 55 14             	mov    0x14(%ebp),%edx
80101936:	2b 55 e4             	sub    -0x1c(%ebp),%edx
80101939:	83 c4 0c             	add    $0xc,%esp
8010193c:	39 d3                	cmp    %edx,%ebx
8010193e:	0f 47 da             	cmova  %edx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101941:	53                   	push   %ebx
80101942:	ff 75 0c             	pushl  0xc(%ebp)
80101945:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
80101949:	50                   	push   %eax
8010194a:	e8 c3 28 00 00       	call   80104212 <memmove>
    log_write(bp);
8010194f:	89 3c 24             	mov    %edi,(%esp)
80101952:	e8 1f 10 00 00       	call   80102976 <log_write>
    brelse(bp);
80101957:	89 3c 24             	mov    %edi,(%esp)
8010195a:	e8 62 e8 ff ff       	call   801001c1 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010195f:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101962:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101965:	01 de                	add    %ebx,%esi
80101967:	01 5d 0c             	add    %ebx,0xc(%ebp)
8010196a:	83 c4 10             	add    $0x10,%esp
8010196d:	39 4d 14             	cmp    %ecx,0x14(%ebp)
80101970:	77 96                	ja     80101908 <writei+0x7d>
80101972:	eb 33                	jmp    801019a7 <writei+0x11c>
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101974:	8b 45 08             	mov    0x8(%ebp),%eax
80101977:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
8010197a:	83 ec 0c             	sub    $0xc,%esp
8010197d:	50                   	push   %eax
8010197e:	e8 cd fa ff ff       	call   80101450 <iupdate>
80101983:	83 c4 10             	add    $0x10,%esp
  }
  return n;
80101986:	8b 45 14             	mov    0x14(%ebp),%eax
80101989:	eb 26                	jmp    801019b1 <writei+0x126>
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
8010198b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101990:	eb 1f                	jmp    801019b1 <writei+0x126>
80101992:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101997:	eb 18                	jmp    801019b1 <writei+0x126>
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
    return -1;
80101999:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010199e:	eb 11                	jmp    801019b1 <writei+0x126>
  if(off + n > MAXFILE*BSIZE)
    return -1;
801019a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801019a5:	eb 0a                	jmp    801019b1 <writei+0x126>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
801019a7:	8b 45 08             	mov    0x8(%ebp),%eax
801019aa:	3b 70 58             	cmp    0x58(%eax),%esi
801019ad:	76 d7                	jbe    80101986 <writei+0xfb>
801019af:	eb c3                	jmp    80101974 <writei+0xe9>
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
801019b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801019b4:	5b                   	pop    %ebx
801019b5:	5e                   	pop    %esi
801019b6:	5f                   	pop    %edi
801019b7:	5d                   	pop    %ebp
801019b8:	c3                   	ret    

801019b9 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
801019b9:	55                   	push   %ebp
801019ba:	89 e5                	mov    %esp,%ebp
801019bc:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
801019bf:	6a 0e                	push   $0xe
801019c1:	ff 75 0c             	pushl  0xc(%ebp)
801019c4:	ff 75 08             	pushl  0x8(%ebp)
801019c7:	e8 ab 28 00 00       	call   80104277 <strncmp>
}
801019cc:	c9                   	leave  
801019cd:	c3                   	ret    

801019ce <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
801019ce:	55                   	push   %ebp
801019cf:	89 e5                	mov    %esp,%ebp
801019d1:	57                   	push   %edi
801019d2:	56                   	push   %esi
801019d3:	53                   	push   %ebx
801019d4:	83 ec 1c             	sub    $0x1c,%esp
801019d7:	8b 75 08             	mov    0x8(%ebp),%esi
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
801019da:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801019df:	75 15                	jne    801019f6 <dirlookup+0x28>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
801019e1:	bb 00 00 00 00       	mov    $0x0,%ebx
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801019e6:	8d 7d d8             	lea    -0x28(%ebp),%edi
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
801019e9:	b8 00 00 00 00       	mov    $0x0,%eax
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
801019ee:	83 7e 58 00          	cmpl   $0x0,0x58(%esi)
801019f2:	74 70                	je     80101a64 <dirlookup+0x96>
801019f4:	eb 0d                	jmp    80101a03 <dirlookup+0x35>
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
801019f6:	83 ec 0c             	sub    $0xc,%esp
801019f9:	68 27 6e 10 80       	push   $0x80106e27
801019fe:	e8 4a e9 ff ff       	call   8010034d <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101a03:	6a 10                	push   $0x10
80101a05:	53                   	push   %ebx
80101a06:	57                   	push   %edi
80101a07:	56                   	push   %esi
80101a08:	e8 7b fd ff ff       	call   80101788 <readi>
80101a0d:	83 c4 10             	add    $0x10,%esp
80101a10:	83 f8 10             	cmp    $0x10,%eax
80101a13:	74 0d                	je     80101a22 <dirlookup+0x54>
      panic("dirlookup read");
80101a15:	83 ec 0c             	sub    $0xc,%esp
80101a18:	68 39 6e 10 80       	push   $0x80106e39
80101a1d:	e8 2b e9 ff ff       	call   8010034d <panic>
    if(de.inum == 0)
80101a22:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101a27:	74 2e                	je     80101a57 <dirlookup+0x89>
      continue;
    if(namecmp(name, de.name) == 0){
80101a29:	83 ec 08             	sub    $0x8,%esp
80101a2c:	8d 45 da             	lea    -0x26(%ebp),%eax
80101a2f:	50                   	push   %eax
80101a30:	ff 75 0c             	pushl  0xc(%ebp)
80101a33:	e8 81 ff ff ff       	call   801019b9 <namecmp>
80101a38:	83 c4 10             	add    $0x10,%esp
80101a3b:	85 c0                	test   %eax,%eax
80101a3d:	75 18                	jne    80101a57 <dirlookup+0x89>
      // entry matches path element
      if(poff)
80101a3f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80101a43:	74 05                	je     80101a4a <dirlookup+0x7c>
        *poff = off;
80101a45:	8b 45 10             	mov    0x10(%ebp),%eax
80101a48:	89 18                	mov    %ebx,(%eax)
      inum = de.inum;
      return iget(dp->dev, inum);
80101a4a:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
80101a4e:	8b 06                	mov    (%esi),%eax
80101a50:	e8 60 f7 ff ff       	call   801011b5 <iget>
80101a55:	eb 0d                	jmp    80101a64 <dirlookup+0x96>
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101a57:	83 c3 10             	add    $0x10,%ebx
80101a5a:	39 5e 58             	cmp    %ebx,0x58(%esi)
80101a5d:	77 a4                	ja     80101a03 <dirlookup+0x35>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80101a5f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101a64:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a67:	5b                   	pop    %ebx
80101a68:	5e                   	pop    %esi
80101a69:	5f                   	pop    %edi
80101a6a:	5d                   	pop    %ebp
80101a6b:	c3                   	ret    

80101a6c <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101a6c:	55                   	push   %ebp
80101a6d:	89 e5                	mov    %esp,%ebp
80101a6f:	57                   	push   %edi
80101a70:	56                   	push   %esi
80101a71:	53                   	push   %ebx
80101a72:	83 ec 1c             	sub    $0x1c,%esp
80101a75:	89 c6                	mov    %eax,%esi
80101a77:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101a7a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101a7d:	80 38 2f             	cmpb   $0x2f,(%eax)
80101a80:	75 16                	jne    80101a98 <namex+0x2c>
    ip = iget(ROOTDEV, ROOTINO);
80101a82:	ba 01 00 00 00       	mov    $0x1,%edx
80101a87:	b8 01 00 00 00       	mov    $0x1,%eax
80101a8c:	e8 24 f7 ff ff       	call   801011b5 <iget>
80101a91:	89 c7                	mov    %eax,%edi
80101a93:	e9 9e 00 00 00       	jmp    80101b36 <namex+0xca>
  else
    ip = idup(myproc()->cwd);
80101a98:	e8 fd 18 00 00       	call   8010339a <myproc>
80101a9d:	83 ec 0c             	sub    $0xc,%esp
80101aa0:	ff 70 68             	pushl  0x68(%eax)
80101aa3:	e8 27 fa ff ff       	call   801014cf <idup>
80101aa8:	89 c7                	mov    %eax,%edi
80101aaa:	83 c4 10             	add    $0x10,%esp
80101aad:	e9 84 00 00 00       	jmp    80101b36 <namex+0xca>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101ab2:	83 ec 0c             	sub    $0xc,%esp
80101ab5:	57                   	push   %edi
80101ab6:	e8 3f fa ff ff       	call   801014fa <ilock>
    if(ip->type != T_DIR){
80101abb:	83 c4 10             	add    $0x10,%esp
80101abe:	66 83 7f 50 01       	cmpw   $0x1,0x50(%edi)
80101ac3:	74 16                	je     80101adb <namex+0x6f>
      iunlockput(ip);
80101ac5:	83 ec 0c             	sub    $0xc,%esp
80101ac8:	57                   	push   %edi
80101ac9:	e8 6f fc ff ff       	call   8010173d <iunlockput>
      return 0;
80101ace:	83 c4 10             	add    $0x10,%esp
80101ad1:	b8 00 00 00 00       	mov    $0x0,%eax
80101ad6:	e9 f8 00 00 00       	jmp    80101bd3 <namex+0x167>
    }
    if(nameiparent && *path == '\0'){
80101adb:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
80101adf:	74 18                	je     80101af9 <namex+0x8d>
80101ae1:	80 3b 00             	cmpb   $0x0,(%ebx)
80101ae4:	75 13                	jne    80101af9 <namex+0x8d>
      // Stop one level early.
      iunlock(ip);
80101ae6:	83 ec 0c             	sub    $0xc,%esp
80101ae9:	57                   	push   %edi
80101aea:	e8 cd fa ff ff       	call   801015bc <iunlock>
      return ip;
80101aef:	83 c4 10             	add    $0x10,%esp
80101af2:	89 f8                	mov    %edi,%eax
80101af4:	e9 da 00 00 00       	jmp    80101bd3 <namex+0x167>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101af9:	83 ec 04             	sub    $0x4,%esp
80101afc:	6a 00                	push   $0x0
80101afe:	ff 75 e4             	pushl  -0x1c(%ebp)
80101b01:	57                   	push   %edi
80101b02:	e8 c7 fe ff ff       	call   801019ce <dirlookup>
80101b07:	89 c6                	mov    %eax,%esi
80101b09:	83 c4 10             	add    $0x10,%esp
80101b0c:	85 c0                	test   %eax,%eax
80101b0e:	75 16                	jne    80101b26 <namex+0xba>
      iunlockput(ip);
80101b10:	83 ec 0c             	sub    $0xc,%esp
80101b13:	57                   	push   %edi
80101b14:	e8 24 fc ff ff       	call   8010173d <iunlockput>
      return 0;
80101b19:	83 c4 10             	add    $0x10,%esp
80101b1c:	b8 00 00 00 00       	mov    $0x0,%eax
80101b21:	e9 ad 00 00 00       	jmp    80101bd3 <namex+0x167>
    }
    iunlockput(ip);
80101b26:	83 ec 0c             	sub    $0xc,%esp
80101b29:	57                   	push   %edi
80101b2a:	e8 0e fc ff ff       	call   8010173d <iunlockput>
80101b2f:	83 c4 10             	add    $0x10,%esp
    ip = next;
80101b32:	89 f7                	mov    %esi,%edi
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
80101b34:	89 de                	mov    %ebx,%esi
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80101b36:	0f b6 06             	movzbl (%esi),%eax
80101b39:	3c 2f                	cmp    $0x2f,%al
80101b3b:	75 0a                	jne    80101b47 <namex+0xdb>
    path++;
80101b3d:	83 c6 01             	add    $0x1,%esi
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80101b40:	0f b6 06             	movzbl (%esi),%eax
80101b43:	3c 2f                	cmp    $0x2f,%al
80101b45:	74 f6                	je     80101b3d <namex+0xd1>
    path++;
  if(*path == 0)
80101b47:	84 c0                	test   %al,%al
80101b49:	74 6f                	je     80101bba <namex+0x14e>
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101b4b:	0f b6 06             	movzbl (%esi),%eax
80101b4e:	3c 2f                	cmp    $0x2f,%al
80101b50:	74 16                	je     80101b68 <namex+0xfc>
80101b52:	84 c0                	test   %al,%al
80101b54:	74 12                	je     80101b68 <namex+0xfc>
80101b56:	89 f3                	mov    %esi,%ebx
    path++;
80101b58:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101b5b:	0f b6 03             	movzbl (%ebx),%eax
80101b5e:	3c 2f                	cmp    $0x2f,%al
80101b60:	74 08                	je     80101b6a <namex+0xfe>
80101b62:	84 c0                	test   %al,%al
80101b64:	75 f2                	jne    80101b58 <namex+0xec>
80101b66:	eb 02                	jmp    80101b6a <namex+0xfe>
80101b68:	89 f3                	mov    %esi,%ebx
    path++;
  len = path - s;
80101b6a:	89 d8                	mov    %ebx,%eax
80101b6c:	29 f0                	sub    %esi,%eax
80101b6e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(len >= DIRSIZ)
80101b71:	83 f8 0d             	cmp    $0xd,%eax
80101b74:	7e 18                	jle    80101b8e <namex+0x122>
    memmove(name, s, DIRSIZ);
80101b76:	83 ec 04             	sub    $0x4,%esp
80101b79:	6a 0e                	push   $0xe
80101b7b:	56                   	push   %esi
80101b7c:	ff 75 e4             	pushl  -0x1c(%ebp)
80101b7f:	e8 8e 26 00 00       	call   80104212 <memmove>
80101b84:	83 c4 10             	add    $0x10,%esp
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101b87:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101b8a:	74 1e                	je     80101baa <namex+0x13e>
80101b8c:	eb 24                	jmp    80101bb2 <namex+0x146>
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
80101b8e:	83 ec 04             	sub    $0x4,%esp
80101b91:	ff 75 e0             	pushl  -0x20(%ebp)
80101b94:	56                   	push   %esi
80101b95:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101b98:	56                   	push   %esi
80101b99:	e8 74 26 00 00       	call   80104212 <memmove>
    name[len] = 0;
80101b9e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101ba1:	c6 04 0e 00          	movb   $0x0,(%esi,%ecx,1)
80101ba5:	83 c4 10             	add    $0x10,%esp
80101ba8:	eb dd                	jmp    80101b87 <namex+0x11b>
  }
  while(*path == '/')
    path++;
80101baa:	83 c3 01             	add    $0x1,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101bad:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101bb0:	74 f8                	je     80101baa <namex+0x13e>
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);

  while((path = skipelem(path, name)) != 0){
80101bb2:	85 db                	test   %ebx,%ebx
80101bb4:	0f 85 f8 fe ff ff    	jne    80101ab2 <namex+0x46>
80101bba:	89 f8                	mov    %edi,%eax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101bbc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
80101bc0:	74 11                	je     80101bd3 <namex+0x167>
    iput(ip);
80101bc2:	83 ec 0c             	sub    $0xc,%esp
80101bc5:	57                   	push   %edi
80101bc6:	e8 36 fa ff ff       	call   80101601 <iput>
    return 0;
80101bcb:	83 c4 10             	add    $0x10,%esp
80101bce:	b8 00 00 00 00       	mov    $0x0,%eax
  }
  return ip;
}
80101bd3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bd6:	5b                   	pop    %ebx
80101bd7:	5e                   	pop    %esi
80101bd8:	5f                   	pop    %edi
80101bd9:	5d                   	pop    %ebp
80101bda:	c3                   	ret    

80101bdb <dirlink>:
}

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80101bdb:	55                   	push   %ebp
80101bdc:	89 e5                	mov    %esp,%ebp
80101bde:	57                   	push   %edi
80101bdf:	56                   	push   %esi
80101be0:	53                   	push   %ebx
80101be1:	83 ec 20             	sub    $0x20,%esp
80101be4:	8b 75 08             	mov    0x8(%ebp),%esi
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80101be7:	6a 00                	push   $0x0
80101be9:	ff 75 0c             	pushl  0xc(%ebp)
80101bec:	56                   	push   %esi
80101bed:	e8 dc fd ff ff       	call   801019ce <dirlookup>
80101bf2:	83 c4 10             	add    $0x10,%esp
80101bf5:	85 c0                	test   %eax,%eax
80101bf7:	75 09                	jne    80101c02 <dirlink+0x27>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80101bf9:	8b 5e 58             	mov    0x58(%esi),%ebx
80101bfc:	85 db                	test   %ebx,%ebx
80101bfe:	75 15                	jne    80101c15 <dirlink+0x3a>
80101c00:	eb 49                	jmp    80101c4b <dirlink+0x70>
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
80101c02:	83 ec 0c             	sub    $0xc,%esp
80101c05:	50                   	push   %eax
80101c06:	e8 f6 f9 ff ff       	call   80101601 <iput>
    return -1;
80101c0b:	83 c4 10             	add    $0x10,%esp
80101c0e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c13:	eb 75                	jmp    80101c8a <dirlink+0xaf>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80101c15:	bb 00 00 00 00       	mov    $0x0,%ebx
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101c1a:	8d 7d d8             	lea    -0x28(%ebp),%edi
80101c1d:	6a 10                	push   $0x10
80101c1f:	53                   	push   %ebx
80101c20:	57                   	push   %edi
80101c21:	56                   	push   %esi
80101c22:	e8 61 fb ff ff       	call   80101788 <readi>
80101c27:	83 c4 10             	add    $0x10,%esp
80101c2a:	83 f8 10             	cmp    $0x10,%eax
80101c2d:	74 0d                	je     80101c3c <dirlink+0x61>
      panic("dirlink read");
80101c2f:	83 ec 0c             	sub    $0xc,%esp
80101c32:	68 48 6e 10 80       	push   $0x80106e48
80101c37:	e8 11 e7 ff ff       	call   8010034d <panic>
    if(de.inum == 0)
80101c3c:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c41:	74 08                	je     80101c4b <dirlink+0x70>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80101c43:	83 c3 10             	add    $0x10,%ebx
80101c46:	39 5e 58             	cmp    %ebx,0x58(%esi)
80101c49:	77 d2                	ja     80101c1d <dirlink+0x42>
      panic("dirlink read");
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
80101c4b:	83 ec 04             	sub    $0x4,%esp
80101c4e:	6a 0e                	push   $0xe
80101c50:	ff 75 0c             	pushl  0xc(%ebp)
80101c53:	8d 7d d8             	lea    -0x28(%ebp),%edi
80101c56:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c59:	50                   	push   %eax
80101c5a:	e8 6d 26 00 00       	call   801042cc <strncpy>
  de.inum = inum;
80101c5f:	8b 45 10             	mov    0x10(%ebp),%eax
80101c62:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101c66:	6a 10                	push   $0x10
80101c68:	53                   	push   %ebx
80101c69:	57                   	push   %edi
80101c6a:	56                   	push   %esi
80101c6b:	e8 1b fc ff ff       	call   8010188b <writei>
80101c70:	83 c4 20             	add    $0x20,%esp
80101c73:	83 f8 10             	cmp    $0x10,%eax
80101c76:	74 0d                	je     80101c85 <dirlink+0xaa>
    panic("dirlink");
80101c78:	83 ec 0c             	sub    $0xc,%esp
80101c7b:	68 56 74 10 80       	push   $0x80107456
80101c80:	e8 c8 e6 ff ff       	call   8010034d <panic>

  return 0;
80101c85:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101c8a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c8d:	5b                   	pop    %ebx
80101c8e:	5e                   	pop    %esi
80101c8f:	5f                   	pop    %edi
80101c90:	5d                   	pop    %ebp
80101c91:	c3                   	ret    

80101c92 <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
80101c92:	55                   	push   %ebp
80101c93:	89 e5                	mov    %esp,%ebp
80101c95:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101c98:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101c9b:	ba 00 00 00 00       	mov    $0x0,%edx
80101ca0:	8b 45 08             	mov    0x8(%ebp),%eax
80101ca3:	e8 c4 fd ff ff       	call   80101a6c <namex>
}
80101ca8:	c9                   	leave  
80101ca9:	c3                   	ret    

80101caa <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101caa:	55                   	push   %ebp
80101cab:	89 e5                	mov    %esp,%ebp
80101cad:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
80101cb0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101cb3:	ba 01 00 00 00       	mov    $0x1,%edx
80101cb8:	8b 45 08             	mov    0x8(%ebp),%eax
80101cbb:	e8 ac fd ff ff       	call   80101a6c <namex>
}
80101cc0:	c9                   	leave  
80101cc1:	c3                   	ret    

80101cc2 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101cc2:	55                   	push   %ebp
80101cc3:	89 e5                	mov    %esp,%ebp
80101cc5:	56                   	push   %esi
80101cc6:	53                   	push   %ebx
  if(b == 0)
80101cc7:	85 c0                	test   %eax,%eax
80101cc9:	75 0d                	jne    80101cd8 <idestart+0x16>
    panic("idestart");
80101ccb:	83 ec 0c             	sub    $0xc,%esp
80101cce:	68 ab 6e 10 80       	push   $0x80106eab
80101cd3:	e8 75 e6 ff ff       	call   8010034d <panic>
80101cd8:	89 c3                	mov    %eax,%ebx
  if(b->blockno >= FSSIZE)
80101cda:	8b 48 08             	mov    0x8(%eax),%ecx
80101cdd:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
80101ce3:	76 0d                	jbe    80101cf2 <idestart+0x30>
    panic("incorrect blockno");
80101ce5:	83 ec 0c             	sub    $0xc,%esp
80101ce8:	68 b4 6e 10 80       	push   $0x80106eb4
80101ced:	e8 5b e6 ff ff       	call   8010034d <panic>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101cf2:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101cf7:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101cf8:	83 e0 c0             	and    $0xffffffc0,%eax
80101cfb:	3c 40                	cmp    $0x40,%al
80101cfd:	75 f8                	jne    80101cf7 <idestart+0x35>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101cff:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101d04:	b8 00 00 00 00       	mov    $0x0,%eax
80101d09:	ee                   	out    %al,(%dx)
80101d0a:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101d0f:	b8 01 00 00 00       	mov    $0x1,%eax
80101d14:	ee                   	out    %al,(%dx)
80101d15:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101d1a:	89 c8                	mov    %ecx,%eax
80101d1c:	ee                   	out    %al,(%dx)
80101d1d:	89 c8                	mov    %ecx,%eax
80101d1f:	c1 f8 08             	sar    $0x8,%eax
80101d22:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101d27:	ee                   	out    %al,(%dx)
80101d28:	89 c8                	mov    %ecx,%eax
80101d2a:	c1 f8 10             	sar    $0x10,%eax
80101d2d:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101d32:	ee                   	out    %al,(%dx)
80101d33:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
80101d37:	83 e0 01             	and    $0x1,%eax
80101d3a:	c1 e0 04             	shl    $0x4,%eax
80101d3d:	83 c8 e0             	or     $0xffffffe0,%eax
80101d40:	c1 f9 18             	sar    $0x18,%ecx
80101d43:	83 e1 0f             	and    $0xf,%ecx
80101d46:	09 c8                	or     %ecx,%eax
80101d48:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101d4d:	ee                   	out    %al,(%dx)
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
80101d4e:	f6 03 04             	testb  $0x4,(%ebx)
80101d51:	74 1d                	je     80101d70 <idestart+0xae>
80101d53:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101d58:	b8 30 00 00 00       	mov    $0x30,%eax
80101d5d:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
80101d5e:	8d 73 5c             	lea    0x5c(%ebx),%esi
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld; rep outsl" :
80101d61:	b9 80 00 00 00       	mov    $0x80,%ecx
80101d66:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101d6b:	fc                   	cld    
80101d6c:	f3 6f                	rep outsl %ds:(%esi),(%dx)
80101d6e:	eb 0b                	jmp    80101d7b <idestart+0xb9>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101d70:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101d75:	b8 20 00 00 00       	mov    $0x20,%eax
80101d7a:	ee                   	out    %al,(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101d7b:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101d7e:	5b                   	pop    %ebx
80101d7f:	5e                   	pop    %esi
80101d80:	5d                   	pop    %ebp
80101d81:	c3                   	ret    

80101d82 <ideinit>:
  return 0;
}

void
ideinit(void)
{
80101d82:	55                   	push   %ebp
80101d83:	89 e5                	mov    %esp,%ebp
80101d85:	83 ec 10             	sub    $0x10,%esp
  int i;

  initlock(&idelock, "ide");
80101d88:	68 c6 6e 10 80       	push   $0x80106ec6
80101d8d:	68 80 a5 10 80       	push   $0x8010a580
80101d92:	e8 f1 21 00 00       	call   80103f88 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80101d97:	83 c4 08             	add    $0x8,%esp
80101d9a:	a1 20 2e 11 80       	mov    0x80112e20,%eax
80101d9f:	83 e8 01             	sub    $0x1,%eax
80101da2:	50                   	push   %eax
80101da3:	6a 0e                	push   $0xe
80101da5:	e8 5f 02 00 00       	call   80102009 <ioapicenable>
80101daa:	83 c4 10             	add    $0x10,%esp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101dad:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101db2:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101db3:	83 e0 c0             	and    $0xffffffc0,%eax
80101db6:	3c 40                	cmp    $0x40,%al
80101db8:	75 f8                	jne    80101db2 <ideinit+0x30>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101dba:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101dbf:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80101dc4:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101dc5:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101dca:	ec                   	in     (%dx),%al
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
    if(inb(0x1f7) != 0){
80101dcb:	84 c0                	test   %al,%al
80101dcd:	75 0a                	jne    80101dd9 <ideinit+0x57>
80101dcf:	b9 e7 03 00 00       	mov    $0x3e7,%ecx
80101dd4:	ec                   	in     (%dx),%al
80101dd5:	84 c0                	test   %al,%al
80101dd7:	74 0c                	je     80101de5 <ideinit+0x63>
      havedisk1 = 1;
80101dd9:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80101de0:	00 00 00 
      break;
80101de3:	eb 05                	jmp    80101dea <ideinit+0x68>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80101de5:	83 e9 01             	sub    $0x1,%ecx
80101de8:	75 ea                	jne    80101dd4 <ideinit+0x52>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101dea:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101def:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80101df4:	ee                   	out    %al,(%dx)
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
80101df5:	c9                   	leave  
80101df6:	c3                   	ret    

80101df7 <ideintr>:
}

// Interrupt handler.
void
ideintr(void)
{
80101df7:	55                   	push   %ebp
80101df8:	89 e5                	mov    %esp,%ebp
80101dfa:	57                   	push   %edi
80101dfb:	53                   	push   %ebx
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80101dfc:	83 ec 0c             	sub    $0xc,%esp
80101dff:	68 80 a5 10 80       	push   $0x8010a580
80101e04:	e8 63 22 00 00       	call   8010406c <acquire>

  if((b = idequeue) == 0){
80101e09:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
80101e0f:	83 c4 10             	add    $0x10,%esp
80101e12:	85 db                	test   %ebx,%ebx
80101e14:	75 12                	jne    80101e28 <ideintr+0x31>
    release(&idelock);
80101e16:	83 ec 0c             	sub    $0xc,%esp
80101e19:	68 80 a5 10 80       	push   $0x8010a580
80101e1e:	e8 0e 23 00 00       	call   80104131 <release>
    return;
80101e23:	83 c4 10             	add    $0x10,%esp
80101e26:	eb 65                	jmp    80101e8d <ideintr+0x96>
  }
  idequeue = b->qnext;
80101e28:	8b 43 58             	mov    0x58(%ebx),%eax
80101e2b:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80101e30:	f6 03 04             	testb  $0x4,(%ebx)
80101e33:	75 24                	jne    80101e59 <ideintr+0x62>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101e35:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101e3a:	ec                   	in     (%dx),%al
80101e3b:	89 c1                	mov    %eax,%ecx
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101e3d:	83 e0 c0             	and    $0xffffffc0,%eax
80101e40:	3c 40                	cmp    $0x40,%al
80101e42:	75 f6                	jne    80101e3a <ideintr+0x43>
    return;
  }
  idequeue = b->qnext;

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80101e44:	f6 c1 21             	test   $0x21,%cl
80101e47:	75 10                	jne    80101e59 <ideintr+0x62>
    insl(0x1f0, b->data, BSIZE/4);
80101e49:	8d 7b 5c             	lea    0x5c(%ebx),%edi
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld; rep insl" :
80101e4c:	b9 80 00 00 00       	mov    $0x80,%ecx
80101e51:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101e56:	fc                   	cld    
80101e57:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80101e59:	8b 03                	mov    (%ebx),%eax
80101e5b:	83 e0 fb             	and    $0xfffffffb,%eax
80101e5e:	83 c8 02             	or     $0x2,%eax
80101e61:	89 03                	mov    %eax,(%ebx)
  wakeup(b);
80101e63:	83 ec 0c             	sub    $0xc,%esp
80101e66:	53                   	push   %ebx
80101e67:	e8 54 1e 00 00       	call   80103cc0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80101e6c:	a1 64 a5 10 80       	mov    0x8010a564,%eax
80101e71:	83 c4 10             	add    $0x10,%esp
80101e74:	85 c0                	test   %eax,%eax
80101e76:	74 05                	je     80101e7d <ideintr+0x86>
    idestart(idequeue);
80101e78:	e8 45 fe ff ff       	call   80101cc2 <idestart>

  release(&idelock);
80101e7d:	83 ec 0c             	sub    $0xc,%esp
80101e80:	68 80 a5 10 80       	push   $0x8010a580
80101e85:	e8 a7 22 00 00       	call   80104131 <release>
80101e8a:	83 c4 10             	add    $0x10,%esp
}
80101e8d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101e90:	5b                   	pop    %ebx
80101e91:	5f                   	pop    %edi
80101e92:	5d                   	pop    %ebp
80101e93:	c3                   	ret    

80101e94 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80101e94:	55                   	push   %ebp
80101e95:	89 e5                	mov    %esp,%ebp
80101e97:	53                   	push   %ebx
80101e98:	83 ec 10             	sub    $0x10,%esp
80101e9b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
80101e9e:	8d 43 0c             	lea    0xc(%ebx),%eax
80101ea1:	50                   	push   %eax
80101ea2:	e8 ba 20 00 00       	call   80103f61 <holdingsleep>
80101ea7:	83 c4 10             	add    $0x10,%esp
80101eaa:	85 c0                	test   %eax,%eax
80101eac:	75 0d                	jne    80101ebb <iderw+0x27>
    panic("iderw: buf not locked");
80101eae:	83 ec 0c             	sub    $0xc,%esp
80101eb1:	68 ca 6e 10 80       	push   $0x80106eca
80101eb6:	e8 92 e4 ff ff       	call   8010034d <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80101ebb:	8b 03                	mov    (%ebx),%eax
80101ebd:	83 e0 06             	and    $0x6,%eax
80101ec0:	83 f8 02             	cmp    $0x2,%eax
80101ec3:	75 0d                	jne    80101ed2 <iderw+0x3e>
    panic("iderw: nothing to do");
80101ec5:	83 ec 0c             	sub    $0xc,%esp
80101ec8:	68 e0 6e 10 80       	push   $0x80106ee0
80101ecd:	e8 7b e4 ff ff       	call   8010034d <panic>
  if(b->dev != 0 && !havedisk1)
80101ed2:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
80101ed6:	74 16                	je     80101eee <iderw+0x5a>
80101ed8:	83 3d 60 a5 10 80 00 	cmpl   $0x0,0x8010a560
80101edf:	75 0d                	jne    80101eee <iderw+0x5a>
    panic("iderw: ide disk 1 not present");
80101ee1:	83 ec 0c             	sub    $0xc,%esp
80101ee4:	68 f5 6e 10 80       	push   $0x80106ef5
80101ee9:	e8 5f e4 ff ff       	call   8010034d <panic>

  acquire(&idelock);  //DOC:acquire-lock
80101eee:	83 ec 0c             	sub    $0xc,%esp
80101ef1:	68 80 a5 10 80       	push   $0x8010a580
80101ef6:	e8 71 21 00 00       	call   8010406c <acquire>

  // Append b to idequeue.
  b->qnext = 0;
80101efb:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80101f02:	8b 15 64 a5 10 80    	mov    0x8010a564,%edx
80101f08:	83 c4 10             	add    $0x10,%esp
80101f0b:	85 d2                	test   %edx,%edx
80101f0d:	75 04                	jne    80101f13 <iderw+0x7f>
80101f0f:	eb 0e                	jmp    80101f1f <iderw+0x8b>
80101f11:	89 c2                	mov    %eax,%edx
80101f13:	8b 42 58             	mov    0x58(%edx),%eax
80101f16:	85 c0                	test   %eax,%eax
80101f18:	75 f7                	jne    80101f11 <iderw+0x7d>
80101f1a:	83 c2 58             	add    $0x58,%edx
80101f1d:	eb 05                	jmp    80101f24 <iderw+0x90>
80101f1f:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
    ;
  *pp = b;
80101f24:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80101f26:	3b 1d 64 a5 10 80    	cmp    0x8010a564,%ebx
80101f2c:	75 07                	jne    80101f35 <iderw+0xa1>
    idestart(b);
80101f2e:	89 d8                	mov    %ebx,%eax
80101f30:	e8 8d fd ff ff       	call   80101cc2 <idestart>

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80101f35:	8b 03                	mov    (%ebx),%eax
80101f37:	83 e0 06             	and    $0x6,%eax
80101f3a:	83 f8 02             	cmp    $0x2,%eax
80101f3d:	74 1b                	je     80101f5a <iderw+0xc6>
    sleep(b, &idelock);
80101f3f:	83 ec 08             	sub    $0x8,%esp
80101f42:	68 80 a5 10 80       	push   $0x8010a580
80101f47:	53                   	push   %ebx
80101f48:	e8 1b 1a 00 00       	call   80103968 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80101f4d:	8b 03                	mov    (%ebx),%eax
80101f4f:	83 e0 06             	and    $0x6,%eax
80101f52:	83 c4 10             	add    $0x10,%esp
80101f55:	83 f8 02             	cmp    $0x2,%eax
80101f58:	75 e5                	jne    80101f3f <iderw+0xab>
    sleep(b, &idelock);
  }


  release(&idelock);
80101f5a:	83 ec 0c             	sub    $0xc,%esp
80101f5d:	68 80 a5 10 80       	push   $0x8010a580
80101f62:	e8 ca 21 00 00       	call   80104131 <release>
}
80101f67:	83 c4 10             	add    $0x10,%esp
80101f6a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101f6d:	c9                   	leave  
80101f6e:	c3                   	ret    

80101f6f <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80101f6f:	55                   	push   %ebp
80101f70:	89 e5                	mov    %esp,%ebp
80101f72:	56                   	push   %esi
80101f73:	53                   	push   %ebx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80101f74:	c7 05 54 27 11 80 00 	movl   $0xfec00000,0x80112754
80101f7b:	00 c0 fe 
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
80101f7e:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80101f85:	00 00 00 
  return ioapic->data;
80101f88:	a1 54 27 11 80       	mov    0x80112754,%eax
80101f8d:	8b 58 10             	mov    0x10(%eax),%ebx
ioapicinit(void)
{
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80101f90:	c1 eb 10             	shr    $0x10,%ebx
80101f93:	0f b6 db             	movzbl %bl,%ebx
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
80101f96:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80101f9c:	a1 54 27 11 80       	mov    0x80112754,%eax
80101fa1:	8b 40 10             	mov    0x10(%eax),%eax
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80101fa4:	c1 e8 18             	shr    $0x18,%eax
80101fa7:	0f b6 15 80 28 11 80 	movzbl 0x80112880,%edx
80101fae:	39 d0                	cmp    %edx,%eax
80101fb0:	74 10                	je     80101fc2 <ioapicinit+0x53>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80101fb2:	83 ec 0c             	sub    $0xc,%esp
80101fb5:	68 14 6f 10 80       	push   $0x80106f14
80101fba:	e8 2a e6 ff ff       	call   801005e9 <cprintf>
80101fbf:	83 c4 10             	add    $0x10,%esp
  ioapic->data = data;
}

void
ioapicinit(void)
{
80101fc2:	ba 10 00 00 00       	mov    $0x10,%edx
80101fc7:	b8 00 00 00 00       	mov    $0x0,%eax
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80101fcc:	8d 48 20             	lea    0x20(%eax),%ecx
80101fcf:	81 c9 00 00 01 00    	or     $0x10000,%ecx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80101fd5:	8b 35 54 27 11 80    	mov    0x80112754,%esi
80101fdb:	89 16                	mov    %edx,(%esi)
  ioapic->data = data;
80101fdd:	8b 35 54 27 11 80    	mov    0x80112754,%esi
80101fe3:	89 4e 10             	mov    %ecx,0x10(%esi)
80101fe6:	8d 4a 01             	lea    0x1(%edx),%ecx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80101fe9:	89 0e                	mov    %ecx,(%esi)
  ioapic->data = data;
80101feb:	8b 0d 54 27 11 80    	mov    0x80112754,%ecx
80101ff1:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80101ff8:	83 c0 01             	add    $0x1,%eax
80101ffb:	83 c2 02             	add    $0x2,%edx
80101ffe:	39 c3                	cmp    %eax,%ebx
80102000:	7d ca                	jge    80101fcc <ioapicinit+0x5d>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102002:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102005:	5b                   	pop    %ebx
80102006:	5e                   	pop    %esi
80102007:	5d                   	pop    %ebp
80102008:	c3                   	ret    

80102009 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102009:	55                   	push   %ebp
8010200a:	89 e5                	mov    %esp,%ebp
8010200c:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010200f:	8d 50 20             	lea    0x20(%eax),%edx
80102012:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102016:	8b 0d 54 27 11 80    	mov    0x80112754,%ecx
8010201c:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
8010201e:	8b 0d 54 27 11 80    	mov    0x80112754,%ecx
80102024:	89 51 10             	mov    %edx,0x10(%ecx)
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102027:	8b 55 0c             	mov    0xc(%ebp),%edx
8010202a:	c1 e2 18             	shl    $0x18,%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010202d:	83 c0 01             	add    $0x1,%eax
80102030:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102032:	a1 54 27 11 80       	mov    0x80112754,%eax
80102037:	89 50 10             	mov    %edx,0x10(%eax)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
8010203a:	5d                   	pop    %ebp
8010203b:	c3                   	ret    

8010203c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
8010203c:	55                   	push   %ebp
8010203d:	89 e5                	mov    %esp,%ebp
8010203f:	53                   	push   %ebx
80102040:	83 ec 04             	sub    $0x4,%esp
80102043:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102046:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
8010204c:	75 15                	jne    80102063 <kfree+0x27>
8010204e:	81 fb c8 5d 11 80    	cmp    $0x80115dc8,%ebx
80102054:	72 0d                	jb     80102063 <kfree+0x27>
80102056:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010205c:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102061:	76 0d                	jbe    80102070 <kfree+0x34>
    panic("kfree");
80102063:	83 ec 0c             	sub    $0xc,%esp
80102066:	68 46 6f 10 80       	push   $0x80106f46
8010206b:	e8 dd e2 ff ff       	call   8010034d <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102070:	83 ec 04             	sub    $0x4,%esp
80102073:	68 00 10 00 00       	push   $0x1000
80102078:	6a 01                	push   $0x1
8010207a:	53                   	push   %ebx
8010207b:	e8 f8 20 00 00       	call   80104178 <memset>

  if(kmem.use_lock)
80102080:	83 c4 10             	add    $0x10,%esp
80102083:	83 3d 94 27 11 80 00 	cmpl   $0x0,0x80112794
8010208a:	74 10                	je     8010209c <kfree+0x60>
    acquire(&kmem.lock);
8010208c:	83 ec 0c             	sub    $0xc,%esp
8010208f:	68 60 27 11 80       	push   $0x80112760
80102094:	e8 d3 1f 00 00       	call   8010406c <acquire>
80102099:	83 c4 10             	add    $0x10,%esp
  r = (struct run*)v;
  r->next = kmem.freelist;
8010209c:	a1 98 27 11 80       	mov    0x80112798,%eax
801020a1:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
801020a3:	89 1d 98 27 11 80    	mov    %ebx,0x80112798
  if(kmem.use_lock)
801020a9:	83 3d 94 27 11 80 00 	cmpl   $0x0,0x80112794
801020b0:	74 10                	je     801020c2 <kfree+0x86>
    release(&kmem.lock);
801020b2:	83 ec 0c             	sub    $0xc,%esp
801020b5:	68 60 27 11 80       	push   $0x80112760
801020ba:	e8 72 20 00 00       	call   80104131 <release>
801020bf:	83 c4 10             	add    $0x10,%esp
}
801020c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801020c5:	c9                   	leave  
801020c6:	c3                   	ret    

801020c7 <freerange>:
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
801020c7:	55                   	push   %ebp
801020c8:	89 e5                	mov    %esp,%ebp
801020ca:	56                   	push   %esi
801020cb:	53                   	push   %ebx
801020cc:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801020cf:	8b 45 08             	mov    0x8(%ebp),%eax
801020d2:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801020d8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801020de:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801020e4:	39 de                	cmp    %ebx,%esi
801020e6:	72 1c                	jb     80102104 <freerange+0x3d>
    kfree(p);
801020e8:	83 ec 0c             	sub    $0xc,%esp
801020eb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801020f1:	50                   	push   %eax
801020f2:	e8 45 ff ff ff       	call   8010203c <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801020f7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801020fd:	83 c4 10             	add    $0x10,%esp
80102100:	39 f3                	cmp    %esi,%ebx
80102102:	76 e4                	jbe    801020e8 <freerange+0x21>
    kfree(p);
}
80102104:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102107:	5b                   	pop    %ebx
80102108:	5e                   	pop    %esi
80102109:	5d                   	pop    %ebp
8010210a:	c3                   	ret    

8010210b <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
8010210b:	55                   	push   %ebp
8010210c:	89 e5                	mov    %esp,%ebp
8010210e:	83 ec 10             	sub    $0x10,%esp
  initlock(&kmem.lock, "kmem");
80102111:	68 4c 6f 10 80       	push   $0x80106f4c
80102116:	68 60 27 11 80       	push   $0x80112760
8010211b:	e8 68 1e 00 00       	call   80103f88 <initlock>
  kmem.use_lock = 0;
80102120:	c7 05 94 27 11 80 00 	movl   $0x0,0x80112794
80102127:	00 00 00 
  freerange(vstart, vend);
8010212a:	83 c4 08             	add    $0x8,%esp
8010212d:	ff 75 0c             	pushl  0xc(%ebp)
80102130:	ff 75 08             	pushl  0x8(%ebp)
80102133:	e8 8f ff ff ff       	call   801020c7 <freerange>
}
80102138:	83 c4 10             	add    $0x10,%esp
8010213b:	c9                   	leave  
8010213c:	c3                   	ret    

8010213d <kinit2>:

void
kinit2(void *vstart, void *vend)
{
8010213d:	55                   	push   %ebp
8010213e:	89 e5                	mov    %esp,%ebp
80102140:	83 ec 10             	sub    $0x10,%esp
  freerange(vstart, vend);
80102143:	ff 75 0c             	pushl  0xc(%ebp)
80102146:	ff 75 08             	pushl  0x8(%ebp)
80102149:	e8 79 ff ff ff       	call   801020c7 <freerange>
  kmem.use_lock = 1;
8010214e:	c7 05 94 27 11 80 01 	movl   $0x1,0x80112794
80102155:	00 00 00 
}
80102158:	83 c4 10             	add    $0x10,%esp
8010215b:	c9                   	leave  
8010215c:	c3                   	ret    

8010215d <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
8010215d:	55                   	push   %ebp
8010215e:	89 e5                	mov    %esp,%ebp
80102160:	53                   	push   %ebx
80102161:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102164:	83 3d 94 27 11 80 00 	cmpl   $0x0,0x80112794
8010216b:	74 3c                	je     801021a9 <kalloc+0x4c>
    acquire(&kmem.lock);
8010216d:	83 ec 0c             	sub    $0xc,%esp
80102170:	68 60 27 11 80       	push   $0x80112760
80102175:	e8 f2 1e 00 00       	call   8010406c <acquire>
  r = kmem.freelist;
8010217a:	8b 1d 98 27 11 80    	mov    0x80112798,%ebx
  if(r)
80102180:	83 c4 10             	add    $0x10,%esp
80102183:	85 db                	test   %ebx,%ebx
80102185:	74 07                	je     8010218e <kalloc+0x31>
    kmem.freelist = r->next;
80102187:	8b 03                	mov    (%ebx),%eax
80102189:	a3 98 27 11 80       	mov    %eax,0x80112798
  if(kmem.use_lock)
8010218e:	83 3d 94 27 11 80 00 	cmpl   $0x0,0x80112794
80102195:	74 1c                	je     801021b3 <kalloc+0x56>
    release(&kmem.lock);
80102197:	83 ec 0c             	sub    $0xc,%esp
8010219a:	68 60 27 11 80       	push   $0x80112760
8010219f:	e8 8d 1f 00 00       	call   80104131 <release>
801021a4:	83 c4 10             	add    $0x10,%esp
801021a7:	eb 0a                	jmp    801021b3 <kalloc+0x56>
{
  struct run *r;

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = kmem.freelist;
801021a9:	8b 1d 98 27 11 80    	mov    0x80112798,%ebx
  if(r)
801021af:	85 db                	test   %ebx,%ebx
801021b1:	75 d4                	jne    80102187 <kalloc+0x2a>
    kmem.freelist = r->next;
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
801021b3:	89 d8                	mov    %ebx,%eax
801021b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801021b8:	c9                   	leave  
801021b9:	c3                   	ret    

801021ba <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
801021ba:	55                   	push   %ebp
801021bb:	89 e5                	mov    %esp,%ebp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021bd:	ba 64 00 00 00       	mov    $0x64,%edx
801021c2:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801021c3:	a8 01                	test   $0x1,%al
801021c5:	0f 84 b9 00 00 00    	je     80102284 <kbdgetc+0xca>
801021cb:	ba 60 00 00 00       	mov    $0x60,%edx
801021d0:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
801021d1:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
801021d4:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
801021da:	75 11                	jne    801021ed <kbdgetc+0x33>
    shift |= E0ESC;
801021dc:	83 0d b4 a5 10 80 40 	orl    $0x40,0x8010a5b4
    return 0;
801021e3:	b8 00 00 00 00       	mov    $0x0,%eax
801021e8:	e9 9c 00 00 00       	jmp    80102289 <kbdgetc+0xcf>
  } else if(data & 0x80){
801021ed:	84 c0                	test   %al,%al
801021ef:	79 2d                	jns    8010221e <kbdgetc+0x64>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
801021f1:	8b 0d b4 a5 10 80    	mov    0x8010a5b4,%ecx
801021f7:	f6 c1 40             	test   $0x40,%cl
801021fa:	75 05                	jne    80102201 <kbdgetc+0x47>
801021fc:	89 c2                	mov    %eax,%edx
801021fe:	83 e2 7f             	and    $0x7f,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102201:	0f b6 82 80 70 10 80 	movzbl -0x7fef8f80(%edx),%eax
80102208:	83 c8 40             	or     $0x40,%eax
8010220b:	0f b6 c0             	movzbl %al,%eax
8010220e:	f7 d0                	not    %eax
80102210:	21 c8                	and    %ecx,%eax
80102212:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4
    return 0;
80102217:	b8 00 00 00 00       	mov    $0x0,%eax
8010221c:	eb 6b                	jmp    80102289 <kbdgetc+0xcf>
  } else if(shift & E0ESC){
8010221e:	8b 0d b4 a5 10 80    	mov    0x8010a5b4,%ecx
80102224:	f6 c1 40             	test   $0x40,%cl
80102227:	74 0f                	je     80102238 <kbdgetc+0x7e>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102229:	83 c8 80             	or     $0xffffff80,%eax
8010222c:	0f b6 d0             	movzbl %al,%edx
    shift &= ~E0ESC;
8010222f:	83 e1 bf             	and    $0xffffffbf,%ecx
80102232:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
80102238:	0f b6 8a 80 70 10 80 	movzbl -0x7fef8f80(%edx),%ecx
8010223f:	0b 0d b4 a5 10 80    	or     0x8010a5b4,%ecx
80102245:	0f b6 82 80 6f 10 80 	movzbl -0x7fef9080(%edx),%eax
8010224c:	31 c1                	xor    %eax,%ecx
8010224e:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102254:	89 c8                	mov    %ecx,%eax
80102256:	83 e0 03             	and    $0x3,%eax
80102259:	8b 04 85 60 6f 10 80 	mov    -0x7fef90a0(,%eax,4),%eax
80102260:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102264:	f6 c1 08             	test   $0x8,%cl
80102267:	74 20                	je     80102289 <kbdgetc+0xcf>
    if('a' <= c && c <= 'z')
80102269:	8d 50 9f             	lea    -0x61(%eax),%edx
8010226c:	83 fa 19             	cmp    $0x19,%edx
8010226f:	77 05                	ja     80102276 <kbdgetc+0xbc>
      c += 'A' - 'a';
80102271:	83 e8 20             	sub    $0x20,%eax
80102274:	eb 13                	jmp    80102289 <kbdgetc+0xcf>
    else if('A' <= c && c <= 'Z')
80102276:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102279:	8d 50 20             	lea    0x20(%eax),%edx
8010227c:	83 f9 19             	cmp    $0x19,%ecx
8010227f:	0f 46 c2             	cmovbe %edx,%eax
  }
  return c;
80102282:	eb 05                	jmp    80102289 <kbdgetc+0xcf>
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
    return -1;
80102284:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102289:	5d                   	pop    %ebp
8010228a:	c3                   	ret    

8010228b <kbdintr>:

void
kbdintr(void)
{
8010228b:	55                   	push   %ebp
8010228c:	89 e5                	mov    %esp,%ebp
8010228e:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102291:	68 ba 21 10 80       	push   $0x801021ba
80102296:	e8 8e e4 ff ff       	call   80100729 <consoleintr>
}
8010229b:	83 c4 10             	add    $0x10,%esp
8010229e:	c9                   	leave  
8010229f:	c3                   	ret    

801022a0 <lapicw>:
volatile uint *lapic;  // Initialized in mp.c

//PAGEBREAK!
static void
lapicw(int index, int value)
{
801022a0:	55                   	push   %ebp
801022a1:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
801022a3:	8b 0d 9c 27 11 80    	mov    0x8011279c,%ecx
801022a9:	8d 04 81             	lea    (%ecx,%eax,4),%eax
801022ac:	89 10                	mov    %edx,(%eax)
  lapic[ID];  // wait for write to finish, by reading
801022ae:	a1 9c 27 11 80       	mov    0x8011279c,%eax
801022b3:	8b 40 20             	mov    0x20(%eax),%eax
}
801022b6:	5d                   	pop    %ebp
801022b7:	c3                   	ret    

801022b8 <fill_rtcdate>:

  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
801022b8:	55                   	push   %ebp
801022b9:	89 e5                	mov    %esp,%ebp
801022bb:	53                   	push   %ebx
801022bc:	89 c3                	mov    %eax,%ebx
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801022be:	ba 70 00 00 00       	mov    $0x70,%edx
801022c3:	b8 00 00 00 00       	mov    $0x0,%eax
801022c8:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022c9:	b9 71 00 00 00       	mov    $0x71,%ecx
801022ce:	89 ca                	mov    %ecx,%edx
801022d0:	ec                   	in     (%dx),%al
  r->second = cmos_read(SECS);
801022d1:	0f b6 c0             	movzbl %al,%eax
801022d4:	89 03                	mov    %eax,(%ebx)
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801022d6:	ba 70 00 00 00       	mov    $0x70,%edx
801022db:	b8 02 00 00 00       	mov    $0x2,%eax
801022e0:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022e1:	89 ca                	mov    %ecx,%edx
801022e3:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
801022e4:	0f b6 c0             	movzbl %al,%eax
801022e7:	89 43 04             	mov    %eax,0x4(%ebx)
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801022ea:	ba 70 00 00 00       	mov    $0x70,%edx
801022ef:	b8 04 00 00 00       	mov    $0x4,%eax
801022f4:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022f5:	89 ca                	mov    %ecx,%edx
801022f7:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
801022f8:	0f b6 c0             	movzbl %al,%eax
801022fb:	89 43 08             	mov    %eax,0x8(%ebx)
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801022fe:	ba 70 00 00 00       	mov    $0x70,%edx
80102303:	b8 07 00 00 00       	mov    $0x7,%eax
80102308:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102309:	89 ca                	mov    %ecx,%edx
8010230b:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
8010230c:	0f b6 c0             	movzbl %al,%eax
8010230f:	89 43 0c             	mov    %eax,0xc(%ebx)
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102312:	ba 70 00 00 00       	mov    $0x70,%edx
80102317:	b8 08 00 00 00       	mov    $0x8,%eax
8010231c:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010231d:	89 ca                	mov    %ecx,%edx
8010231f:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
80102320:	0f b6 c0             	movzbl %al,%eax
80102323:	89 43 10             	mov    %eax,0x10(%ebx)
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102326:	ba 70 00 00 00       	mov    $0x70,%edx
8010232b:	b8 09 00 00 00       	mov    $0x9,%eax
80102330:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102331:	89 ca                	mov    %ecx,%edx
80102333:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
80102334:	0f b6 c0             	movzbl %al,%eax
80102337:	89 43 14             	mov    %eax,0x14(%ebx)
}
8010233a:	5b                   	pop    %ebx
8010233b:	5d                   	pop    %ebp
8010233c:	c3                   	ret    

8010233d <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
8010233d:	83 3d 9c 27 11 80 00 	cmpl   $0x0,0x8011279c
80102344:	0f 84 f6 00 00 00    	je     80102440 <lapicinit+0x103>
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
8010234a:	55                   	push   %ebp
8010234b:	89 e5                	mov    %esp,%ebp
  if(!lapic)
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
8010234d:	ba 3f 01 00 00       	mov    $0x13f,%edx
80102352:	b8 3c 00 00 00       	mov    $0x3c,%eax
80102357:	e8 44 ff ff ff       	call   801022a0 <lapicw>

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
8010235c:	ba 0b 00 00 00       	mov    $0xb,%edx
80102361:	b8 f8 00 00 00       	mov    $0xf8,%eax
80102366:	e8 35 ff ff ff       	call   801022a0 <lapicw>
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
8010236b:	ba 20 00 02 00       	mov    $0x20020,%edx
80102370:	b8 c8 00 00 00       	mov    $0xc8,%eax
80102375:	e8 26 ff ff ff       	call   801022a0 <lapicw>
  lapicw(TICR, 10000000);
8010237a:	ba 80 96 98 00       	mov    $0x989680,%edx
8010237f:	b8 e0 00 00 00       	mov    $0xe0,%eax
80102384:	e8 17 ff ff ff       	call   801022a0 <lapicw>

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102389:	ba 00 00 01 00       	mov    $0x10000,%edx
8010238e:	b8 d4 00 00 00       	mov    $0xd4,%eax
80102393:	e8 08 ff ff ff       	call   801022a0 <lapicw>
  lapicw(LINT1, MASKED);
80102398:	ba 00 00 01 00       	mov    $0x10000,%edx
8010239d:	b8 d8 00 00 00       	mov    $0xd8,%eax
801023a2:	e8 f9 fe ff ff       	call   801022a0 <lapicw>

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801023a7:	a1 9c 27 11 80       	mov    0x8011279c,%eax
801023ac:	8b 40 30             	mov    0x30(%eax),%eax
801023af:	c1 e8 10             	shr    $0x10,%eax
801023b2:	3c 03                	cmp    $0x3,%al
801023b4:	76 0f                	jbe    801023c5 <lapicinit+0x88>
    lapicw(PCINT, MASKED);
801023b6:	ba 00 00 01 00       	mov    $0x10000,%edx
801023bb:	b8 d0 00 00 00       	mov    $0xd0,%eax
801023c0:	e8 db fe ff ff       	call   801022a0 <lapicw>

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
801023c5:	ba 33 00 00 00       	mov    $0x33,%edx
801023ca:	b8 dc 00 00 00       	mov    $0xdc,%eax
801023cf:	e8 cc fe ff ff       	call   801022a0 <lapicw>

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
801023d4:	ba 00 00 00 00       	mov    $0x0,%edx
801023d9:	b8 a0 00 00 00       	mov    $0xa0,%eax
801023de:	e8 bd fe ff ff       	call   801022a0 <lapicw>
  lapicw(ESR, 0);
801023e3:	ba 00 00 00 00       	mov    $0x0,%edx
801023e8:	b8 a0 00 00 00       	mov    $0xa0,%eax
801023ed:	e8 ae fe ff ff       	call   801022a0 <lapicw>

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
801023f2:	ba 00 00 00 00       	mov    $0x0,%edx
801023f7:	b8 2c 00 00 00       	mov    $0x2c,%eax
801023fc:	e8 9f fe ff ff       	call   801022a0 <lapicw>

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80102401:	ba 00 00 00 00       	mov    $0x0,%edx
80102406:	b8 c4 00 00 00       	mov    $0xc4,%eax
8010240b:	e8 90 fe ff ff       	call   801022a0 <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102410:	ba 00 85 08 00       	mov    $0x88500,%edx
80102415:	b8 c0 00 00 00       	mov    $0xc0,%eax
8010241a:	e8 81 fe ff ff       	call   801022a0 <lapicw>
  while(lapic[ICRLO] & DELIVS)
8010241f:	8b 15 9c 27 11 80    	mov    0x8011279c,%edx
80102425:	8b 82 00 03 00 00    	mov    0x300(%edx),%eax
8010242b:	f6 c4 10             	test   $0x10,%ah
8010242e:	75 f5                	jne    80102425 <lapicinit+0xe8>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80102430:	ba 00 00 00 00       	mov    $0x0,%edx
80102435:	b8 20 00 00 00       	mov    $0x20,%eax
8010243a:	e8 61 fe ff ff       	call   801022a0 <lapicw>
}
8010243f:	5d                   	pop    %ebp
80102440:	f3 c3                	repz ret 

80102442 <lapicid>:

int
lapicid(void)
{
80102442:	55                   	push   %ebp
80102443:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102445:	a1 9c 27 11 80       	mov    0x8011279c,%eax
8010244a:	85 c0                	test   %eax,%eax
8010244c:	74 08                	je     80102456 <lapicid+0x14>
    return 0;
  return lapic[ID] >> 24;
8010244e:	8b 40 20             	mov    0x20(%eax),%eax
80102451:	c1 e8 18             	shr    $0x18,%eax
80102454:	eb 05                	jmp    8010245b <lapicid+0x19>

int
lapicid(void)
{
  if (!lapic)
    return 0;
80102456:	b8 00 00 00 00       	mov    $0x0,%eax
  return lapic[ID] >> 24;
}
8010245b:	5d                   	pop    %ebp
8010245c:	c3                   	ret    

8010245d <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
8010245d:	83 3d 9c 27 11 80 00 	cmpl   $0x0,0x8011279c
80102464:	74 13                	je     80102479 <lapiceoi+0x1c>
}

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102466:	55                   	push   %ebp
80102467:	89 e5                	mov    %esp,%ebp
  if(lapic)
    lapicw(EOI, 0);
80102469:	ba 00 00 00 00       	mov    $0x0,%edx
8010246e:	b8 2c 00 00 00       	mov    $0x2c,%eax
80102473:	e8 28 fe ff ff       	call   801022a0 <lapicw>
}
80102478:	5d                   	pop    %ebp
80102479:	f3 c3                	repz ret 

8010247b <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
8010247b:	55                   	push   %ebp
8010247c:	89 e5                	mov    %esp,%ebp
}
8010247e:	5d                   	pop    %ebp
8010247f:	c3                   	ret    

80102480 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102480:	55                   	push   %ebp
80102481:	89 e5                	mov    %esp,%ebp
80102483:	56                   	push   %esi
80102484:	53                   	push   %ebx
80102485:	8b 75 08             	mov    0x8(%ebp),%esi
80102488:	8b 5d 0c             	mov    0xc(%ebp),%ebx
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010248b:	ba 70 00 00 00       	mov    $0x70,%edx
80102490:	b8 0f 00 00 00       	mov    $0xf,%eax
80102495:	ee                   	out    %al,(%dx)
80102496:	ba 71 00 00 00       	mov    $0x71,%edx
8010249b:	b8 0a 00 00 00       	mov    $0xa,%eax
801024a0:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801024a1:	66 c7 05 67 04 00 80 	movw   $0x0,0x80000467
801024a8:	00 00 
  wrv[1] = addr >> 4;
801024aa:	89 d8                	mov    %ebx,%eax
801024ac:	c1 e8 04             	shr    $0x4,%eax
801024af:	66 a3 69 04 00 80    	mov    %ax,0x80000469

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801024b5:	c1 e6 18             	shl    $0x18,%esi
801024b8:	89 f2                	mov    %esi,%edx
801024ba:	b8 c4 00 00 00       	mov    $0xc4,%eax
801024bf:	e8 dc fd ff ff       	call   801022a0 <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
801024c4:	ba 00 c5 00 00       	mov    $0xc500,%edx
801024c9:	b8 c0 00 00 00       	mov    $0xc0,%eax
801024ce:	e8 cd fd ff ff       	call   801022a0 <lapicw>
  microdelay(200);
  lapicw(ICRLO, INIT | LEVEL);
801024d3:	ba 00 85 00 00       	mov    $0x8500,%edx
801024d8:	b8 c0 00 00 00       	mov    $0xc0,%eax
801024dd:	e8 be fd ff ff       	call   801022a0 <lapicw>
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801024e2:	c1 eb 0c             	shr    $0xc,%ebx
801024e5:	80 cf 06             	or     $0x6,%bh
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
801024e8:	89 f2                	mov    %esi,%edx
801024ea:	b8 c4 00 00 00       	mov    $0xc4,%eax
801024ef:	e8 ac fd ff ff       	call   801022a0 <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
801024f4:	89 da                	mov    %ebx,%edx
801024f6:	b8 c0 00 00 00       	mov    $0xc0,%eax
801024fb:	e8 a0 fd ff ff       	call   801022a0 <lapicw>
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
80102500:	89 f2                	mov    %esi,%edx
80102502:	b8 c4 00 00 00       	mov    $0xc4,%eax
80102507:	e8 94 fd ff ff       	call   801022a0 <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
8010250c:	89 da                	mov    %ebx,%edx
8010250e:	b8 c0 00 00 00       	mov    $0xc0,%eax
80102513:	e8 88 fd ff ff       	call   801022a0 <lapicw>
    microdelay(200);
  }
}
80102518:	5b                   	pop    %ebx
80102519:	5e                   	pop    %esi
8010251a:	5d                   	pop    %ebp
8010251b:	c3                   	ret    

8010251c <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
8010251c:	55                   	push   %ebp
8010251d:	89 e5                	mov    %esp,%ebp
8010251f:	57                   	push   %edi
80102520:	56                   	push   %esi
80102521:	53                   	push   %ebx
80102522:	83 ec 4c             	sub    $0x4c,%esp
80102525:	ba 70 00 00 00       	mov    $0x70,%edx
8010252a:	b8 0b 00 00 00       	mov    $0xb,%eax
8010252f:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102530:	ba 71 00 00 00       	mov    $0x71,%edx
80102535:	ec                   	in     (%dx),%al
80102536:	83 e0 04             	and    $0x4,%eax
80102539:	88 45 b7             	mov    %al,-0x49(%ebp)

  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
8010253c:	8d 5d d0             	lea    -0x30(%ebp),%ebx
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
8010253f:	8d 7d b8             	lea    -0x48(%ebp),%edi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102542:	be 0a 00 00 00       	mov    $0xa,%esi

  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
80102547:	89 d8                	mov    %ebx,%eax
80102549:	e8 6a fd ff ff       	call   801022b8 <fill_rtcdate>
8010254e:	ba 70 00 00 00       	mov    $0x70,%edx
80102553:	89 f0                	mov    %esi,%eax
80102555:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102556:	ba 71 00 00 00       	mov    $0x71,%edx
8010255b:	ec                   	in     (%dx),%al
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
8010255c:	84 c0                	test   %al,%al
8010255e:	78 e7                	js     80102547 <cmostime+0x2b>
        continue;
    fill_rtcdate(&t2);
80102560:	89 f8                	mov    %edi,%eax
80102562:	e8 51 fd ff ff       	call   801022b8 <fill_rtcdate>
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102567:	83 ec 04             	sub    $0x4,%esp
8010256a:	6a 18                	push   $0x18
8010256c:	57                   	push   %edi
8010256d:	53                   	push   %ebx
8010256e:	e8 49 1c 00 00       	call   801041bc <memcmp>
80102573:	83 c4 10             	add    $0x10,%esp
80102576:	85 c0                	test   %eax,%eax
80102578:	75 c8                	jne    80102542 <cmostime+0x26>
      break;
  }

  // convert
  if(bcd) {
8010257a:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
8010257e:	75 78                	jne    801025f8 <cmostime+0xdc>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102580:	8b 45 d0             	mov    -0x30(%ebp),%eax
80102583:	89 c2                	mov    %eax,%edx
80102585:	c1 ea 04             	shr    $0x4,%edx
80102588:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010258b:	83 e0 0f             	and    $0xf,%eax
8010258e:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102591:	89 45 d0             	mov    %eax,-0x30(%ebp)
    CONV(minute);
80102594:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80102597:	89 c2                	mov    %eax,%edx
80102599:	c1 ea 04             	shr    $0x4,%edx
8010259c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010259f:	83 e0 0f             	and    $0xf,%eax
801025a2:	8d 04 50             	lea    (%eax,%edx,2),%eax
801025a5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    CONV(hour  );
801025a8:	8b 45 d8             	mov    -0x28(%ebp),%eax
801025ab:	89 c2                	mov    %eax,%edx
801025ad:	c1 ea 04             	shr    $0x4,%edx
801025b0:	8d 14 92             	lea    (%edx,%edx,4),%edx
801025b3:	83 e0 0f             	and    $0xf,%eax
801025b6:	8d 04 50             	lea    (%eax,%edx,2),%eax
801025b9:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(day   );
801025bc:	8b 45 dc             	mov    -0x24(%ebp),%eax
801025bf:	89 c2                	mov    %eax,%edx
801025c1:	c1 ea 04             	shr    $0x4,%edx
801025c4:	8d 14 92             	lea    (%edx,%edx,4),%edx
801025c7:	83 e0 0f             	and    $0xf,%eax
801025ca:	8d 04 50             	lea    (%eax,%edx,2),%eax
801025cd:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(month );
801025d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801025d3:	89 c2                	mov    %eax,%edx
801025d5:	c1 ea 04             	shr    $0x4,%edx
801025d8:	8d 14 92             	lea    (%edx,%edx,4),%edx
801025db:	83 e0 0f             	and    $0xf,%eax
801025de:	8d 04 50             	lea    (%eax,%edx,2),%eax
801025e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(year  );
801025e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801025e7:	89 c2                	mov    %eax,%edx
801025e9:	c1 ea 04             	shr    $0x4,%edx
801025ec:	8d 14 92             	lea    (%edx,%edx,4),%edx
801025ef:	83 e0 0f             	and    $0xf,%eax
801025f2:	8d 04 50             	lea    (%eax,%edx,2),%eax
801025f5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
#undef     CONV
  }

  *r = t1;
801025f8:	8b 45 d0             	mov    -0x30(%ebp),%eax
801025fb:	8b 4d 08             	mov    0x8(%ebp),%ecx
801025fe:	89 01                	mov    %eax,(%ecx)
80102600:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80102603:	89 41 04             	mov    %eax,0x4(%ecx)
80102606:	8b 45 d8             	mov    -0x28(%ebp),%eax
80102609:	89 41 08             	mov    %eax,0x8(%ecx)
8010260c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010260f:	89 41 0c             	mov    %eax,0xc(%ecx)
80102612:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102615:	89 41 10             	mov    %eax,0x10(%ecx)
80102618:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010261b:	89 41 14             	mov    %eax,0x14(%ecx)
  r->year += 2000;
8010261e:	81 41 14 d0 07 00 00 	addl   $0x7d0,0x14(%ecx)
}
80102625:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102628:	5b                   	pop    %ebx
80102629:	5e                   	pop    %esi
8010262a:	5f                   	pop    %edi
8010262b:	5d                   	pop    %ebp
8010262c:	c3                   	ret    

8010262d <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
8010262d:	83 3d e8 27 11 80 00 	cmpl   $0x0,0x801127e8
80102634:	0f 8e 83 00 00 00    	jle    801026bd <install_trans+0x90>
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
8010263a:	55                   	push   %ebp
8010263b:	89 e5                	mov    %esp,%ebp
8010263d:	57                   	push   %edi
8010263e:	56                   	push   %esi
8010263f:	53                   	push   %ebx
80102640:	83 ec 0c             	sub    $0xc,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102643:	bb 00 00 00 00       	mov    $0x0,%ebx
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102648:	83 ec 08             	sub    $0x8,%esp
8010264b:	89 d8                	mov    %ebx,%eax
8010264d:	03 05 d4 27 11 80    	add    0x801127d4,%eax
80102653:	83 c0 01             	add    $0x1,%eax
80102656:	50                   	push   %eax
80102657:	ff 35 e4 27 11 80    	pushl  0x801127e4
8010265d:	e8 48 da ff ff       	call   801000aa <bread>
80102662:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102664:	83 c4 08             	add    $0x8,%esp
80102667:	ff 34 9d ec 27 11 80 	pushl  -0x7feed814(,%ebx,4)
8010266e:	ff 35 e4 27 11 80    	pushl  0x801127e4
80102674:	e8 31 da ff ff       	call   801000aa <bread>
80102679:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
8010267b:	83 c4 0c             	add    $0xc,%esp
8010267e:	68 00 02 00 00       	push   $0x200
80102683:	8d 47 5c             	lea    0x5c(%edi),%eax
80102686:	50                   	push   %eax
80102687:	8d 46 5c             	lea    0x5c(%esi),%eax
8010268a:	50                   	push   %eax
8010268b:	e8 82 1b 00 00       	call   80104212 <memmove>
    bwrite(dbuf);  // write dst to disk
80102690:	89 34 24             	mov    %esi,(%esp)
80102693:	e8 ee da ff ff       	call   80100186 <bwrite>
    brelse(lbuf);
80102698:	89 3c 24             	mov    %edi,(%esp)
8010269b:	e8 21 db ff ff       	call   801001c1 <brelse>
    brelse(dbuf);
801026a0:	89 34 24             	mov    %esi,(%esp)
801026a3:	e8 19 db ff ff       	call   801001c1 <brelse>
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801026a8:	83 c3 01             	add    $0x1,%ebx
801026ab:	83 c4 10             	add    $0x10,%esp
801026ae:	39 1d e8 27 11 80    	cmp    %ebx,0x801127e8
801026b4:	7f 92                	jg     80102648 <install_trans+0x1b>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}
801026b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801026b9:	5b                   	pop    %ebx
801026ba:	5e                   	pop    %esi
801026bb:	5f                   	pop    %edi
801026bc:	5d                   	pop    %ebp
801026bd:	f3 c3                	repz ret 

801026bf <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
801026bf:	55                   	push   %ebp
801026c0:	89 e5                	mov    %esp,%ebp
801026c2:	53                   	push   %ebx
801026c3:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
801026c6:	ff 35 d4 27 11 80    	pushl  0x801127d4
801026cc:	ff 35 e4 27 11 80    	pushl  0x801127e4
801026d2:	e8 d3 d9 ff ff       	call   801000aa <bread>
801026d7:	89 c3                	mov    %eax,%ebx
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
801026d9:	8b 0d e8 27 11 80    	mov    0x801127e8,%ecx
801026df:	89 48 5c             	mov    %ecx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
801026e2:	83 c4 10             	add    $0x10,%esp
801026e5:	85 c9                	test   %ecx,%ecx
801026e7:	7e 19                	jle    80102702 <write_head+0x43>
801026e9:	c1 e1 02             	shl    $0x2,%ecx
801026ec:	b8 00 00 00 00       	mov    $0x0,%eax
    hb->block[i] = log.lh.block[i];
801026f1:	8b 90 ec 27 11 80    	mov    -0x7feed814(%eax),%edx
801026f7:	89 54 03 60          	mov    %edx,0x60(%ebx,%eax,1)
801026fb:	83 c0 04             	add    $0x4,%eax
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
801026fe:	39 c8                	cmp    %ecx,%eax
80102700:	75 ef                	jne    801026f1 <write_head+0x32>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80102702:	83 ec 0c             	sub    $0xc,%esp
80102705:	53                   	push   %ebx
80102706:	e8 7b da ff ff       	call   80100186 <bwrite>
  brelse(buf);
8010270b:	89 1c 24             	mov    %ebx,(%esp)
8010270e:	e8 ae da ff ff       	call   801001c1 <brelse>
}
80102713:	83 c4 10             	add    $0x10,%esp
80102716:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102719:	c9                   	leave  
8010271a:	c3                   	ret    

8010271b <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
8010271b:	55                   	push   %ebp
8010271c:	89 e5                	mov    %esp,%ebp
8010271e:	53                   	push   %ebx
8010271f:	83 ec 2c             	sub    $0x2c,%esp
80102722:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102725:	68 80 71 10 80       	push   $0x80107180
8010272a:	68 a0 27 11 80       	push   $0x801127a0
8010272f:	e8 54 18 00 00       	call   80103f88 <initlock>
  readsb(dev, &sb);
80102734:	83 c4 08             	add    $0x8,%esp
80102737:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010273a:	50                   	push   %eax
8010273b:	53                   	push   %ebx
8010273c:	e8 23 eb ff ff       	call   80101264 <readsb>
  log.start = sb.logstart;
80102741:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102744:	a3 d4 27 11 80       	mov    %eax,0x801127d4
  log.size = sb.nlog;
80102749:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010274c:	89 15 d8 27 11 80    	mov    %edx,0x801127d8
  log.dev = dev;
80102752:	89 1d e4 27 11 80    	mov    %ebx,0x801127e4

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102758:	83 c4 08             	add    $0x8,%esp
8010275b:	50                   	push   %eax
8010275c:	53                   	push   %ebx
8010275d:	e8 48 d9 ff ff       	call   801000aa <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102762:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102765:	89 1d e8 27 11 80    	mov    %ebx,0x801127e8
  for (i = 0; i < log.lh.n; i++) {
8010276b:	83 c4 10             	add    $0x10,%esp
8010276e:	85 db                	test   %ebx,%ebx
80102770:	7e 19                	jle    8010278b <initlog+0x70>
80102772:	c1 e3 02             	shl    $0x2,%ebx
80102775:	ba 00 00 00 00       	mov    $0x0,%edx
    log.lh.block[i] = lh->block[i];
8010277a:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
8010277e:	89 8a ec 27 11 80    	mov    %ecx,-0x7feed814(%edx)
80102784:	83 c2 04             	add    $0x4,%edx
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102787:	39 d3                	cmp    %edx,%ebx
80102789:	75 ef                	jne    8010277a <initlog+0x5f>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
8010278b:	83 ec 0c             	sub    $0xc,%esp
8010278e:	50                   	push   %eax
8010278f:	e8 2d da ff ff       	call   801001c1 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102794:	e8 94 fe ff ff       	call   8010262d <install_trans>
  log.lh.n = 0;
80102799:	c7 05 e8 27 11 80 00 	movl   $0x0,0x801127e8
801027a0:	00 00 00 
  write_head(); // clear the log
801027a3:	e8 17 ff ff ff       	call   801026bf <write_head>
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
  recover_from_log();
}
801027a8:	83 c4 10             	add    $0x10,%esp
801027ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027ae:	c9                   	leave  
801027af:	c3                   	ret    

801027b0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
801027b0:	55                   	push   %ebp
801027b1:	89 e5                	mov    %esp,%ebp
801027b3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
801027b6:	68 a0 27 11 80       	push   $0x801127a0
801027bb:	e8 ac 18 00 00       	call   8010406c <acquire>
801027c0:	83 c4 10             	add    $0x10,%esp
  while(1){
    if(log.committing){
801027c3:	83 3d e0 27 11 80 00 	cmpl   $0x0,0x801127e0
801027ca:	74 17                	je     801027e3 <begin_op+0x33>
      sleep(&log, &log.lock);
801027cc:	83 ec 08             	sub    $0x8,%esp
801027cf:	68 a0 27 11 80       	push   $0x801127a0
801027d4:	68 a0 27 11 80       	push   $0x801127a0
801027d9:	e8 8a 11 00 00       	call   80103968 <sleep>
801027de:	83 c4 10             	add    $0x10,%esp
801027e1:	eb e0                	jmp    801027c3 <begin_op+0x13>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
801027e3:	a1 dc 27 11 80       	mov    0x801127dc,%eax
801027e8:	83 c0 01             	add    $0x1,%eax
801027eb:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
801027ee:	8b 15 e8 27 11 80    	mov    0x801127e8,%edx
801027f4:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
801027f7:	83 fa 1e             	cmp    $0x1e,%edx
801027fa:	7e 17                	jle    80102813 <begin_op+0x63>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
801027fc:	83 ec 08             	sub    $0x8,%esp
801027ff:	68 a0 27 11 80       	push   $0x801127a0
80102804:	68 a0 27 11 80       	push   $0x801127a0
80102809:	e8 5a 11 00 00       	call   80103968 <sleep>
8010280e:	83 c4 10             	add    $0x10,%esp
80102811:	eb b0                	jmp    801027c3 <begin_op+0x13>
    } else {
      log.outstanding += 1;
80102813:	a3 dc 27 11 80       	mov    %eax,0x801127dc
      release(&log.lock);
80102818:	83 ec 0c             	sub    $0xc,%esp
8010281b:	68 a0 27 11 80       	push   $0x801127a0
80102820:	e8 0c 19 00 00       	call   80104131 <release>
      break;
    }
  }
}
80102825:	83 c4 10             	add    $0x10,%esp
80102828:	c9                   	leave  
80102829:	c3                   	ret    

8010282a <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
8010282a:	55                   	push   %ebp
8010282b:	89 e5                	mov    %esp,%ebp
8010282d:	57                   	push   %edi
8010282e:	56                   	push   %esi
8010282f:	53                   	push   %ebx
80102830:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102833:	68 a0 27 11 80       	push   $0x801127a0
80102838:	e8 2f 18 00 00       	call   8010406c <acquire>
  log.outstanding -= 1;
8010283d:	a1 dc 27 11 80       	mov    0x801127dc,%eax
80102842:	83 e8 01             	sub    $0x1,%eax
80102845:	a3 dc 27 11 80       	mov    %eax,0x801127dc
  if(log.committing)
8010284a:	83 c4 10             	add    $0x10,%esp
8010284d:	83 3d e0 27 11 80 00 	cmpl   $0x0,0x801127e0
80102854:	74 0d                	je     80102863 <end_op+0x39>
    panic("log.committing");
80102856:	83 ec 0c             	sub    $0xc,%esp
80102859:	68 84 71 10 80       	push   $0x80107184
8010285e:	e8 ea da ff ff       	call   8010034d <panic>
  if(log.outstanding == 0){
80102863:	85 c0                	test   %eax,%eax
80102865:	75 2d                	jne    80102894 <end_op+0x6a>
    do_commit = 1;
    log.committing = 1;
80102867:	c7 05 e0 27 11 80 01 	movl   $0x1,0x801127e0
8010286e:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102871:	83 ec 0c             	sub    $0xc,%esp
80102874:	68 a0 27 11 80       	push   $0x801127a0
80102879:	e8 b3 18 00 00       	call   80104131 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
8010287e:	83 c4 10             	add    $0x10,%esp
80102881:	bb 00 00 00 00       	mov    $0x0,%ebx
80102886:	83 3d e8 27 11 80 00 	cmpl   $0x0,0x801127e8
8010288d:	7f 26                	jg     801028b5 <end_op+0x8b>
8010288f:	e9 a8 00 00 00       	jmp    8010293c <end_op+0x112>
    log.committing = 1;
  } else {
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
80102894:	83 ec 0c             	sub    $0xc,%esp
80102897:	68 a0 27 11 80       	push   $0x801127a0
8010289c:	e8 1f 14 00 00       	call   80103cc0 <wakeup>
  }
  release(&log.lock);
801028a1:	c7 04 24 a0 27 11 80 	movl   $0x801127a0,(%esp)
801028a8:	e8 84 18 00 00       	call   80104131 <release>
801028ad:	83 c4 10             	add    $0x10,%esp
801028b0:	e9 b9 00 00 00       	jmp    8010296e <end_op+0x144>
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801028b5:	83 ec 08             	sub    $0x8,%esp
801028b8:	89 d8                	mov    %ebx,%eax
801028ba:	03 05 d4 27 11 80    	add    0x801127d4,%eax
801028c0:	83 c0 01             	add    $0x1,%eax
801028c3:	50                   	push   %eax
801028c4:	ff 35 e4 27 11 80    	pushl  0x801127e4
801028ca:	e8 db d7 ff ff       	call   801000aa <bread>
801028cf:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801028d1:	83 c4 08             	add    $0x8,%esp
801028d4:	ff 34 9d ec 27 11 80 	pushl  -0x7feed814(,%ebx,4)
801028db:	ff 35 e4 27 11 80    	pushl  0x801127e4
801028e1:	e8 c4 d7 ff ff       	call   801000aa <bread>
801028e6:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
801028e8:	83 c4 0c             	add    $0xc,%esp
801028eb:	68 00 02 00 00       	push   $0x200
801028f0:	8d 40 5c             	lea    0x5c(%eax),%eax
801028f3:	50                   	push   %eax
801028f4:	8d 46 5c             	lea    0x5c(%esi),%eax
801028f7:	50                   	push   %eax
801028f8:	e8 15 19 00 00       	call   80104212 <memmove>
    bwrite(to);  // write the log
801028fd:	89 34 24             	mov    %esi,(%esp)
80102900:	e8 81 d8 ff ff       	call   80100186 <bwrite>
    brelse(from);
80102905:	89 3c 24             	mov    %edi,(%esp)
80102908:	e8 b4 d8 ff ff       	call   801001c1 <brelse>
    brelse(to);
8010290d:	89 34 24             	mov    %esi,(%esp)
80102910:	e8 ac d8 ff ff       	call   801001c1 <brelse>
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102915:	83 c3 01             	add    $0x1,%ebx
80102918:	83 c4 10             	add    $0x10,%esp
8010291b:	3b 1d e8 27 11 80    	cmp    0x801127e8,%ebx
80102921:	7c 92                	jl     801028b5 <end_op+0x8b>
static void
commit()
{
  if (log.lh.n > 0) {
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102923:	e8 97 fd ff ff       	call   801026bf <write_head>
    install_trans(); // Now install writes to home locations
80102928:	e8 00 fd ff ff       	call   8010262d <install_trans>
    log.lh.n = 0;
8010292d:	c7 05 e8 27 11 80 00 	movl   $0x0,0x801127e8
80102934:	00 00 00 
    write_head();    // Erase the transaction from the log
80102937:	e8 83 fd ff ff       	call   801026bf <write_head>

  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
8010293c:	83 ec 0c             	sub    $0xc,%esp
8010293f:	68 a0 27 11 80       	push   $0x801127a0
80102944:	e8 23 17 00 00       	call   8010406c <acquire>
    log.committing = 0;
80102949:	c7 05 e0 27 11 80 00 	movl   $0x0,0x801127e0
80102950:	00 00 00 
    wakeup(&log);
80102953:	c7 04 24 a0 27 11 80 	movl   $0x801127a0,(%esp)
8010295a:	e8 61 13 00 00       	call   80103cc0 <wakeup>
    release(&log.lock);
8010295f:	c7 04 24 a0 27 11 80 	movl   $0x801127a0,(%esp)
80102966:	e8 c6 17 00 00       	call   80104131 <release>
8010296b:	83 c4 10             	add    $0x10,%esp
  }
}
8010296e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102971:	5b                   	pop    %ebx
80102972:	5e                   	pop    %esi
80102973:	5f                   	pop    %edi
80102974:	5d                   	pop    %ebp
80102975:	c3                   	ret    

80102976 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102976:	55                   	push   %ebp
80102977:	89 e5                	mov    %esp,%ebp
80102979:	53                   	push   %ebx
8010297a:	83 ec 04             	sub    $0x4,%esp
8010297d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102980:	8b 15 e8 27 11 80    	mov    0x801127e8,%edx
80102986:	83 fa 1d             	cmp    $0x1d,%edx
80102989:	7f 0c                	jg     80102997 <log_write+0x21>
8010298b:	a1 d8 27 11 80       	mov    0x801127d8,%eax
80102990:	83 e8 01             	sub    $0x1,%eax
80102993:	39 c2                	cmp    %eax,%edx
80102995:	7c 0d                	jl     801029a4 <log_write+0x2e>
    panic("too big a transaction");
80102997:	83 ec 0c             	sub    $0xc,%esp
8010299a:	68 93 71 10 80       	push   $0x80107193
8010299f:	e8 a9 d9 ff ff       	call   8010034d <panic>
  if (log.outstanding < 1)
801029a4:	83 3d dc 27 11 80 00 	cmpl   $0x0,0x801127dc
801029ab:	7f 0d                	jg     801029ba <log_write+0x44>
    panic("log_write outside of trans");
801029ad:	83 ec 0c             	sub    $0xc,%esp
801029b0:	68 a9 71 10 80       	push   $0x801071a9
801029b5:	e8 93 d9 ff ff       	call   8010034d <panic>

  acquire(&log.lock);
801029ba:	83 ec 0c             	sub    $0xc,%esp
801029bd:	68 a0 27 11 80       	push   $0x801127a0
801029c2:	e8 a5 16 00 00       	call   8010406c <acquire>
  for (i = 0; i < log.lh.n; i++) {
801029c7:	8b 15 e8 27 11 80    	mov    0x801127e8,%edx
801029cd:	83 c4 10             	add    $0x10,%esp
801029d0:	85 d2                	test   %edx,%edx
801029d2:	7e 24                	jle    801029f8 <log_write+0x82>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801029d4:	8b 4b 08             	mov    0x8(%ebx),%ecx
801029d7:	39 0d ec 27 11 80    	cmp    %ecx,0x801127ec
801029dd:	74 19                	je     801029f8 <log_write+0x82>
801029df:	b8 00 00 00 00       	mov    $0x0,%eax
801029e4:	eb 09                	jmp    801029ef <log_write+0x79>
801029e6:	39 0c 85 ec 27 11 80 	cmp    %ecx,-0x7feed814(,%eax,4)
801029ed:	74 3c                	je     80102a2b <log_write+0xb5>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
801029ef:	83 c0 01             	add    $0x1,%eax
801029f2:	39 d0                	cmp    %edx,%eax
801029f4:	75 f0                	jne    801029e6 <log_write+0x70>
801029f6:	eb 27                	jmp    80102a1f <log_write+0xa9>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
801029f8:	8b 43 08             	mov    0x8(%ebx),%eax
801029fb:	a3 ec 27 11 80       	mov    %eax,0x801127ec
  if (i == log.lh.n)
80102a00:	85 d2                	test   %edx,%edx
80102a02:	75 09                	jne    80102a0d <log_write+0x97>
    log.lh.n++;
80102a04:	83 c2 01             	add    $0x1,%edx
80102a07:	89 15 e8 27 11 80    	mov    %edx,0x801127e8
  b->flags |= B_DIRTY; // prevent eviction
80102a0d:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102a10:	83 ec 0c             	sub    $0xc,%esp
80102a13:	68 a0 27 11 80       	push   $0x801127a0
80102a18:	e8 14 17 00 00       	call   80104131 <release>
}
80102a1d:	eb 18                	jmp    80102a37 <log_write+0xc1>
  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102a1f:	8b 43 08             	mov    0x8(%ebx),%eax
80102a22:	89 04 95 ec 27 11 80 	mov    %eax,-0x7feed814(,%edx,4)
80102a29:	eb d9                	jmp    80102a04 <log_write+0x8e>
80102a2b:	8b 53 08             	mov    0x8(%ebx),%edx
80102a2e:	89 14 85 ec 27 11 80 	mov    %edx,-0x7feed814(,%eax,4)
80102a35:	eb d6                	jmp    80102a0d <log_write+0x97>
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
  release(&log.lock);
}
80102a37:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a3a:	c9                   	leave  
80102a3b:	c3                   	ret    

80102a3c <mpmain>:
    mpmain();
}

// Common CPU setup code.
static void
mpmain(void) {
80102a3c:	55                   	push   %ebp
80102a3d:	89 e5                	mov    %esp,%ebp
80102a3f:	53                   	push   %ebx
80102a40:	83 ec 04             	sub    $0x4,%esp
    cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102a43:	e8 37 09 00 00       	call   8010337f <cpuid>
80102a48:	89 c3                	mov    %eax,%ebx
80102a4a:	e8 30 09 00 00       	call   8010337f <cpuid>
80102a4f:	83 ec 04             	sub    $0x4,%esp
80102a52:	53                   	push   %ebx
80102a53:	50                   	push   %eax
80102a54:	68 c4 71 10 80       	push   $0x801071c4
80102a59:	e8 8b db ff ff       	call   801005e9 <cprintf>
    idtinit();       // load idt register
80102a5e:	e8 19 2c 00 00       	call   8010567c <idtinit>
    xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102a63:	e8 9c 08 00 00       	call   80103304 <mycpu>
80102a68:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102a6a:	b8 01 00 00 00       	mov    $0x1,%eax
80102a6f:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
    scheduler();     // start running processes
80102a76:	e8 4a 0c 00 00       	call   801036c5 <scheduler>

80102a7b <mpenter>:
    mpmain();        // finish this processor's setup
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void) {
80102a7b:	55                   	push   %ebp
80102a7c:	89 e5                	mov    %esp,%ebp
80102a7e:	83 ec 08             	sub    $0x8,%esp
    switchkvm();
80102a81:	e8 e2 3b 00 00       	call   80106668 <switchkvm>
    seginit();
80102a86:	e8 f6 3a 00 00       	call   80106581 <seginit>
    lapicinit();
80102a8b:	e8 ad f8 ff ff       	call   8010233d <lapicinit>
    mpmain();
80102a90:	e8 a7 ff ff ff       	call   80102a3c <mpmain>

80102a95 <main>:

// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void) {
80102a95:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102a99:	83 e4 f0             	and    $0xfffffff0,%esp
80102a9c:	ff 71 fc             	pushl  -0x4(%ecx)
80102a9f:	55                   	push   %ebp
80102aa0:	89 e5                	mov    %esp,%ebp
80102aa2:	53                   	push   %ebx
80102aa3:	51                   	push   %ecx
    kinit1(end, P2V(4 * 1024 * 1024)); // phys page allocator
80102aa4:	83 ec 08             	sub    $0x8,%esp
80102aa7:	68 00 00 40 80       	push   $0x80400000
80102aac:	68 c8 5d 11 80       	push   $0x80115dc8
80102ab1:	e8 55 f6 ff ff       	call   8010210b <kinit1>
    kvmalloc();      // kernel page table
80102ab6:	e8 27 40 00 00       	call   80106ae2 <kvmalloc>
    mpinit();        // detect other processors
80102abb:	e8 51 01 00 00       	call   80102c11 <mpinit>
    lapicinit();     // interrupt controller
80102ac0:	e8 78 f8 ff ff       	call   8010233d <lapicinit>
    seginit();       // segment descriptors
80102ac5:	e8 b7 3a 00 00       	call   80106581 <seginit>
    picinit();       // disable pic
80102aca:	e8 db 02 00 00       	call   80102daa <picinit>
    ioapicinit();    // another interrupt controller
80102acf:	e8 9b f4 ff ff       	call   80101f6f <ioapicinit>
    consoleinit();   // console hardware
80102ad4:	e8 da dd ff ff       	call   801008b3 <consoleinit>
    uartinit();      // serial port
80102ad9:	e8 82 2e 00 00       	call   80105960 <uartinit>
    pinit();         // process table
80102ade:	e8 07 08 00 00       	call   801032ea <pinit>
    tvinit();        // trap vectors
80102ae3:	e8 0c 2b 00 00       	call   801055f4 <tvinit>
    binit();         // buffer cache
80102ae8:	e8 47 d5 ff ff       	call   80100034 <binit>
    fileinit();      // file table
80102aed:	e8 94 e1 ff ff       	call   80100c86 <fileinit>
    ideinit();       // disk
80102af2:	e8 8b f2 ff ff       	call   80101d82 <ideinit>

    // Write entry code to unused memory at 0x7000.
    // The linker has placed the image of entryother.S in
    // _binary_entryother_start.
    code = P2V(0x7000);
    memmove(code, _binary_entryother_start, (uint) _binary_entryother_size);
80102af7:	83 c4 0c             	add    $0xc,%esp
80102afa:	68 8a 00 00 00       	push   $0x8a
80102aff:	68 8c a4 10 80       	push   $0x8010a48c
80102b04:	68 00 70 00 80       	push   $0x80007000
80102b09:	e8 04 17 00 00       	call   80104212 <memmove>

    for (c = cpus; c < cpus + ncpu; c++) {
80102b0e:	69 05 20 2e 11 80 b0 	imul   $0xb0,0x80112e20,%eax
80102b15:	00 00 00 
80102b18:	05 a0 28 11 80       	add    $0x801128a0,%eax
80102b1d:	83 c4 10             	add    $0x10,%esp
80102b20:	3d a0 28 11 80       	cmp    $0x801128a0,%eax
80102b25:	76 68                	jbe    80102b8f <main+0xfa>
80102b27:	bb a0 28 11 80       	mov    $0x801128a0,%ebx
        if (c == mycpu())  // We've started already.
80102b2c:	e8 d3 07 00 00       	call   80103304 <mycpu>
80102b31:	39 d8                	cmp    %ebx,%eax
80102b33:	74 41                	je     80102b76 <main+0xe1>
            continue;

        // Tell entryother.S what stack to use, where to enter, and what
        // pgdir to use. We cannot use kpgdir yet, because the AP processor
        // is running in low  memory, so we use entrypgdir for the APs too.
        stack = kalloc();
80102b35:	e8 23 f6 ff ff       	call   8010215d <kalloc>
        *(void **) (code - 4) = stack + KSTACKSIZE;
80102b3a:	05 00 10 00 00       	add    $0x1000,%eax
80102b3f:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
        *(void **) (code - 8) = mpenter;
80102b44:	c7 05 f8 6f 00 80 7b 	movl   $0x80102a7b,0x80006ff8
80102b4b:	2a 10 80 
        *(int **) (code - 12) = (void *) V2P(entrypgdir);
80102b4e:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102b55:	90 10 00 

        lapicstartap(c->apicid, V2P(code));
80102b58:	83 ec 08             	sub    $0x8,%esp
80102b5b:	68 00 70 00 00       	push   $0x7000
80102b60:	0f b6 03             	movzbl (%ebx),%eax
80102b63:	50                   	push   %eax
80102b64:	e8 17 f9 ff ff       	call   80102480 <lapicstartap>
80102b69:	83 c4 10             	add    $0x10,%esp

        // wait for cpu to finish mpmain()
        while (c->started == 0);
80102b6c:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102b72:	85 c0                	test   %eax,%eax
80102b74:	74 f6                	je     80102b6c <main+0xd7>
    // The linker has placed the image of entryother.S in
    // _binary_entryother_start.
    code = P2V(0x7000);
    memmove(code, _binary_entryother_start, (uint) _binary_entryother_size);

    for (c = cpus; c < cpus + ncpu; c++) {
80102b76:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102b7c:	69 05 20 2e 11 80 b0 	imul   $0xb0,0x80112e20,%eax
80102b83:	00 00 00 
80102b86:	05 a0 28 11 80       	add    $0x801128a0,%eax
80102b8b:	39 c3                	cmp    %eax,%ebx
80102b8d:	72 9d                	jb     80102b2c <main+0x97>
    tvinit();        // trap vectors
    binit();         // buffer cache
    fileinit();      // file table
    ideinit();       // disk
    startothers();   // start other processors
    kinit2(P2V(4 * 1024 * 1024), P2V(PHYSTOP)); // must come after startothers()
80102b8f:	83 ec 08             	sub    $0x8,%esp
80102b92:	68 00 00 00 8e       	push   $0x8e000000
80102b97:	68 00 00 40 80       	push   $0x80400000
80102b9c:	e8 9c f5 ff ff       	call   8010213d <kinit2>
    userinit();      // first user process
80102ba1:	e8 18 08 00 00       	call   801033be <userinit>
    mpmain();        // finish this processor's setup
80102ba6:	e8 91 fe ff ff       	call   80102a3c <mpmain>

80102bab <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102bab:	55                   	push   %ebp
80102bac:	89 e5                	mov    %esp,%ebp
80102bae:	57                   	push   %edi
80102baf:	56                   	push   %esi
80102bb0:	53                   	push   %ebx
80102bb1:	83 ec 0c             	sub    $0xc,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
80102bb4:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
  e = addr+len;
80102bba:	8d 34 13             	lea    (%ebx,%edx,1),%esi
  for(p = addr; p < e; p += sizeof(struct mp))
80102bbd:	39 f3                	cmp    %esi,%ebx
80102bbf:	73 3f                	jae    80102c00 <mpsearch1+0x55>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102bc1:	83 ec 04             	sub    $0x4,%esp
80102bc4:	6a 04                	push   $0x4
80102bc6:	68 d8 71 10 80       	push   $0x801071d8
80102bcb:	53                   	push   %ebx
80102bcc:	e8 eb 15 00 00       	call   801041bc <memcmp>
80102bd1:	83 c4 10             	add    $0x10,%esp
80102bd4:	85 c0                	test   %eax,%eax
80102bd6:	75 1a                	jne    80102bf2 <mpsearch1+0x47>
80102bd8:	89 d8                	mov    %ebx,%eax
80102bda:	8d 7b 10             	lea    0x10(%ebx),%edi
80102bdd:	ba 00 00 00 00       	mov    $0x0,%edx
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
80102be2:	0f b6 08             	movzbl (%eax),%ecx
80102be5:	01 ca                	add    %ecx,%edx
80102be7:	83 c0 01             	add    $0x1,%eax
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80102bea:	39 c7                	cmp    %eax,%edi
80102bec:	75 f4                	jne    80102be2 <mpsearch1+0x37>
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102bee:	84 d2                	test   %dl,%dl
80102bf0:	74 15                	je     80102c07 <mpsearch1+0x5c>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80102bf2:	83 c3 10             	add    $0x10,%ebx
80102bf5:	39 de                	cmp    %ebx,%esi
80102bf7:	77 c8                	ja     80102bc1 <mpsearch1+0x16>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80102bf9:	b8 00 00 00 00       	mov    $0x0,%eax
80102bfe:	eb 09                	jmp    80102c09 <mpsearch1+0x5e>
80102c00:	b8 00 00 00 00       	mov    $0x0,%eax
80102c05:	eb 02                	jmp    80102c09 <mpsearch1+0x5e>
80102c07:	89 d8                	mov    %ebx,%eax
}
80102c09:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c0c:	5b                   	pop    %ebx
80102c0d:	5e                   	pop    %esi
80102c0e:	5f                   	pop    %edi
80102c0f:	5d                   	pop    %ebp
80102c10:	c3                   	ret    

80102c11 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80102c11:	55                   	push   %ebp
80102c12:	89 e5                	mov    %esp,%ebp
80102c14:	57                   	push   %edi
80102c15:	56                   	push   %esi
80102c16:	53                   	push   %ebx
80102c17:	83 ec 1c             	sub    $0x1c,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80102c1a:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80102c21:	c1 e0 08             	shl    $0x8,%eax
80102c24:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80102c2b:	09 d0                	or     %edx,%eax
80102c2d:	c1 e0 04             	shl    $0x4,%eax
80102c30:	85 c0                	test   %eax,%eax
80102c32:	74 13                	je     80102c47 <mpinit+0x36>
    if((mp = mpsearch1(p, 1024)))
80102c34:	ba 00 04 00 00       	mov    $0x400,%edx
80102c39:	e8 6d ff ff ff       	call   80102bab <mpsearch1>
80102c3e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80102c41:	85 c0                	test   %eax,%eax
80102c43:	75 44                	jne    80102c89 <mpinit+0x78>
80102c45:	eb 2c                	jmp    80102c73 <mpinit+0x62>
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
80102c47:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80102c4e:	c1 e0 08             	shl    $0x8,%eax
80102c51:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80102c58:	09 d0                	or     %edx,%eax
80102c5a:	c1 e0 0a             	shl    $0xa,%eax
80102c5d:	2d 00 04 00 00       	sub    $0x400,%eax
80102c62:	ba 00 04 00 00       	mov    $0x400,%edx
80102c67:	e8 3f ff ff ff       	call   80102bab <mpsearch1>
80102c6c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80102c6f:	85 c0                	test   %eax,%eax
80102c71:	75 16                	jne    80102c89 <mpinit+0x78>
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
80102c73:	ba 00 00 01 00       	mov    $0x10000,%edx
80102c78:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80102c7d:	e8 29 ff ff ff       	call   80102bab <mpsearch1>
80102c82:	89 45 e4             	mov    %eax,-0x1c(%ebp)
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80102c85:	85 c0                	test   %eax,%eax
80102c87:	74 64                	je     80102ced <mpinit+0xdc>
80102c89:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102c8c:	8b 58 04             	mov    0x4(%eax),%ebx
80102c8f:	85 db                	test   %ebx,%ebx
80102c91:	74 5a                	je     80102ced <mpinit+0xdc>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80102c93:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80102c99:	83 ec 04             	sub    $0x4,%esp
80102c9c:	6a 04                	push   $0x4
80102c9e:	68 dd 71 10 80       	push   $0x801071dd
80102ca3:	56                   	push   %esi
80102ca4:	e8 13 15 00 00       	call   801041bc <memcmp>
80102ca9:	83 c4 10             	add    $0x10,%esp
80102cac:	85 c0                	test   %eax,%eax
80102cae:	75 3d                	jne    80102ced <mpinit+0xdc>
    return 0;
  if(conf->version != 1 && conf->version != 4)
80102cb0:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80102cb7:	3c 01                	cmp    $0x1,%al
80102cb9:	74 04                	je     80102cbf <mpinit+0xae>
80102cbb:	3c 04                	cmp    $0x4,%al
80102cbd:	75 2e                	jne    80102ced <mpinit+0xdc>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80102cbf:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80102cc6:	85 ff                	test   %edi,%edi
80102cc8:	7e 1f                	jle    80102ce9 <mpinit+0xd8>
80102cca:	ba 00 00 00 00       	mov    $0x0,%edx
80102ccf:	b8 00 00 00 00       	mov    $0x0,%eax
    sum += addr[i];
80102cd4:	0f b6 8c 03 00 00 00 	movzbl -0x80000000(%ebx,%eax,1),%ecx
80102cdb:	80 
80102cdc:	01 ca                	add    %ecx,%edx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80102cde:	83 c0 01             	add    $0x1,%eax
80102ce1:	39 c7                	cmp    %eax,%edi
80102ce3:	75 ef                	jne    80102cd4 <mpinit+0xc3>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80102ce5:	84 d2                	test   %dl,%dl
80102ce7:	75 04                	jne    80102ced <mpinit+0xdc>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80102ce9:	85 f6                	test   %esi,%esi
80102ceb:	75 0d                	jne    80102cfa <mpinit+0xe9>
    panic("Expect to run on an SMP");
80102ced:	83 ec 0c             	sub    $0xc,%esp
80102cf0:	68 e2 71 10 80       	push   $0x801071e2
80102cf5:	e8 53 d6 ff ff       	call   8010034d <panic>
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80102cfa:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80102d00:	a3 9c 27 11 80       	mov    %eax,0x8011279c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102d05:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
80102d0b:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80102d12:	01 d6                	add    %edx,%esi
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
80102d14:	bb 01 00 00 00       	mov    $0x1,%ebx
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102d19:	eb 54                	jmp    80102d6f <mpinit+0x15e>
    switch(*p){
80102d1b:	0f b6 10             	movzbl (%eax),%edx
80102d1e:	eb 05                	jmp    80102d25 <mpinit+0x114>
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      ismp = 0;
80102d20:	bb 00 00 00 00       	mov    $0x0,%ebx
  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
80102d25:	80 fa 04             	cmp    $0x4,%dl
80102d28:	77 f6                	ja     80102d20 <mpinit+0x10f>
80102d2a:	0f b6 d2             	movzbl %dl,%edx
80102d2d:	ff 24 95 1c 72 10 80 	jmp    *-0x7fef8de4(,%edx,4)
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
80102d34:	8b 0d 20 2e 11 80    	mov    0x80112e20,%ecx
80102d3a:	83 f9 07             	cmp    $0x7,%ecx
80102d3d:	7f 19                	jg     80102d58 <mpinit+0x147>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80102d3f:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80102d43:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80102d49:	88 97 a0 28 11 80    	mov    %dl,-0x7feed760(%edi)
        ncpu++;
80102d4f:	83 c1 01             	add    $0x1,%ecx
80102d52:	89 0d 20 2e 11 80    	mov    %ecx,0x80112e20
      }
      p += sizeof(struct mpproc);
80102d58:	83 c0 14             	add    $0x14,%eax
      continue;
80102d5b:	eb 12                	jmp    80102d6f <mpinit+0x15e>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
80102d5d:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80102d61:	88 15 80 28 11 80    	mov    %dl,0x80112880
      p += sizeof(struct mpioapic);
80102d67:	83 c0 08             	add    $0x8,%eax
      continue;
80102d6a:	eb 03                	jmp    80102d6f <mpinit+0x15e>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80102d6c:	83 c0 08             	add    $0x8,%eax

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102d6f:	39 f0                	cmp    %esi,%eax
80102d71:	72 a8                	jb     80102d1b <mpinit+0x10a>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80102d73:	85 db                	test   %ebx,%ebx
80102d75:	75 0d                	jne    80102d84 <mpinit+0x173>
    panic("Didn't find a suitable machine");
80102d77:	83 ec 0c             	sub    $0xc,%esp
80102d7a:	68 fc 71 10 80       	push   $0x801071fc
80102d7f:	e8 c9 d5 ff ff       	call   8010034d <panic>

  if(mp->imcrp){
80102d84:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102d87:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80102d8b:	74 15                	je     80102da2 <mpinit+0x191>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d8d:	ba 22 00 00 00       	mov    $0x22,%edx
80102d92:	b8 70 00 00 00       	mov    $0x70,%eax
80102d97:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d98:	ba 23 00 00 00       	mov    $0x23,%edx
80102d9d:	ec                   	in     (%dx),%al
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d9e:	83 c8 01             	or     $0x1,%eax
80102da1:	ee                   	out    %al,(%dx)
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
80102da2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102da5:	5b                   	pop    %ebx
80102da6:	5e                   	pop    %esi
80102da7:	5f                   	pop    %edi
80102da8:	5d                   	pop    %ebp
80102da9:	c3                   	ret    

80102daa <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80102daa:	55                   	push   %ebp
80102dab:	89 e5                	mov    %esp,%ebp
80102dad:	ba 21 00 00 00       	mov    $0x21,%edx
80102db2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102db7:	ee                   	out    %al,(%dx)
80102db8:	ba a1 00 00 00       	mov    $0xa1,%edx
80102dbd:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80102dbe:	5d                   	pop    %ebp
80102dbf:	c3                   	ret    

80102dc0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80102dc0:	55                   	push   %ebp
80102dc1:	89 e5                	mov    %esp,%ebp
80102dc3:	57                   	push   %edi
80102dc4:	56                   	push   %esi
80102dc5:	53                   	push   %ebx
80102dc6:	83 ec 0c             	sub    $0xc,%esp
80102dc9:	8b 75 08             	mov    0x8(%ebp),%esi
80102dcc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80102dcf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80102dd5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80102ddb:	e8 c0 de ff ff       	call   80100ca0 <filealloc>
80102de0:	89 06                	mov    %eax,(%esi)
80102de2:	85 c0                	test   %eax,%eax
80102de4:	0f 84 9c 00 00 00    	je     80102e86 <pipealloc+0xc6>
80102dea:	e8 b1 de ff ff       	call   80100ca0 <filealloc>
80102def:	89 03                	mov    %eax,(%ebx)
80102df1:	85 c0                	test   %eax,%eax
80102df3:	0f 84 b3 00 00 00    	je     80102eac <pipealloc+0xec>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80102df9:	e8 5f f3 ff ff       	call   8010215d <kalloc>
80102dfe:	89 c7                	mov    %eax,%edi
80102e00:	85 c0                	test   %eax,%eax
80102e02:	0f 84 9c 00 00 00    	je     80102ea4 <pipealloc+0xe4>
    goto bad;
  p->readopen = 1;
80102e08:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80102e0f:	00 00 00 
  p->writeopen = 1;
80102e12:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80102e19:	00 00 00 
  p->nwrite = 0;
80102e1c:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80102e23:	00 00 00 
  p->nread = 0;
80102e26:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80102e2d:	00 00 00 
  initlock(&p->lock, "pipe");
80102e30:	83 ec 08             	sub    $0x8,%esp
80102e33:	68 30 72 10 80       	push   $0x80107230
80102e38:	50                   	push   %eax
80102e39:	e8 4a 11 00 00       	call   80103f88 <initlock>
  (*f0)->type = FD_PIPE;
80102e3e:	8b 06                	mov    (%esi),%eax
80102e40:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80102e46:	8b 06                	mov    (%esi),%eax
80102e48:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80102e4c:	8b 06                	mov    (%esi),%eax
80102e4e:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80102e52:	8b 06                	mov    (%esi),%eax
80102e54:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80102e57:	8b 03                	mov    (%ebx),%eax
80102e59:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80102e5f:	8b 03                	mov    (%ebx),%eax
80102e61:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80102e65:	8b 03                	mov    (%ebx),%eax
80102e67:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80102e6b:	8b 03                	mov    (%ebx),%eax
80102e6d:	89 78 0c             	mov    %edi,0xc(%eax)
  return 0;
80102e70:	83 c4 10             	add    $0x10,%esp
80102e73:	b8 00 00 00 00       	mov    $0x0,%eax
80102e78:	eb 3d                	jmp    80102eb7 <pipealloc+0xf7>
//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
    fileclose(*f0);
80102e7a:	83 ec 0c             	sub    $0xc,%esp
80102e7d:	50                   	push   %eax
80102e7e:	e8 d3 de ff ff       	call   80100d56 <fileclose>
80102e83:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80102e86:	8b 13                	mov    (%ebx),%edx
    fileclose(*f1);
  return -1;
80102e88:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
    fileclose(*f0);
  if(*f1)
80102e8d:	85 d2                	test   %edx,%edx
80102e8f:	74 26                	je     80102eb7 <pipealloc+0xf7>
    fileclose(*f1);
80102e91:	83 ec 0c             	sub    $0xc,%esp
80102e94:	52                   	push   %edx
80102e95:	e8 bc de ff ff       	call   80100d56 <fileclose>
80102e9a:	83 c4 10             	add    $0x10,%esp
  return -1;
80102e9d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102ea2:	eb 13                	jmp    80102eb7 <pipealloc+0xf7>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80102ea4:	8b 06                	mov    (%esi),%eax
80102ea6:	85 c0                	test   %eax,%eax
80102ea8:	75 d0                	jne    80102e7a <pipealloc+0xba>
80102eaa:	eb da                	jmp    80102e86 <pipealloc+0xc6>
80102eac:	8b 06                	mov    (%esi),%eax
80102eae:	85 c0                	test   %eax,%eax
80102eb0:	75 c8                	jne    80102e7a <pipealloc+0xba>
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
80102eb2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102eb7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102eba:	5b                   	pop    %ebx
80102ebb:	5e                   	pop    %esi
80102ebc:	5f                   	pop    %edi
80102ebd:	5d                   	pop    %ebp
80102ebe:	c3                   	ret    

80102ebf <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80102ebf:	55                   	push   %ebp
80102ec0:	89 e5                	mov    %esp,%ebp
80102ec2:	53                   	push   %ebx
80102ec3:	83 ec 10             	sub    $0x10,%esp
80102ec6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&p->lock);
80102ec9:	53                   	push   %ebx
80102eca:	e8 9d 11 00 00       	call   8010406c <acquire>
  if(writable){
80102ecf:	83 c4 10             	add    $0x10,%esp
80102ed2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102ed6:	74 1e                	je     80102ef6 <pipeclose+0x37>
    p->writeopen = 0;
80102ed8:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80102edf:	00 00 00 
    wakeup(&p->nread);
80102ee2:	83 ec 0c             	sub    $0xc,%esp
80102ee5:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102eeb:	50                   	push   %eax
80102eec:	e8 cf 0d 00 00       	call   80103cc0 <wakeup>
80102ef1:	83 c4 10             	add    $0x10,%esp
80102ef4:	eb 1c                	jmp    80102f12 <pipeclose+0x53>
  } else {
    p->readopen = 0;
80102ef6:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80102efd:	00 00 00 
    wakeup(&p->nwrite);
80102f00:	83 ec 0c             	sub    $0xc,%esp
80102f03:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80102f09:	50                   	push   %eax
80102f0a:	e8 b1 0d 00 00       	call   80103cc0 <wakeup>
80102f0f:	83 c4 10             	add    $0x10,%esp
  }
  if(p->readopen == 0 && p->writeopen == 0){
80102f12:	83 bb 3c 02 00 00 00 	cmpl   $0x0,0x23c(%ebx)
80102f19:	75 1f                	jne    80102f3a <pipeclose+0x7b>
80102f1b:	83 bb 40 02 00 00 00 	cmpl   $0x0,0x240(%ebx)
80102f22:	75 16                	jne    80102f3a <pipeclose+0x7b>
    release(&p->lock);
80102f24:	83 ec 0c             	sub    $0xc,%esp
80102f27:	53                   	push   %ebx
80102f28:	e8 04 12 00 00       	call   80104131 <release>
    kfree((char*)p);
80102f2d:	89 1c 24             	mov    %ebx,(%esp)
80102f30:	e8 07 f1 ff ff       	call   8010203c <kfree>
80102f35:	83 c4 10             	add    $0x10,%esp
80102f38:	eb 0c                	jmp    80102f46 <pipeclose+0x87>
  } else
    release(&p->lock);
80102f3a:	83 ec 0c             	sub    $0xc,%esp
80102f3d:	53                   	push   %ebx
80102f3e:	e8 ee 11 00 00       	call   80104131 <release>
80102f43:	83 c4 10             	add    $0x10,%esp
}
80102f46:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102f49:	c9                   	leave  
80102f4a:	c3                   	ret    

80102f4b <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80102f4b:	55                   	push   %ebp
80102f4c:	89 e5                	mov    %esp,%ebp
80102f4e:	57                   	push   %edi
80102f4f:	56                   	push   %esi
80102f50:	53                   	push   %ebx
80102f51:	83 ec 28             	sub    $0x28,%esp
80102f54:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102f57:	8b 75 0c             	mov    0xc(%ebp),%esi
  int i;

  acquire(&p->lock);
80102f5a:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80102f5d:	53                   	push   %ebx
80102f5e:	e8 09 11 00 00       	call   8010406c <acquire>
  for(i = 0; i < n; i++){
80102f63:	83 c4 10             	add    $0x10,%esp
80102f66:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80102f6a:	0f 8e bb 00 00 00    	jle    8010302b <pipewrite+0xe0>
80102f70:	89 75 e0             	mov    %esi,-0x20(%ebp)
80102f73:	03 75 10             	add    0x10(%ebp),%esi
80102f76:	89 75 dc             	mov    %esi,-0x24(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80102f79:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80102f7f:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80102f85:	eb 7d                	jmp    80103004 <pipewrite+0xb9>
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
80102f87:	83 bb 3c 02 00 00 00 	cmpl   $0x0,0x23c(%ebx)
80102f8e:	74 0b                	je     80102f9b <pipewrite+0x50>
80102f90:	e8 05 04 00 00       	call   8010339a <myproc>
80102f95:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80102f99:	74 16                	je     80102fb1 <pipewrite+0x66>
        release(&p->lock);
80102f9b:	83 ec 0c             	sub    $0xc,%esp
80102f9e:	53                   	push   %ebx
80102f9f:	e8 8d 11 00 00       	call   80104131 <release>
        return -1;
80102fa4:	83 c4 10             	add    $0x10,%esp
80102fa7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102fac:	e9 97 00 00 00       	jmp    80103048 <pipewrite+0xfd>
      }
      wakeup(&p->nread);
80102fb1:	83 ec 0c             	sub    $0xc,%esp
80102fb4:	57                   	push   %edi
80102fb5:	e8 06 0d 00 00       	call   80103cc0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80102fba:	83 c4 08             	add    $0x8,%esp
80102fbd:	ff 75 e4             	pushl  -0x1c(%ebp)
80102fc0:	56                   	push   %esi
80102fc1:	e8 a2 09 00 00       	call   80103968 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80102fc6:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80102fcc:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80102fd2:	05 00 02 00 00       	add    $0x200,%eax
80102fd7:	83 c4 10             	add    $0x10,%esp
80102fda:	39 c2                	cmp    %eax,%edx
80102fdc:	74 a9                	je     80102f87 <pipewrite+0x3c>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80102fde:	8d 42 01             	lea    0x1(%edx),%eax
80102fe1:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80102fe7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80102fea:	0f b6 01             	movzbl (%ecx),%eax
80102fed:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80102ff3:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
80102ff7:	89 c8                	mov    %ecx,%eax
80102ff9:	83 c0 01             	add    $0x1,%eax
80102ffc:	89 45 e0             	mov    %eax,-0x20(%ebp)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80102fff:	3b 45 dc             	cmp    -0x24(%ebp),%eax
80103002:	74 27                	je     8010302b <pipewrite+0xe0>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103004:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010300a:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103010:	05 00 02 00 00       	add    $0x200,%eax
80103015:	39 c2                	cmp    %eax,%edx
80103017:	75 c5                	jne    80102fde <pipewrite+0x93>
      if(p->readopen == 0 || myproc()->killed){
80103019:	83 bb 3c 02 00 00 00 	cmpl   $0x0,0x23c(%ebx)
80103020:	0f 84 75 ff ff ff    	je     80102f9b <pipewrite+0x50>
80103026:	e9 65 ff ff ff       	jmp    80102f90 <pipewrite+0x45>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
8010302b:	83 ec 0c             	sub    $0xc,%esp
8010302e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103034:	50                   	push   %eax
80103035:	e8 86 0c 00 00       	call   80103cc0 <wakeup>
  release(&p->lock);
8010303a:	89 1c 24             	mov    %ebx,(%esp)
8010303d:	e8 ef 10 00 00       	call   80104131 <release>
  return n;
80103042:	83 c4 10             	add    $0x10,%esp
80103045:	8b 45 10             	mov    0x10(%ebp),%eax
}
80103048:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010304b:	5b                   	pop    %ebx
8010304c:	5e                   	pop    %esi
8010304d:	5f                   	pop    %edi
8010304e:	5d                   	pop    %ebp
8010304f:	c3                   	ret    

80103050 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103050:	55                   	push   %ebp
80103051:	89 e5                	mov    %esp,%ebp
80103053:	57                   	push   %edi
80103054:	56                   	push   %esi
80103055:	53                   	push   %ebx
80103056:	83 ec 18             	sub    $0x18,%esp
80103059:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010305c:	53                   	push   %ebx
8010305d:	e8 0a 10 00 00       	call   8010406c <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103062:	83 c4 10             	add    $0x10,%esp
80103065:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
8010306b:	39 83 34 02 00 00    	cmp    %eax,0x234(%ebx)
80103071:	0f 85 bc 00 00 00    	jne    80103133 <piperead+0xe3>
80103077:	89 de                	mov    %ebx,%esi
80103079:	83 bb 40 02 00 00 00 	cmpl   $0x0,0x240(%ebx)
80103080:	0f 84 bc 00 00 00    	je     80103142 <piperead+0xf2>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103086:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
    if(myproc()->killed){
8010308c:	e8 09 03 00 00       	call   8010339a <myproc>
80103091:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80103095:	74 16                	je     801030ad <piperead+0x5d>
      release(&p->lock);
80103097:	83 ec 0c             	sub    $0xc,%esp
8010309a:	53                   	push   %ebx
8010309b:	e8 91 10 00 00       	call   80104131 <release>
      return -1;
801030a0:	83 c4 10             	add    $0x10,%esp
801030a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801030a8:	e9 9e 00 00 00       	jmp    8010314b <piperead+0xfb>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801030ad:	83 ec 08             	sub    $0x8,%esp
801030b0:	56                   	push   %esi
801030b1:	57                   	push   %edi
801030b2:	e8 b1 08 00 00       	call   80103968 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801030b7:	83 c4 10             	add    $0x10,%esp
801030ba:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
801030c0:	39 83 34 02 00 00    	cmp    %eax,0x234(%ebx)
801030c6:	75 6b                	jne    80103133 <piperead+0xe3>
801030c8:	83 bb 40 02 00 00 00 	cmpl   $0x0,0x240(%ebx)
801030cf:	75 bb                	jne    8010308c <piperead+0x3c>
801030d1:	eb 6f                	jmp    80103142 <piperead+0xf2>
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    if(p->nread == p->nwrite)
801030d3:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801030d9:	3b 83 38 02 00 00    	cmp    0x238(%ebx),%eax
801030df:	74 23                	je     80103104 <piperead+0xb4>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
801030e1:	8d 48 01             	lea    0x1(%eax),%ecx
801030e4:	89 8b 34 02 00 00    	mov    %ecx,0x234(%ebx)
801030ea:	25 ff 01 00 00       	and    $0x1ff,%eax
801030ef:	0f b6 44 03 34       	movzbl 0x34(%ebx,%eax,1),%eax
801030f4:	8b 7d 0c             	mov    0xc(%ebp),%edi
801030f7:	88 04 17             	mov    %al,(%edi,%edx,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801030fa:	83 c2 01             	add    $0x1,%edx
801030fd:	39 55 10             	cmp    %edx,0x10(%ebp)
80103100:	75 d1                	jne    801030d3 <piperead+0x83>
80103102:	eb 03                	jmp    80103107 <piperead+0xb7>
80103104:	89 55 10             	mov    %edx,0x10(%ebp)
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103107:	83 ec 0c             	sub    $0xc,%esp
8010310a:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103110:	50                   	push   %eax
80103111:	e8 aa 0b 00 00       	call   80103cc0 <wakeup>
  release(&p->lock);
80103116:	89 1c 24             	mov    %ebx,(%esp)
80103119:	e8 13 10 00 00       	call   80104131 <release>
  return i;
8010311e:	83 c4 10             	add    $0x10,%esp
80103121:	8b 45 10             	mov    0x10(%ebp),%eax
80103124:	eb 25                	jmp    8010314b <piperead+0xfb>
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    if(p->nread == p->nwrite)
80103126:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010312c:	ba 00 00 00 00       	mov    $0x0,%edx
80103131:	eb ae                	jmp    801030e1 <piperead+0x91>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103133:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80103137:	7f ed                	jg     80103126 <piperead+0xd6>
80103139:	c7 45 10 00 00 00 00 	movl   $0x0,0x10(%ebp)
80103140:	eb c5                	jmp    80103107 <piperead+0xb7>
80103142:	c7 45 10 00 00 00 00 	movl   $0x0,0x10(%ebp)
80103149:	eb bc                	jmp    80103107 <piperead+0xb7>
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
8010314b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010314e:	5b                   	pop    %ebx
8010314f:	5e                   	pop    %esi
80103150:	5f                   	pop    %edi
80103151:	5d                   	pop    %ebp
80103152:	c3                   	ret    

80103153 <wakeup1>:

//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan) {
80103153:	55                   	push   %ebp
80103154:	89 e5                	mov    %esp,%ebp
    struct proc *p;

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103156:	ba 74 2e 11 80       	mov    $0x80112e74,%edx
        if (p->state == SLEEPING && p->chan == chan) {
8010315b:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
8010315f:	75 0c                	jne    8010316d <wakeup1+0x1a>
80103161:	39 42 20             	cmp    %eax,0x20(%edx)
80103164:	75 07                	jne    8010316d <wakeup1+0x1a>
            p->state = RUNNABLE;
80103166:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
// The ptable lock must be held.
static void
wakeup1(void *chan) {
    struct proc *p;

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010316d:	81 c2 98 00 00 00    	add    $0x98,%edx
80103173:	81 fa 74 54 11 80    	cmp    $0x80115474,%edx
80103179:	75 e0                	jne    8010315b <wakeup1+0x8>
#ifdef FCFS
            enqueue(p);
#endif

        }
}
8010317b:	5d                   	pop    %ebp
8010317c:	c3                   	ret    

8010317d <allocproc>:
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc *
allocproc(void) {
8010317d:	55                   	push   %ebp
8010317e:	89 e5                	mov    %esp,%ebp
80103180:	53                   	push   %ebx
80103181:	83 ec 10             	sub    $0x10,%esp
    struct proc *p;
    char *sp;
    acquire(&ptable.lock);
80103184:	68 40 2e 11 80       	push   $0x80112e40
80103189:	e8 de 0e 00 00       	call   8010406c <acquire>
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
        if (p->state == UNUSED)
8010318e:	83 c4 10             	add    $0x10,%esp
80103191:	83 3d 80 2e 11 80 00 	cmpl   $0x0,0x80112e80
80103198:	74 32                	je     801031cc <allocproc+0x4f>
8010319a:	bb 74 2e 11 80       	mov    $0x80112e74,%ebx
8010319f:	eb 06                	jmp    801031a7 <allocproc+0x2a>
801031a1:	83 7b 0c 00          	cmpl   $0x0,0xc(%ebx)
801031a5:	74 2a                	je     801031d1 <allocproc+0x54>
static struct proc *
allocproc(void) {
    struct proc *p;
    char *sp;
    acquire(&ptable.lock);
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801031a7:	81 c3 98 00 00 00    	add    $0x98,%ebx
801031ad:	81 fb 74 54 11 80    	cmp    $0x80115474,%ebx
801031b3:	75 ec                	jne    801031a1 <allocproc+0x24>
        if (p->state == UNUSED)
            goto found;

    release(&ptable.lock);
801031b5:	83 ec 0c             	sub    $0xc,%esp
801031b8:	68 40 2e 11 80       	push   $0x80112e40
801031bd:	e8 6f 0f 00 00       	call   80104131 <release>
    return 0;
801031c2:	83 c4 10             	add    $0x10,%esp
801031c5:	b8 00 00 00 00       	mov    $0x0,%eax
801031ca:	eb 79                	jmp    80103245 <allocproc+0xc8>
static struct proc *
allocproc(void) {
    struct proc *p;
    char *sp;
    acquire(&ptable.lock);
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801031cc:	bb 74 2e 11 80       	mov    $0x80112e74,%ebx

    release(&ptable.lock);
    return 0;

    found:
    p->state = EMBRYO;
801031d1:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
    p->pid = nextpid++;
801031d8:	a1 04 a0 10 80       	mov    0x8010a004,%eax
801031dd:	8d 50 01             	lea    0x1(%eax),%edx
801031e0:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
801031e6:	89 43 10             	mov    %eax,0x10(%ebx)

    release(&ptable.lock);
801031e9:	83 ec 0c             	sub    $0xc,%esp
801031ec:	68 40 2e 11 80       	push   $0x80112e40
801031f1:	e8 3b 0f 00 00       	call   80104131 <release>

    // Allocate kernel stack.
    if ((p->kstack = kalloc()) == 0) {
801031f6:	e8 62 ef ff ff       	call   8010215d <kalloc>
801031fb:	89 43 08             	mov    %eax,0x8(%ebx)
801031fe:	83 c4 10             	add    $0x10,%esp
80103201:	85 c0                	test   %eax,%eax
80103203:	75 09                	jne    8010320e <allocproc+0x91>
        p->state = UNUSED;
80103205:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        return 0;
8010320c:	eb 37                	jmp    80103245 <allocproc+0xc8>
    }
    sp = p->kstack + KSTACKSIZE;

    // Leave room for trap frame.
    sp -= sizeof *p->tf;
8010320e:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
80103214:	89 53 18             	mov    %edx,0x18(%ebx)
    p->tf = (struct trapframe *) sp;

    // Set up new context to start executing at forkret,
    // which returns to trapret.
    sp -= 4;
    *(uint *) sp = (uint) trapret;
80103217:	c7 80 b0 0f 00 00 e9 	movl   $0x801055e9,0xfb0(%eax)
8010321e:	55 10 80 

    sp -= sizeof *p->context;
80103221:	05 9c 0f 00 00       	add    $0xf9c,%eax
    p->context = (struct context *) sp;
80103226:	89 43 1c             	mov    %eax,0x1c(%ebx)
    memset(p->context, 0, sizeof *p->context);
80103229:	83 ec 04             	sub    $0x4,%esp
8010322c:	6a 14                	push   $0x14
8010322e:	6a 00                	push   $0x0
80103230:	50                   	push   %eax
80103231:	e8 42 0f 00 00       	call   80104178 <memset>
    p->context->eip = (uint) forkret;
80103236:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103239:	c7 40 10 4a 32 10 80 	movl   $0x8010324a,0x10(%eax)
    return p;
80103240:	83 c4 10             	add    $0x10,%esp
80103243:	89 d8                	mov    %ebx,%eax
}
80103245:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103248:	c9                   	leave  
80103249:	c3                   	ret    

8010324a <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void) {
8010324a:	55                   	push   %ebp
8010324b:	89 e5                	mov    %esp,%ebp
8010324d:	83 ec 14             	sub    $0x14,%esp
    static int first = 1;
    // Still holding ptable.lock from scheduler.
    release(&ptable.lock);
80103250:	68 40 2e 11 80       	push   $0x80112e40
80103255:	e8 d7 0e 00 00       	call   80104131 <release>

    if (first) {
8010325a:	83 c4 10             	add    $0x10,%esp
8010325d:	83 3d 00 a0 10 80 00 	cmpl   $0x0,0x8010a000
80103264:	74 23                	je     80103289 <forkret+0x3f>
        // Some initialization functions must be run in the context
        // of a regular process (e.g., they call sleep), and thus cannot
        // be run from main().
        first = 0;
80103266:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
8010326d:	00 00 00 
        iinit(ROOTDEV);
80103270:	83 ec 0c             	sub    $0xc,%esp
80103273:	6a 01                	push   $0x1
80103275:	e8 a0 e0 ff ff       	call   8010131a <iinit>
        initlog(ROOTDEV);
8010327a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103281:	e8 95 f4 ff ff       	call   8010271b <initlog>
80103286:	83 c4 10             	add    $0x10,%esp
    }

    // Return to "caller", actually trapret (see allocproc).
}
80103289:	c9                   	leave  
8010328a:	c3                   	ret    

8010328b <enqueue>:
        .lastIndex= 0};

//Enqueue a process (pointer)
void enqueue(struct proc *toAdd) {

    if (pq.lastIndex == NPROC) {
8010328b:	a1 c0 a6 10 80       	mov    0x8010a6c0,%eax
80103290:	83 f8 40             	cmp    $0x40,%eax
80103293:	74 16                	je     801032ab <enqueue+0x20>
    int lastIndex;
} pq = {.processes={0},
        .lastIndex= 0};

//Enqueue a process (pointer)
void enqueue(struct proc *toAdd) {
80103295:	55                   	push   %ebp
80103296:	89 e5                	mov    %esp,%ebp

    if (pq.lastIndex == NPROC) {
        //no place
    } else {
        pq.processes[pq.lastIndex] = toAdd;
80103298:	8b 55 08             	mov    0x8(%ebp),%edx
8010329b:	89 14 85 c0 a5 10 80 	mov    %edx,-0x7fef5a40(,%eax,4)
        pq.lastIndex++;
801032a2:	83 c0 01             	add    $0x1,%eax
801032a5:	a3 c0 a6 10 80       	mov    %eax,0x8010a6c0
    }
}
801032aa:	5d                   	pop    %ebp
801032ab:	f3 c3                	repz ret 

801032ad <dequeue>:

//Dequeue a process pointer
struct proc *dequeue() {
801032ad:	55                   	push   %ebp
801032ae:	89 e5                	mov    %esp,%ebp
801032b0:	53                   	push   %ebx
    //cprintf("dequeueing!!!!!!!!!!!!!!!!!!!\n\n");
    struct proc *toReturn = pq.processes[0];
801032b1:	a1 c0 a5 10 80       	mov    0x8010a5c0,%eax
    //cprintf("pq.processes[0]= :%d\n", toReturn);
    pq.processes[0] = 0;
801032b6:	c7 05 c0 a5 10 80 00 	movl   $0x0,0x8010a5c0
801032bd:	00 00 00 
801032c0:	ba c4 a5 10 80       	mov    $0x8010a5c4,%edx
801032c5:	bb c0 a6 10 80       	mov    $0x8010a6c0,%ebx
    int i;
    for (i = 0; i < NPROC; i++) {
        if (i == NPROC - 1)
            pq.processes[i] = 0;
        else
            pq.processes[i] = pq.processes[i + 1];
801032ca:	8b 0a                	mov    (%edx),%ecx
801032cc:	89 4a fc             	mov    %ecx,-0x4(%edx)
801032cf:	83 c2 04             	add    $0x4,%edx
    struct proc *toReturn = pq.processes[0];
    //cprintf("pq.processes[0]= :%d\n", toReturn);
    pq.processes[0] = 0;
    int i;
    for (i = 0; i < NPROC; i++) {
        if (i == NPROC - 1)
801032d2:	39 da                	cmp    %ebx,%edx
801032d4:	75 f4                	jne    801032ca <dequeue+0x1d>
            pq.processes[i] = 0;
801032d6:	c7 05 bc a6 10 80 00 	movl   $0x0,0x8010a6bc
801032dd:	00 00 00 
        else
            pq.processes[i] = pq.processes[i + 1];
    }
    pq.lastIndex--;
801032e0:	83 2d c0 a6 10 80 01 	subl   $0x1,0x8010a6c0
    return toReturn;
}
801032e7:	5b                   	pop    %ebx
801032e8:	5d                   	pop    %ebp
801032e9:	c3                   	ret    

801032ea <pinit>:


void
pinit(void) {
801032ea:	55                   	push   %ebp
801032eb:	89 e5                	mov    %esp,%ebp
801032ed:	83 ec 10             	sub    $0x10,%esp
    initlock(&ptable.lock, "ptable");
801032f0:	68 35 72 10 80       	push   $0x80107235
801032f5:	68 40 2e 11 80       	push   $0x80112e40
801032fa:	e8 89 0c 00 00       	call   80103f88 <initlock>
}
801032ff:	83 c4 10             	add    $0x10,%esp
80103302:	c9                   	leave  
80103303:	c3                   	ret    

80103304 <mycpu>:
}

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu *
mycpu(void) {
80103304:	55                   	push   %ebp
80103305:	89 e5                	mov    %esp,%ebp
80103307:	56                   	push   %esi
80103308:	53                   	push   %ebx

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103309:	9c                   	pushf  
8010330a:	58                   	pop    %eax
    int apicid, i;

    if (readeflags() & FL_IF)
8010330b:	f6 c4 02             	test   $0x2,%ah
8010330e:	74 0d                	je     8010331d <mycpu+0x19>
        panic("mycpu called with interrupts enabled\n");
80103310:	83 ec 0c             	sub    $0xc,%esp
80103313:	68 18 73 10 80       	push   $0x80107318
80103318:	e8 30 d0 ff ff       	call   8010034d <panic>

    apicid = lapicid();
8010331d:	e8 20 f1 ff ff       	call   80102442 <lapicid>
    // APIC IDs are not guaranteed to be contiguous. Maybe we should have
    // a reverse map, or reserve a register to store &cpus[i].
    for (i = 0; i < ncpu; ++i) {
80103322:	8b 35 20 2e 11 80    	mov    0x80112e20,%esi
80103328:	85 f6                	test   %esi,%esi
8010332a:	7e 34                	jle    80103360 <mycpu+0x5c>
        if (cpus[i].apicid == apicid)
8010332c:	0f b6 15 a0 28 11 80 	movzbl 0x801128a0,%edx
80103333:	39 d0                	cmp    %edx,%eax
80103335:	75 18                	jne    8010334f <mycpu+0x4b>
80103337:	eb 0f                	jmp    80103348 <mycpu+0x44>
80103339:	0f b6 19             	movzbl (%ecx),%ebx
8010333c:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103342:	39 d8                	cmp    %ebx,%eax
80103344:	75 13                	jne    80103359 <mycpu+0x55>
80103346:	eb 25                	jmp    8010336d <mycpu+0x69>
        panic("mycpu called with interrupts enabled\n");

    apicid = lapicid();
    // APIC IDs are not guaranteed to be contiguous. Maybe we should have
    // a reverse map, or reserve a register to store &cpus[i].
    for (i = 0; i < ncpu; ++i) {
80103348:	ba 00 00 00 00       	mov    $0x0,%edx
8010334d:	eb 1e                	jmp    8010336d <mycpu+0x69>
8010334f:	b9 50 29 11 80       	mov    $0x80112950,%ecx
        if (cpus[i].apicid == apicid)
80103354:	ba 00 00 00 00       	mov    $0x0,%edx
        panic("mycpu called with interrupts enabled\n");

    apicid = lapicid();
    // APIC IDs are not guaranteed to be contiguous. Maybe we should have
    // a reverse map, or reserve a register to store &cpus[i].
    for (i = 0; i < ncpu; ++i) {
80103359:	83 c2 01             	add    $0x1,%edx
8010335c:	39 f2                	cmp    %esi,%edx
8010335e:	75 d9                	jne    80103339 <mycpu+0x35>
        if (cpus[i].apicid == apicid)
            return &cpus[i];
    }
    panic("unknown apicid\n");
80103360:	83 ec 0c             	sub    $0xc,%esp
80103363:	68 3c 72 10 80       	push   $0x8010723c
80103368:	e8 e0 cf ff ff       	call   8010034d <panic>
    apicid = lapicid();
    // APIC IDs are not guaranteed to be contiguous. Maybe we should have
    // a reverse map, or reserve a register to store &cpus[i].
    for (i = 0; i < ncpu; ++i) {
        if (cpus[i].apicid == apicid)
            return &cpus[i];
8010336d:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
80103373:	05 a0 28 11 80       	add    $0x801128a0,%eax
    }
    panic("unknown apicid\n");
}
80103378:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010337b:	5b                   	pop    %ebx
8010337c:	5e                   	pop    %esi
8010337d:	5d                   	pop    %ebp
8010337e:	c3                   	ret    

8010337f <cpuid>:
    initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
8010337f:	55                   	push   %ebp
80103380:	89 e5                	mov    %esp,%ebp
80103382:	83 ec 08             	sub    $0x8,%esp
    return mycpu() - cpus;
80103385:	e8 7a ff ff ff       	call   80103304 <mycpu>
8010338a:	2d a0 28 11 80       	sub    $0x801128a0,%eax
8010338f:	c1 f8 04             	sar    $0x4,%eax
80103392:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103398:	c9                   	leave  
80103399:	c3                   	ret    

8010339a <myproc>:
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc *
myproc(void) {
8010339a:	55                   	push   %ebp
8010339b:	89 e5                	mov    %esp,%ebp
8010339d:	53                   	push   %ebx
8010339e:	83 ec 04             	sub    $0x4,%esp
    struct cpu *c;
    struct proc *p;
    pushcli();
801033a1:	e8 8b 0c 00 00       	call   80104031 <pushcli>
    c = mycpu();
801033a6:	e8 59 ff ff ff       	call   80103304 <mycpu>
    p = c->proc;
801033ab:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
801033b1:	e8 1d 0d 00 00       	call   801040d3 <popcli>
    return p;
}
801033b6:	89 d8                	mov    %ebx,%eax
801033b8:	83 c4 04             	add    $0x4,%esp
801033bb:	5b                   	pop    %ebx
801033bc:	5d                   	pop    %ebp
801033bd:	c3                   	ret    

801033be <userinit>:
}

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void) {
801033be:	55                   	push   %ebp
801033bf:	89 e5                	mov    %esp,%ebp
801033c1:	53                   	push   %ebx
801033c2:	83 ec 04             	sub    $0x4,%esp
    struct proc *p;
    extern char _binary_initcode_start[], _binary_initcode_size[];

    p = allocproc();
801033c5:	e8 b3 fd ff ff       	call   8010317d <allocproc>
801033ca:	89 c3                	mov    %eax,%ebx

    initproc = p;
801033cc:	a3 c4 a6 10 80       	mov    %eax,0x8010a6c4
    if ((p->pgdir = setupkvm()) == 0)
801033d1:	e8 97 36 00 00       	call   80106a6d <setupkvm>
801033d6:	89 43 04             	mov    %eax,0x4(%ebx)
801033d9:	85 c0                	test   %eax,%eax
801033db:	75 0d                	jne    801033ea <userinit+0x2c>
        panic("userinit: out of memory?");
801033dd:	83 ec 0c             	sub    $0xc,%esp
801033e0:	68 4c 72 10 80       	push   $0x8010724c
801033e5:	e8 63 cf ff ff       	call   8010034d <panic>
    inituvm(p->pgdir, _binary_initcode_start, (int) _binary_initcode_size);
801033ea:	83 ec 04             	sub    $0x4,%esp
801033ed:	68 2c 00 00 00       	push   $0x2c
801033f2:	68 60 a4 10 80       	push   $0x8010a460
801033f7:	50                   	push   %eax
801033f8:	e8 6f 33 00 00       	call   8010676c <inituvm>
    p->sz = PGSIZE;
801033fd:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
    memset(p->tf, 0, sizeof(*p->tf));
80103403:	83 c4 0c             	add    $0xc,%esp
80103406:	6a 4c                	push   $0x4c
80103408:	6a 00                	push   $0x0
8010340a:	ff 73 18             	pushl  0x18(%ebx)
8010340d:	e8 66 0d 00 00       	call   80104178 <memset>
    p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103412:	8b 43 18             	mov    0x18(%ebx),%eax
80103415:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
    p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010341b:	8b 43 18             	mov    0x18(%ebx),%eax
8010341e:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
    p->tf->es = p->tf->ds;
80103424:	8b 43 18             	mov    0x18(%ebx),%eax
80103427:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010342b:	66 89 50 28          	mov    %dx,0x28(%eax)
    p->tf->ss = p->tf->ds;
8010342f:	8b 43 18             	mov    0x18(%ebx),%eax
80103432:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103436:	66 89 50 48          	mov    %dx,0x48(%eax)
    p->tf->eflags = FL_IF;
8010343a:	8b 43 18             	mov    0x18(%ebx),%eax
8010343d:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
    p->tf->esp = PGSIZE;
80103444:	8b 43 18             	mov    0x18(%ebx),%eax
80103447:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
    p->tf->eip = 0;  // beginning of initcode.S
8010344e:	8b 43 18             	mov    0x18(%ebx),%eax
80103451:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

    safestrcpy(p->name, "initcode", sizeof(p->name));
80103458:	83 c4 0c             	add    $0xc,%esp
8010345b:	6a 10                	push   $0x10
8010345d:	68 65 72 10 80       	push   $0x80107265
80103462:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103465:	50                   	push   %eax
80103466:	e8 b4 0e 00 00       	call   8010431f <safestrcpy>
    p->cwd = namei("/");
8010346b:	c7 04 24 6e 72 10 80 	movl   $0x8010726e,(%esp)
80103472:	e8 1b e8 ff ff       	call   80101c92 <namei>
80103477:	89 43 68             	mov    %eax,0x68(%ebx)

    // this assignment to p->state lets other cores
    // run this process. the acquire forces the above
    // writes to be visible, and the lock is also needed
    // because the assignment might not be atomic.
    acquire(&ptable.lock);
8010347a:	c7 04 24 40 2e 11 80 	movl   $0x80112e40,(%esp)
80103481:	e8 e6 0b 00 00       	call   8010406c <acquire>
    p->ctime=ticks;
80103486:	a1 c0 5d 11 80       	mov    0x80115dc0,%eax
8010348b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
    p->iotime=0;
80103491:	c7 83 88 00 00 00 00 	movl   $0x0,0x88(%ebx)
80103498:	00 00 00 
    p->rtime=0;
8010349b:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
801034a2:	00 00 00 
    p->AI=QUANTUM;
801034a5:	c7 83 90 00 00 00 05 	movl   $0x5,0x90(%ebx)
801034ac:	00 00 00 
    p->trem=QUANTUM;
801034af:	c7 43 7c 05 00 00 00 	movl   $0x5,0x7c(%ebx)
    p->priority=2;
801034b6:	c7 83 94 00 00 00 02 	movl   $0x2,0x94(%ebx)
801034bd:	00 00 00 
    p->state = RUNNABLE;
801034c0:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)

#ifdef FCFS
    cprintf("ENQUEUEING INIT PROCESS\n\n");
    enqueue(p);
#endif
    release(&ptable.lock);
801034c7:	c7 04 24 40 2e 11 80 	movl   $0x80112e40,(%esp)
801034ce:	e8 5e 0c 00 00       	call   80104131 <release>
}
801034d3:	83 c4 10             	add    $0x10,%esp
801034d6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801034d9:	c9                   	leave  
801034da:	c3                   	ret    

801034db <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n) {
801034db:	55                   	push   %ebp
801034dc:	89 e5                	mov    %esp,%ebp
801034de:	56                   	push   %esi
801034df:	53                   	push   %ebx
801034e0:	8b 75 08             	mov    0x8(%ebp),%esi
    uint sz;
    struct proc *curproc = myproc();
801034e3:	e8 b2 fe ff ff       	call   8010339a <myproc>
801034e8:	89 c3                	mov    %eax,%ebx

    sz = curproc->sz;
801034ea:	8b 00                	mov    (%eax),%eax
    if (n > 0) {
801034ec:	85 f6                	test   %esi,%esi
801034ee:	7e 18                	jle    80103508 <growproc+0x2d>
        if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
801034f0:	83 ec 04             	sub    $0x4,%esp
801034f3:	01 c6                	add    %eax,%esi
801034f5:	56                   	push   %esi
801034f6:	50                   	push   %eax
801034f7:	ff 73 04             	pushl  0x4(%ebx)
801034fa:	e8 14 34 00 00       	call   80106913 <allocuvm>
801034ff:	83 c4 10             	add    $0x10,%esp
80103502:	85 c0                	test   %eax,%eax
80103504:	75 1c                	jne    80103522 <growproc+0x47>
80103506:	eb 2f                	jmp    80103537 <growproc+0x5c>
            return -1;
    } else if (n < 0) {
80103508:	85 f6                	test   %esi,%esi
8010350a:	79 16                	jns    80103522 <growproc+0x47>
        if ((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
8010350c:	83 ec 04             	sub    $0x4,%esp
8010350f:	01 c6                	add    %eax,%esi
80103511:	56                   	push   %esi
80103512:	50                   	push   %eax
80103513:	ff 73 04             	pushl  0x4(%ebx)
80103516:	e8 69 33 00 00       	call   80106884 <deallocuvm>
8010351b:	83 c4 10             	add    $0x10,%esp
8010351e:	85 c0                	test   %eax,%eax
80103520:	74 1c                	je     8010353e <growproc+0x63>
            return -1;
    }
    curproc->sz = sz;
80103522:	89 03                	mov    %eax,(%ebx)
    switchuvm(curproc);
80103524:	83 ec 0c             	sub    $0xc,%esp
80103527:	53                   	push   %ebx
80103528:	e8 4d 31 00 00       	call   8010667a <switchuvm>
    return 0;
8010352d:	83 c4 10             	add    $0x10,%esp
80103530:	b8 00 00 00 00       	mov    $0x0,%eax
80103535:	eb 0c                	jmp    80103543 <growproc+0x68>
    struct proc *curproc = myproc();

    sz = curproc->sz;
    if (n > 0) {
        if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
            return -1;
80103537:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010353c:	eb 05                	jmp    80103543 <growproc+0x68>
    } else if (n < 0) {
        if ((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
            return -1;
8010353e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    curproc->sz = sz;
    switchuvm(curproc);
    return 0;
}
80103543:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103546:	5b                   	pop    %ebx
80103547:	5e                   	pop    %esi
80103548:	5d                   	pop    %ebp
80103549:	c3                   	ret    

8010354a <fork>:

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void) {
8010354a:	55                   	push   %ebp
8010354b:	89 e5                	mov    %esp,%ebp
8010354d:	57                   	push   %edi
8010354e:	56                   	push   %esi
8010354f:	53                   	push   %ebx
80103550:	83 ec 1c             	sub    $0x1c,%esp
    int i, pid;
    struct proc *np;
    struct proc *curproc = myproc();
80103553:	e8 42 fe ff ff       	call   8010339a <myproc>
80103558:	89 c7                	mov    %eax,%edi
8010355a:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    // Allocate process.
    if ((np = allocproc()) == 0) {
8010355d:	e8 1b fc ff ff       	call   8010317d <allocproc>
80103562:	85 c0                	test   %eax,%eax
80103564:	0f 84 1f 01 00 00    	je     80103689 <fork+0x13f>
8010356a:	89 c3                	mov    %eax,%ebx
        return -1;
    }

    // Copy process state from proc.
    if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0) {
8010356c:	83 ec 08             	sub    $0x8,%esp
8010356f:	ff 37                	pushl  (%edi)
80103571:	ff 77 04             	pushl  0x4(%edi)
80103574:	e8 ac 35 00 00       	call   80106b25 <copyuvm>
80103579:	89 43 04             	mov    %eax,0x4(%ebx)
8010357c:	83 c4 10             	add    $0x10,%esp
8010357f:	85 c0                	test   %eax,%eax
80103581:	75 26                	jne    801035a9 <fork+0x5f>
        kfree(np->kstack);
80103583:	83 ec 0c             	sub    $0xc,%esp
80103586:	ff 73 08             	pushl  0x8(%ebx)
80103589:	e8 ae ea ff ff       	call   8010203c <kfree>
        np->kstack = 0;
8010358e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        np->state = UNUSED;
80103595:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        return -1;
8010359c:	83 c4 10             	add    $0x10,%esp
8010359f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801035a4:	e9 e5 00 00 00       	jmp    8010368e <fork+0x144>
    }
    np->sz = curproc->sz;
801035a9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801035ac:	8b 02                	mov    (%edx),%eax
801035ae:	89 03                	mov    %eax,(%ebx)
    np->parent = curproc;
801035b0:	89 53 14             	mov    %edx,0x14(%ebx)
    *np->tf = *curproc->tf;
801035b3:	8b 72 18             	mov    0x18(%edx),%esi
801035b6:	b9 13 00 00 00       	mov    $0x13,%ecx
801035bb:	8b 7b 18             	mov    0x18(%ebx),%edi
801035be:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

    // Clear %eax so that fork returns 0 in the child.
    np->tf->eax = 0;
801035c0:	8b 43 18             	mov    0x18(%ebx),%eax
801035c3:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

    for (i = 0; i < NOFILE; i++)
801035ca:	be 00 00 00 00       	mov    $0x0,%esi
        if (curproc->ofile[i])
801035cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801035d2:	8b 44 b0 28          	mov    0x28(%eax,%esi,4),%eax
801035d6:	85 c0                	test   %eax,%eax
801035d8:	74 10                	je     801035ea <fork+0xa0>
            np->ofile[i] = filedup(curproc->ofile[i]);
801035da:	83 ec 0c             	sub    $0xc,%esp
801035dd:	50                   	push   %eax
801035de:	e8 2e d7 ff ff       	call   80100d11 <filedup>
801035e3:	89 44 b3 28          	mov    %eax,0x28(%ebx,%esi,4)
801035e7:	83 c4 10             	add    $0x10,%esp
    *np->tf = *curproc->tf;

    // Clear %eax so that fork returns 0 in the child.
    np->tf->eax = 0;

    for (i = 0; i < NOFILE; i++)
801035ea:	83 c6 01             	add    $0x1,%esi
801035ed:	83 fe 10             	cmp    $0x10,%esi
801035f0:	75 dd                	jne    801035cf <fork+0x85>
        if (curproc->ofile[i])
            np->ofile[i] = filedup(curproc->ofile[i]);
    np->cwd = idup(curproc->cwd);
801035f2:	83 ec 0c             	sub    $0xc,%esp
801035f5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801035f8:	ff 77 68             	pushl  0x68(%edi)
801035fb:	e8 cf de ff ff       	call   801014cf <idup>
80103600:	89 43 68             	mov    %eax,0x68(%ebx)

    safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103603:	83 c4 0c             	add    $0xc,%esp
80103606:	6a 10                	push   $0x10
80103608:	89 f8                	mov    %edi,%eax
8010360a:	83 c0 6c             	add    $0x6c,%eax
8010360d:	50                   	push   %eax
8010360e:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103611:	50                   	push   %eax
80103612:	e8 08 0d 00 00       	call   8010431f <safestrcpy>

    pid = np->pid;
80103617:	8b 73 10             	mov    0x10(%ebx),%esi

    acquire(&ptable.lock);
8010361a:	c7 04 24 40 2e 11 80 	movl   $0x80112e40,(%esp)
80103621:	e8 46 0a 00 00       	call   8010406c <acquire>


    //update creation time (task2)
    np->ctime = ticks;
80103626:	a1 c0 5d 11 80       	mov    0x80115dc0,%eax
8010362b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
    np->rtime = 0;
80103631:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80103638:	00 00 00 
    np->iotime = 0;
8010363b:	c7 83 88 00 00 00 00 	movl   $0x0,0x88(%ebx)
80103642:	00 00 00 
    np->AI = QUANTUM;
80103645:	c7 83 90 00 00 00 05 	movl   $0x5,0x90(%ebx)
8010364c:	00 00 00 
    np->trem=QUANTUM;     //limit ticks remaining to QUANTUM
8010364f:	c7 43 7c 05 00 00 00 	movl   $0x5,0x7c(%ebx)

    //task 3.4 requirement
    np->priority=np->parent->priority;
80103656:	8b 43 14             	mov    0x14(%ebx),%eax
80103659:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
8010365f:	89 93 94 00 00 00    	mov    %edx,0x94(%ebx)
    //task 3.3 requirement for fork? TODO: ask in forum
    np->parent->AI=QUANTUM;
80103665:	c7 80 90 00 00 00 05 	movl   $0x5,0x90(%eax)
8010366c:	00 00 00 

    np->state = RUNNABLE;
8010366f:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
#ifdef FCFS
    enqueue(np);
#endif

    release(&ptable.lock);
80103676:	c7 04 24 40 2e 11 80 	movl   $0x80112e40,(%esp)
8010367d:	e8 af 0a 00 00       	call   80104131 <release>

    return pid;
80103682:	83 c4 10             	add    $0x10,%esp
80103685:	89 f0                	mov    %esi,%eax
80103687:	eb 05                	jmp    8010368e <fork+0x144>
    struct proc *np;
    struct proc *curproc = myproc();

    // Allocate process.
    if ((np = allocproc()) == 0) {
        return -1;
80103689:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
#endif

    release(&ptable.lock);

    return pid;
}
8010368e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103691:	5b                   	pop    %ebx
80103692:	5e                   	pop    %esi
80103693:	5f                   	pop    %edi
80103694:	5d                   	pop    %ebp
80103695:	c3                   	ret    

80103696 <set_priority>:

}

//added task3.4
int
set_priority(int priority) {
80103696:	55                   	push   %ebp
80103697:	89 e5                	mov    %esp,%ebp
80103699:	53                   	push   %ebx
8010369a:	83 ec 04             	sub    $0x4,%esp
8010369d:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (priority > 3 || priority < 1)   //bad priority
801036a0:	8d 43 ff             	lea    -0x1(%ebx),%eax
801036a3:	83 f8 02             	cmp    $0x2,%eax
801036a6:	77 12                	ja     801036ba <set_priority+0x24>
        return -1;
    else {
        //struct cpu *c = mycpu();  //current proc
        //c->proc->priority =priority;
        struct proc *curproc = myproc();
801036a8:	e8 ed fc ff ff       	call   8010339a <myproc>
        curproc->priority = priority;
801036ad:	89 98 94 00 00 00    	mov    %ebx,0x94(%eax)
    }
    return 0;
801036b3:	b8 00 00 00 00       	mov    $0x0,%eax
801036b8:	eb 05                	jmp    801036bf <set_priority+0x29>

//added task3.4
int
set_priority(int priority) {
    if (priority > 3 || priority < 1)   //bad priority
        return -1;
801036ba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
        //c->proc->priority =priority;
        struct proc *curproc = myproc();
        curproc->priority = priority;
    }
    return 0;
}
801036bf:	83 c4 04             	add    $0x4,%esp
801036c2:	5b                   	pop    %ebx
801036c3:	5d                   	pop    %ebp
801036c4:	c3                   	ret    

801036c5 <scheduler>:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void) {
801036c5:	55                   	push   %ebp
801036c6:	89 e5                	mov    %esp,%ebp
801036c8:	57                   	push   %edi
801036c9:	56                   	push   %esi
801036ca:	53                   	push   %ebx
801036cb:	83 ec 0c             	sub    $0xc,%esp
    struct proc *p;
    struct cpu *c = mycpu();
801036ce:	e8 31 fc ff ff       	call   80103304 <mycpu>
801036d3:	89 c6                	mov    %eax,%esi
    c->proc = 0;
801036d5:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801036dc:	00 00 00 
          // before jumping back to us.
          c->proc = p;
          switchuvm(p);
          p->state = RUNNING;

          swtch(&(c->scheduler), p->context);
801036df:	8d 78 04             	lea    0x4(%eax),%edi
}

static inline void
sti(void)
{
  asm volatile("sti");
801036e2:	fb                   	sti    
    for (;;) {
        // Enable interrupts on this processor.
        sti();

        // Loop over process table looking for process to run.
        acquire(&ptable.lock);
801036e3:	83 ec 0c             	sub    $0xc,%esp
801036e6:	68 40 2e 11 80       	push   $0x80112e40
801036eb:	e8 7c 09 00 00       	call   8010406c <acquire>
801036f0:	83 c4 10             	add    $0x10,%esp

#ifdef DEFAULT
        //cprintf("IN DEFAULT");
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801036f3:	bb 74 2e 11 80       	mov    $0x80112e74,%ebx
          if(p->state != RUNNABLE)
801036f8:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
801036fc:	75 34                	jne    80103732 <scheduler+0x6d>
            continue;

          // Switch to chosen process.  It is the process's job
          // to release ptable.lock and then reacquire it
          // before jumping back to us.
          c->proc = p;
801036fe:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
          switchuvm(p);
80103704:	83 ec 0c             	sub    $0xc,%esp
80103707:	53                   	push   %ebx
80103708:	e8 6d 2f 00 00       	call   8010667a <switchuvm>
          p->state = RUNNING;
8010370d:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)

          swtch(&(c->scheduler), p->context);
80103714:	83 c4 08             	add    $0x8,%esp
80103717:	ff 73 1c             	pushl  0x1c(%ebx)
8010371a:	57                   	push   %edi
8010371b:	e8 55 0c 00 00       	call   80104375 <swtch>
          switchkvm();
80103720:	e8 43 2f 00 00       	call   80106668 <switchkvm>

          // Process is done running for now.
          // It should have changed its p->state before coming back.
          c->proc = 0;
80103725:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
8010372c:	00 00 00 
8010372f:	83 c4 10             	add    $0x10,%esp
        // Loop over process table looking for process to run.
        acquire(&ptable.lock);

#ifdef DEFAULT
        //cprintf("IN DEFAULT");
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103732:	81 c3 98 00 00 00    	add    $0x98,%ebx
80103738:	81 fb 74 54 11 80    	cmp    $0x80115474,%ebx
8010373e:	75 b8                	jne    801036f8 <scheduler+0x33>

#endif
#endif
#endif
#endif
        release(&ptable.lock);
80103740:	83 ec 0c             	sub    $0xc,%esp
80103743:	68 40 2e 11 80       	push   $0x80112e40
80103748:	e8 e4 09 00 00       	call   80104131 <release>

    }
8010374d:	83 c4 10             	add    $0x10,%esp
80103750:	eb 90                	jmp    801036e2 <scheduler+0x1d>

80103752 <getRunTimeRatio>:
// kernel thread, not this CPU. It should
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
int
getRunTimeRatio(struct proc *p) {
80103752:	55                   	push   %ebp
80103753:	89 e5                	mov    %esp,%ebp
80103755:	53                   	push   %ebx
80103756:	8b 5d 08             	mov    0x8(%ebp),%ebx
    else if (p->priority == 2)     //normal priority
        decay_factor = 1;
    else                        //low priority
        decay_factor = 1.25;
    toReturn = (p->rtime * decay_factor) / (p->rtime + wtime);
    return toReturn;
80103759:	83 bb 94 00 00 00 01 	cmpl   $0x1,0x94(%ebx)
80103760:	0f 95 c0             	setne  %al
80103763:	0f b6 c0             	movzbl %al,%eax
80103766:	0f af 83 8c 00 00 00 	imul   0x8c(%ebx),%eax
8010376d:	8b 0d c0 5d 11 80    	mov    0x80115dc0,%ecx
80103773:	2b 8b 80 00 00 00    	sub    0x80(%ebx),%ecx
80103779:	2b 8b 88 00 00 00    	sub    0x88(%ebx),%ecx
8010377f:	99                   	cltd   
80103780:	f7 f9                	idiv   %ecx
}
80103782:	5b                   	pop    %ebx
80103783:	5d                   	pop    %ebp
80103784:	c3                   	ret    

80103785 <sched>:

void
sched(void) {
80103785:	55                   	push   %ebp
80103786:	89 e5                	mov    %esp,%ebp
80103788:	56                   	push   %esi
80103789:	53                   	push   %ebx
    int intena;
    struct proc *p = myproc();
8010378a:	e8 0b fc ff ff       	call   8010339a <myproc>
8010378f:	89 c3                	mov    %eax,%ebx

    if (!holding(&ptable.lock))
80103791:	83 ec 0c             	sub    $0xc,%esp
80103794:	68 40 2e 11 80       	push   $0x80112e40
80103799:	e8 69 08 00 00       	call   80104007 <holding>
8010379e:	83 c4 10             	add    $0x10,%esp
801037a1:	85 c0                	test   %eax,%eax
801037a3:	75 0d                	jne    801037b2 <sched+0x2d>
        panic("sched ptable.lock");
801037a5:	83 ec 0c             	sub    $0xc,%esp
801037a8:	68 70 72 10 80       	push   $0x80107270
801037ad:	e8 9b cb ff ff       	call   8010034d <panic>
    if (mycpu()->ncli != 1)
801037b2:	e8 4d fb ff ff       	call   80103304 <mycpu>
801037b7:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
801037be:	74 0d                	je     801037cd <sched+0x48>
        panic("sched locks");
801037c0:	83 ec 0c             	sub    $0xc,%esp
801037c3:	68 82 72 10 80       	push   $0x80107282
801037c8:	e8 80 cb ff ff       	call   8010034d <panic>
    if (p->state == RUNNING)
801037cd:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
801037d1:	75 0d                	jne    801037e0 <sched+0x5b>
        panic("sched running");
801037d3:	83 ec 0c             	sub    $0xc,%esp
801037d6:	68 8e 72 10 80       	push   $0x8010728e
801037db:	e8 6d cb ff ff       	call   8010034d <panic>

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801037e0:	9c                   	pushf  
801037e1:	58                   	pop    %eax
    if (readeflags() & FL_IF)
801037e2:	f6 c4 02             	test   $0x2,%ah
801037e5:	74 0d                	je     801037f4 <sched+0x6f>
        panic("sched interruptible");
801037e7:	83 ec 0c             	sub    $0xc,%esp
801037ea:	68 9c 72 10 80       	push   $0x8010729c
801037ef:	e8 59 cb ff ff       	call   8010034d <panic>
    intena = mycpu()->intena;
801037f4:	e8 0b fb ff ff       	call   80103304 <mycpu>
801037f9:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
    swtch(&p->context, mycpu()->scheduler);
801037ff:	e8 00 fb ff ff       	call   80103304 <mycpu>
80103804:	83 ec 08             	sub    $0x8,%esp
80103807:	ff 70 04             	pushl  0x4(%eax)
8010380a:	83 c3 1c             	add    $0x1c,%ebx
8010380d:	53                   	push   %ebx
8010380e:	e8 62 0b 00 00       	call   80104375 <swtch>
    mycpu()->intena = intena;
80103813:	e8 ec fa ff ff       	call   80103304 <mycpu>
80103818:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
8010381e:	83 c4 10             	add    $0x10,%esp
80103821:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103824:	5b                   	pop    %ebx
80103825:	5e                   	pop    %esi
80103826:	5d                   	pop    %ebp
80103827:	c3                   	ret    

80103828 <exit>:

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void) {
80103828:	55                   	push   %ebp
80103829:	89 e5                	mov    %esp,%ebp
8010382b:	57                   	push   %edi
8010382c:	56                   	push   %esi
8010382d:	53                   	push   %ebx
8010382e:	83 ec 0c             	sub    $0xc,%esp
    struct proc *curproc = myproc();
80103831:	e8 64 fb ff ff       	call   8010339a <myproc>
80103836:	89 c6                	mov    %eax,%esi
80103838:	8d 58 28             	lea    0x28(%eax),%ebx
8010383b:	8d 78 68             	lea    0x68(%eax),%edi
    struct proc *p;
    int fd;

    if (curproc == initproc)
8010383e:	3b 05 c4 a6 10 80    	cmp    0x8010a6c4,%eax
80103844:	75 0d                	jne    80103853 <exit+0x2b>
        panic("init exiting");
80103846:	83 ec 0c             	sub    $0xc,%esp
80103849:	68 b0 72 10 80       	push   $0x801072b0
8010384e:	e8 fa ca ff ff       	call   8010034d <panic>

    // Close all open files.
    for (fd = 0; fd < NOFILE; fd++) {
        if (curproc->ofile[fd]) {
80103853:	8b 03                	mov    (%ebx),%eax
80103855:	85 c0                	test   %eax,%eax
80103857:	74 12                	je     8010386b <exit+0x43>
            fileclose(curproc->ofile[fd]);
80103859:	83 ec 0c             	sub    $0xc,%esp
8010385c:	50                   	push   %eax
8010385d:	e8 f4 d4 ff ff       	call   80100d56 <fileclose>
            curproc->ofile[fd] = 0;
80103862:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103868:	83 c4 10             	add    $0x10,%esp
8010386b:	83 c3 04             	add    $0x4,%ebx

    if (curproc == initproc)
        panic("init exiting");

    // Close all open files.
    for (fd = 0; fd < NOFILE; fd++) {
8010386e:	39 df                	cmp    %ebx,%edi
80103870:	75 e1                	jne    80103853 <exit+0x2b>
            fileclose(curproc->ofile[fd]);
            curproc->ofile[fd] = 0;
        }
    }

    begin_op();
80103872:	e8 39 ef ff ff       	call   801027b0 <begin_op>
    iput(curproc->cwd);
80103877:	83 ec 0c             	sub    $0xc,%esp
8010387a:	ff 76 68             	pushl  0x68(%esi)
8010387d:	e8 7f dd ff ff       	call   80101601 <iput>
    end_op();
80103882:	e8 a3 ef ff ff       	call   8010282a <end_op>
    curproc->cwd = 0;
80103887:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)

    acquire(&ptable.lock);
8010388e:	c7 04 24 40 2e 11 80 	movl   $0x80112e40,(%esp)
80103895:	e8 d2 07 00 00       	call   8010406c <acquire>

    // Parent might be sleeping in wait().
    wakeup1(curproc->parent);
8010389a:	8b 46 14             	mov    0x14(%esi),%eax
8010389d:	e8 b1 f8 ff ff       	call   80103153 <wakeup1>
801038a2:	83 c4 10             	add    $0x10,%esp

    // Pass abandoned children to init.
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801038a5:	bb 74 2e 11 80       	mov    $0x80112e74,%ebx
        if (p->parent == curproc) {
801038aa:	3b 73 14             	cmp    0x14(%ebx),%esi
801038ad:	75 13                	jne    801038c2 <exit+0x9a>
            p->parent = initproc;
801038af:	a1 c4 a6 10 80       	mov    0x8010a6c4,%eax
801038b4:	89 43 14             	mov    %eax,0x14(%ebx)
            if (p->state == ZOMBIE)
801038b7:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801038bb:	75 05                	jne    801038c2 <exit+0x9a>
                wakeup1(initproc);
801038bd:	e8 91 f8 ff ff       	call   80103153 <wakeup1>

    // Parent might be sleeping in wait().
    wakeup1(curproc->parent);

    // Pass abandoned children to init.
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801038c2:	81 c3 98 00 00 00    	add    $0x98,%ebx
801038c8:	81 fb 74 54 11 80    	cmp    $0x80115474,%ebx
801038ce:	75 da                	jne    801038aa <exit+0x82>
                wakeup1(initproc);
        }
    }

    // Jump into the scheduler, never to return.
    curproc->state = ZOMBIE;
801038d0:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
    //added task2
    curproc->etime = ticks;
801038d7:	a1 c0 5d 11 80       	mov    0x80115dc0,%eax
801038dc:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)
    sched();
801038e2:	e8 9e fe ff ff       	call   80103785 <sched>
    panic("zombie exit");
801038e7:	83 ec 0c             	sub    $0xc,%esp
801038ea:	68 bd 72 10 80       	push   $0x801072bd
801038ef:	e8 59 ca ff ff       	call   8010034d <panic>

801038f4 <yield>:
    mycpu()->intena = intena;
}

// Give up the CPU for one scheduling round.
void
yield(void) {
801038f4:	55                   	push   %ebp
801038f5:	89 e5                	mov    %esp,%ebp
801038f7:	83 ec 24             	sub    $0x24,%esp
    acquire(&ptable.lock);  //DOC: yieldlock
801038fa:	68 40 2e 11 80       	push   $0x80112e40
801038ff:	e8 68 07 00 00       	call   8010406c <acquire>
    struct proc *p = myproc();
80103904:	e8 91 fa ff ff       	call   8010339a <myproc>
    p->state = RUNNABLE;
80103909:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    if (p->rtime >= p->AI)
80103910:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
80103916:	83 c4 10             	add    $0x10,%esp
80103919:	39 90 8c 00 00 00    	cmp    %edx,0x8c(%eax)
8010391f:	7c 29                	jl     8010394a <yield+0x56>
        p->AI = p->AI + ALPHA * (p->AI);
80103921:	89 55 f0             	mov    %edx,-0x10(%ebp)
80103924:	db 45 f0             	fildl  -0x10(%ebp)
80103927:	d9 c0                	fld    %st(0)
80103929:	d8 0d 58 73 10 80    	fmuls  0x80107358
8010392f:	de c1                	faddp  %st,%st(1)
80103931:	d9 7d f6             	fnstcw -0xa(%ebp)
80103934:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
80103938:	b6 0c                	mov    $0xc,%dh
8010393a:	66 89 55 f4          	mov    %dx,-0xc(%ebp)
8010393e:	d9 6d f4             	fldcw  -0xc(%ebp)
80103941:	db 98 90 00 00 00    	fistpl 0x90(%eax)
80103947:	d9 6d f6             	fldcw  -0xa(%ebp)
    p->trem=QUANTUM;            //reset the ticks remaining
8010394a:	c7 40 7c 05 00 00 00 	movl   $0x5,0x7c(%eax)

#ifdef FCFS
    enqueue(myproc());
#endif

    sched();
80103951:	e8 2f fe ff ff       	call   80103785 <sched>
    release(&ptable.lock);
80103956:	83 ec 0c             	sub    $0xc,%esp
80103959:	68 40 2e 11 80       	push   $0x80112e40
8010395e:	e8 ce 07 00 00       	call   80104131 <release>
}
80103963:	83 c4 10             	add    $0x10,%esp
80103966:	c9                   	leave  
80103967:	c3                   	ret    

80103968 <sleep>:
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk) {
80103968:	55                   	push   %ebp
80103969:	89 e5                	mov    %esp,%ebp
8010396b:	56                   	push   %esi
8010396c:	53                   	push   %ebx
8010396d:	83 ec 10             	sub    $0x10,%esp
80103970:	8b 75 0c             	mov    0xc(%ebp),%esi
    struct proc *p = myproc();
80103973:	e8 22 fa ff ff       	call   8010339a <myproc>

    if (p == 0)
80103978:	85 c0                	test   %eax,%eax
8010397a:	75 0d                	jne    80103989 <sleep+0x21>
        panic("sleep");
8010397c:	83 ec 0c             	sub    $0xc,%esp
8010397f:	68 c9 72 10 80       	push   $0x801072c9
80103984:	e8 c4 c9 ff ff       	call   8010034d <panic>
80103989:	89 c3                	mov    %eax,%ebx

    if (lk == 0)
8010398b:	85 f6                	test   %esi,%esi
8010398d:	75 0d                	jne    8010399c <sleep+0x34>
        panic("sleep without lk");
8010398f:	83 ec 0c             	sub    $0xc,%esp
80103992:	68 cf 72 10 80       	push   $0x801072cf
80103997:	e8 b1 c9 ff ff       	call   8010034d <panic>
    // change p->state and then call sched.
    // Once we hold ptable.lock, we can be
    // guaranteed that we won't miss any wakeup
    // (wakeup runs with ptable.lock locked),
    // so it's okay to release lk.
    if (lk != &ptable.lock) {  //DOC: sleeplock0
8010399c:	81 fe 40 2e 11 80    	cmp    $0x80112e40,%esi
801039a2:	74 7f                	je     80103a23 <sleep+0xbb>
        acquire(&ptable.lock);  //DOC: sleeplock1
801039a4:	83 ec 0c             	sub    $0xc,%esp
801039a7:	68 40 2e 11 80       	push   $0x80112e40
801039ac:	e8 bb 06 00 00       	call   8010406c <acquire>
        release(lk);
801039b1:	89 34 24             	mov    %esi,(%esp)
801039b4:	e8 78 07 00 00       	call   80104131 <release>
    }
    // Go to sleep.
    p->chan = chan;
801039b9:	8b 45 08             	mov    0x8(%ebp),%eax
801039bc:	89 43 20             	mov    %eax,0x20(%ebx)
    p->state = SLEEPING;
801039bf:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
    if (p->rtime >= p->AI)
801039c6:	8b 83 90 00 00 00    	mov    0x90(%ebx),%eax
801039cc:	83 c4 10             	add    $0x10,%esp
801039cf:	39 83 8c 00 00 00    	cmp    %eax,0x8c(%ebx)
801039d5:	7d 69                	jge    80103a40 <sleep+0xd8>
801039d7:	eb 1d                	jmp    801039f6 <sleep+0x8e>
    // Tidy up.
    p->chan = 0;

    // Reacquire original lock.
    if (lk != &ptable.lock) {  //DOC: sleeplock2
        release(&ptable.lock);
801039d9:	83 ec 0c             	sub    $0xc,%esp
801039dc:	68 40 2e 11 80       	push   $0x80112e40
801039e1:	e8 4b 07 00 00       	call   80104131 <release>
        acquire(lk);
801039e6:	89 34 24             	mov    %esi,(%esp)
801039e9:	e8 7e 06 00 00       	call   8010406c <acquire>
801039ee:	83 c4 10             	add    $0x10,%esp
    }
}
801039f1:	e9 c7 00 00 00       	jmp    80103abd <sleep+0x155>
    // Go to sleep.
    p->chan = chan;
    p->state = SLEEPING;
    if (p->rtime >= p->AI)
        p->AI = p->AI + ALPHA * (p->AI);
    p->trem=QUANTUM;            //reset the ticks remaining
801039f6:	c7 43 7c 05 00 00 00 	movl   $0x5,0x7c(%ebx)
    sched();
801039fd:	e8 83 fd ff ff       	call   80103785 <sched>

    // Tidy up.
    p->chan = 0;
80103a02:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
80103a09:	eb ce                	jmp    801039d9 <sleep+0x71>
    // Go to sleep.
    p->chan = chan;
    p->state = SLEEPING;
    if (p->rtime >= p->AI)
        p->AI = p->AI + ALPHA * (p->AI);
    p->trem=QUANTUM;            //reset the ticks remaining
80103a0b:	c7 43 7c 05 00 00 00 	movl   $0x5,0x7c(%ebx)
    sched();
80103a12:	e8 6e fd ff ff       	call   80103785 <sched>

    // Tidy up.
    p->chan = 0;
80103a17:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
80103a1e:	e9 9a 00 00 00       	jmp    80103abd <sleep+0x155>
    if (lk != &ptable.lock) {  //DOC: sleeplock0
        acquire(&ptable.lock);  //DOC: sleeplock1
        release(lk);
    }
    // Go to sleep.
    p->chan = chan;
80103a23:	8b 45 08             	mov    0x8(%ebp),%eax
80103a26:	89 43 20             	mov    %eax,0x20(%ebx)
    p->state = SLEEPING;
80103a29:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
    if (p->rtime >= p->AI)
80103a30:	8b 83 90 00 00 00    	mov    0x90(%ebx),%eax
80103a36:	39 83 8c 00 00 00    	cmp    %eax,0x8c(%ebx)
80103a3c:	7c cd                	jl     80103a0b <sleep+0xa3>
80103a3e:	eb 41                	jmp    80103a81 <sleep+0x119>
        p->AI = p->AI + ALPHA * (p->AI);
80103a40:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103a43:	db 45 f0             	fildl  -0x10(%ebp)
80103a46:	d9 c0                	fld    %st(0)
80103a48:	d8 0d 58 73 10 80    	fmuls  0x80107358
80103a4e:	de c1                	faddp  %st,%st(1)
80103a50:	d9 7d f6             	fnstcw -0xa(%ebp)
80103a53:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
80103a57:	b4 0c                	mov    $0xc,%ah
80103a59:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
80103a5d:	d9 6d f4             	fldcw  -0xc(%ebp)
80103a60:	db 9b 90 00 00 00    	fistpl 0x90(%ebx)
80103a66:	d9 6d f6             	fldcw  -0xa(%ebp)
    p->trem=QUANTUM;            //reset the ticks remaining
80103a69:	c7 43 7c 05 00 00 00 	movl   $0x5,0x7c(%ebx)
    sched();
80103a70:	e8 10 fd ff ff       	call   80103785 <sched>

    // Tidy up.
    p->chan = 0;
80103a75:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
80103a7c:	e9 58 ff ff ff       	jmp    801039d9 <sleep+0x71>
    }
    // Go to sleep.
    p->chan = chan;
    p->state = SLEEPING;
    if (p->rtime >= p->AI)
        p->AI = p->AI + ALPHA * (p->AI);
80103a81:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103a84:	db 45 f0             	fildl  -0x10(%ebp)
80103a87:	d9 c0                	fld    %st(0)
80103a89:	d8 0d 58 73 10 80    	fmuls  0x80107358
80103a8f:	de c1                	faddp  %st,%st(1)
80103a91:	d9 7d f6             	fnstcw -0xa(%ebp)
80103a94:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
80103a98:	b4 0c                	mov    $0xc,%ah
80103a9a:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
80103a9e:	d9 6d f4             	fldcw  -0xc(%ebp)
80103aa1:	db 9b 90 00 00 00    	fistpl 0x90(%ebx)
80103aa7:	d9 6d f6             	fldcw  -0xa(%ebp)
    p->trem=QUANTUM;            //reset the ticks remaining
80103aaa:	c7 43 7c 05 00 00 00 	movl   $0x5,0x7c(%ebx)
    sched();
80103ab1:	e8 cf fc ff ff       	call   80103785 <sched>

    // Tidy up.
    p->chan = 0;
80103ab6:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    // Reacquire original lock.
    if (lk != &ptable.lock) {  //DOC: sleeplock2
        release(&ptable.lock);
        acquire(lk);
    }
}
80103abd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ac0:	5b                   	pop    %ebx
80103ac1:	5e                   	pop    %esi
80103ac2:	5d                   	pop    %ebp
80103ac3:	c3                   	ret    

80103ac4 <wait>:
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void) {
80103ac4:	55                   	push   %ebp
80103ac5:	89 e5                	mov    %esp,%ebp
80103ac7:	56                   	push   %esi
80103ac8:	53                   	push   %ebx
    struct proc *p;
    int havekids, pid;
    struct proc *curproc = myproc();
80103ac9:	e8 cc f8 ff ff       	call   8010339a <myproc>
80103ace:	89 c6                	mov    %eax,%esi

    acquire(&ptable.lock);
80103ad0:	83 ec 0c             	sub    $0xc,%esp
80103ad3:	68 40 2e 11 80       	push   $0x80112e40
80103ad8:	e8 8f 05 00 00       	call   8010406c <acquire>
80103add:	83 c4 10             	add    $0x10,%esp
    for (;;) {
        // Scan through table looking for exited children.
        havekids = 0;
80103ae0:	b8 00 00 00 00       	mov    $0x0,%eax
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103ae5:	bb 74 2e 11 80       	mov    $0x80112e74,%ebx
            if (p->parent != curproc)
80103aea:	3b 73 14             	cmp    0x14(%ebx),%esi
80103aed:	75 5e                	jne    80103b4d <wait+0x89>
                continue;
            havekids = 1;
            if (p->state == ZOMBIE) {
80103aef:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103af3:	75 53                	jne    80103b48 <wait+0x84>
                // Found one.
                pid = p->pid;
80103af5:	8b 73 10             	mov    0x10(%ebx),%esi
                kfree(p->kstack);
80103af8:	83 ec 0c             	sub    $0xc,%esp
80103afb:	ff 73 08             	pushl  0x8(%ebx)
80103afe:	e8 39 e5 ff ff       	call   8010203c <kfree>
                p->kstack = 0;
80103b03:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
                freevm(p->pgdir);
80103b0a:	83 c4 04             	add    $0x4,%esp
80103b0d:	ff 73 04             	pushl  0x4(%ebx)
80103b10:	e8 e9 2e 00 00       	call   801069fe <freevm>
                p->pid = 0;
80103b15:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
                p->parent = 0;
80103b1c:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
                p->name[0] = 0;
80103b23:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
                p->killed = 0;
80103b27:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
                p->state = UNUSED;
80103b2e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
                release(&ptable.lock);
80103b35:	c7 04 24 40 2e 11 80 	movl   $0x80112e40,(%esp)
80103b3c:	e8 f0 05 00 00       	call   80104131 <release>
                return pid;
80103b41:	83 c4 10             	add    $0x10,%esp
80103b44:	89 f0                	mov    %esi,%eax
80103b46:	eb 4a                	jmp    80103b92 <wait+0xce>
        // Scan through table looking for exited children.
        havekids = 0;
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
            if (p->parent != curproc)
                continue;
            havekids = 1;
80103b48:	b8 01 00 00 00       	mov    $0x1,%eax

    acquire(&ptable.lock);
    for (;;) {
        // Scan through table looking for exited children.
        havekids = 0;
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103b4d:	81 c3 98 00 00 00    	add    $0x98,%ebx
80103b53:	81 fb 74 54 11 80    	cmp    $0x80115474,%ebx
80103b59:	75 8f                	jne    80103aea <wait+0x26>
                return pid;
            }
        }

        // No point waiting if we don't have any children.
        if (!havekids || curproc->killed) {
80103b5b:	85 c0                	test   %eax,%eax
80103b5d:	74 06                	je     80103b65 <wait+0xa1>
80103b5f:	83 7e 24 00          	cmpl   $0x0,0x24(%esi)
80103b63:	74 17                	je     80103b7c <wait+0xb8>
            release(&ptable.lock);
80103b65:	83 ec 0c             	sub    $0xc,%esp
80103b68:	68 40 2e 11 80       	push   $0x80112e40
80103b6d:	e8 bf 05 00 00       	call   80104131 <release>
            return -1;
80103b72:	83 c4 10             	add    $0x10,%esp
80103b75:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103b7a:	eb 16                	jmp    80103b92 <wait+0xce>
        }

        // Wait for children to exit.  (See wakeup1 call in proc_exit.)
        sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103b7c:	83 ec 08             	sub    $0x8,%esp
80103b7f:	68 40 2e 11 80       	push   $0x80112e40
80103b84:	56                   	push   %esi
80103b85:	e8 de fd ff ff       	call   80103968 <sleep>
    }
80103b8a:	83 c4 10             	add    $0x10,%esp
80103b8d:	e9 4e ff ff ff       	jmp    80103ae0 <wait+0x1c>
}
80103b92:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b95:	5b                   	pop    %ebx
80103b96:	5e                   	pop    %esi
80103b97:	5d                   	pop    %ebp
80103b98:	c3                   	ret    

80103b99 <wait2>:

//added task2
int
wait2(int pid, int *wtime, int *rtime, int *iotime) {
80103b99:	55                   	push   %ebp
80103b9a:	89 e5                	mov    %esp,%ebp
80103b9c:	57                   	push   %edi
80103b9d:	56                   	push   %esi
80103b9e:	53                   	push   %ebx
80103b9f:	83 ec 0c             	sub    $0xc,%esp
    struct proc *p;
    int havekids;//, pid;
    struct proc *curproc = myproc();
80103ba2:	e8 f3 f7 ff ff       	call   8010339a <myproc>
80103ba7:	89 c6                	mov    %eax,%esi

    acquire(&ptable.lock);
80103ba9:	83 ec 0c             	sub    $0xc,%esp
80103bac:	68 40 2e 11 80       	push   $0x80112e40
80103bb1:	e8 b6 04 00 00       	call   8010406c <acquire>
80103bb6:	83 c4 10             	add    $0x10,%esp
    for (;;) {
        // Scan through table looking for exited children.
        havekids = 0;
80103bb9:	b8 00 00 00 00       	mov    $0x0,%eax
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103bbe:	bb 74 2e 11 80       	mov    $0x80112e74,%ebx
            if (p->parent != curproc)
80103bc3:	3b 73 14             	cmp    0x14(%ebx),%esi
80103bc6:	0f 85 a1 00 00 00    	jne    80103c6d <wait2+0xd4>
                continue;
            havekids = 1;
            if (p->pid == pid && p->state == ZOMBIE) {
80103bcc:	8b 7b 10             	mov    0x10(%ebx),%edi
        // Scan through table looking for exited children.
        havekids = 0;
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
            if (p->parent != curproc)
                continue;
            havekids = 1;
80103bcf:	b8 01 00 00 00       	mov    $0x1,%eax
            if (p->pid == pid && p->state == ZOMBIE) {
80103bd4:	3b 7d 08             	cmp    0x8(%ebp),%edi
80103bd7:	0f 85 90 00 00 00    	jne    80103c6d <wait2+0xd4>
80103bdd:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103be1:	0f 85 81 00 00 00    	jne    80103c68 <wait2+0xcf>
                // Found one.
                //pid = p->pid;
                kfree(p->kstack);
80103be7:	83 ec 0c             	sub    $0xc,%esp
80103bea:	ff 73 08             	pushl  0x8(%ebx)
80103bed:	e8 4a e4 ff ff       	call   8010203c <kfree>
                p->kstack = 0;
80103bf2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
                freevm(p->pgdir);
80103bf9:	83 c4 04             	add    $0x4,%esp
80103bfc:	ff 73 04             	pushl  0x4(%ebx)
80103bff:	e8 fa 2d 00 00       	call   801069fe <freevm>
                p->pid = 0;
80103c04:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
                p->parent = 0;
80103c0b:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
                p->name[0] = 0;
80103c12:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
                p->killed = 0;
80103c16:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
                p->state = UNUSED;
80103c1d:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
                release(&ptable.lock);
80103c24:	c7 04 24 40 2e 11 80 	movl   $0x80112e40,(%esp)
80103c2b:	e8 01 05 00 00       	call   80104131 <release>
                //changes for task2
                *rtime = p->rtime;
80103c30:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80103c36:	8b 45 10             	mov    0x10(%ebp),%eax
80103c39:	89 10                	mov    %edx,(%eax)
                *iotime = p->iotime;
80103c3b:	8b 93 88 00 00 00    	mov    0x88(%ebx),%edx
80103c41:	8b 45 14             	mov    0x14(%ebp),%eax
80103c44:	89 10                	mov    %edx,(%eax)
                *wtime = p->etime - p->ctime - p->iotime - p->rtime;
80103c46:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
80103c4c:	2b 83 80 00 00 00    	sub    0x80(%ebx),%eax
80103c52:	2b 83 88 00 00 00    	sub    0x88(%ebx),%eax
80103c58:	2b 83 8c 00 00 00    	sub    0x8c(%ebx),%eax
80103c5e:	8b 55 0c             	mov    0xc(%ebp),%edx
80103c61:	89 02                	mov    %eax,(%edx)
                return pid;
80103c63:	83 c4 10             	add    $0x10,%esp
80103c66:	eb 4e                	jmp    80103cb6 <wait2+0x11d>
        // Scan through table looking for exited children.
        havekids = 0;
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
            if (p->parent != curproc)
                continue;
            havekids = 1;
80103c68:	b8 01 00 00 00       	mov    $0x1,%eax

    acquire(&ptable.lock);
    for (;;) {
        // Scan through table looking for exited children.
        havekids = 0;
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103c6d:	81 c3 98 00 00 00    	add    $0x98,%ebx
80103c73:	81 fb 74 54 11 80    	cmp    $0x80115474,%ebx
80103c79:	0f 85 44 ff ff ff    	jne    80103bc3 <wait2+0x2a>
            }

        }

        // No point waiting if we don't have any children.
        if (!havekids || curproc->killed) {
80103c7f:	85 c0                	test   %eax,%eax
80103c81:	74 06                	je     80103c89 <wait2+0xf0>
80103c83:	83 7e 24 00          	cmpl   $0x0,0x24(%esi)
80103c87:	74 17                	je     80103ca0 <wait2+0x107>
            release(&ptable.lock);
80103c89:	83 ec 0c             	sub    $0xc,%esp
80103c8c:	68 40 2e 11 80       	push   $0x80112e40
80103c91:	e8 9b 04 00 00       	call   80104131 <release>
            return -1;
80103c96:	83 c4 10             	add    $0x10,%esp
80103c99:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80103c9e:	eb 16                	jmp    80103cb6 <wait2+0x11d>
        }

        // Wait for children to exit.  (See wakeup1 call in proc_exit.)
        sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103ca0:	83 ec 08             	sub    $0x8,%esp
80103ca3:	68 40 2e 11 80       	push   $0x80112e40
80103ca8:	56                   	push   %esi
80103ca9:	e8 ba fc ff ff       	call   80103968 <sleep>
    }
80103cae:	83 c4 10             	add    $0x10,%esp
80103cb1:	e9 03 ff ff ff       	jmp    80103bb9 <wait2+0x20>

}
80103cb6:	89 f8                	mov    %edi,%eax
80103cb8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103cbb:	5b                   	pop    %ebx
80103cbc:	5e                   	pop    %esi
80103cbd:	5f                   	pop    %edi
80103cbe:	5d                   	pop    %ebp
80103cbf:	c3                   	ret    

80103cc0 <wakeup>:
        }
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan) {
80103cc0:	55                   	push   %ebp
80103cc1:	89 e5                	mov    %esp,%ebp
80103cc3:	83 ec 14             	sub    $0x14,%esp
    acquire(&ptable.lock);
80103cc6:	68 40 2e 11 80       	push   $0x80112e40
80103ccb:	e8 9c 03 00 00       	call   8010406c <acquire>
    wakeup1(chan);
80103cd0:	8b 45 08             	mov    0x8(%ebp),%eax
80103cd3:	e8 7b f4 ff ff       	call   80103153 <wakeup1>
    release(&ptable.lock);
80103cd8:	c7 04 24 40 2e 11 80 	movl   $0x80112e40,(%esp)
80103cdf:	e8 4d 04 00 00       	call   80104131 <release>
}
80103ce4:	83 c4 10             	add    $0x10,%esp
80103ce7:	c9                   	leave  
80103ce8:	c3                   	ret    

80103ce9 <kill>:

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid) {
80103ce9:	55                   	push   %ebp
80103cea:	89 e5                	mov    %esp,%ebp
80103cec:	53                   	push   %ebx
80103ced:	83 ec 10             	sub    $0x10,%esp
80103cf0:	8b 5d 08             	mov    0x8(%ebp),%ebx
    struct proc *p;

    acquire(&ptable.lock);
80103cf3:	68 40 2e 11 80       	push   $0x80112e40
80103cf8:	e8 6f 03 00 00       	call   8010406c <acquire>
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
        if (p->pid == pid) {
80103cfd:	83 c4 10             	add    $0x10,%esp
80103d00:	3b 1d 84 2e 11 80    	cmp    0x80112e84,%ebx
80103d06:	74 0e                	je     80103d16 <kill+0x2d>
80103d08:	b8 74 2e 11 80       	mov    $0x80112e74,%eax
80103d0d:	eb 37                	jmp    80103d46 <kill+0x5d>
80103d0f:	39 58 10             	cmp    %ebx,0x10(%eax)
80103d12:	75 32                	jne    80103d46 <kill+0x5d>
80103d14:	eb 05                	jmp    80103d1b <kill+0x32>
int
kill(int pid) {
    struct proc *p;

    acquire(&ptable.lock);
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103d16:	b8 74 2e 11 80       	mov    $0x80112e74,%eax
        if (p->pid == pid) {
            p->killed = 1;
80103d1b:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
            // Wake process from sleep if necessary.
            if (p->state == SLEEPING) {
80103d22:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103d26:	75 07                	jne    80103d2f <kill+0x46>
                p->state = RUNNABLE;
80103d28:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
#ifdef FCFS
                enqueue(p);
#endif
            }
            release(&ptable.lock);
80103d2f:	83 ec 0c             	sub    $0xc,%esp
80103d32:	68 40 2e 11 80       	push   $0x80112e40
80103d37:	e8 f5 03 00 00       	call   80104131 <release>
            return 0;
80103d3c:	83 c4 10             	add    $0x10,%esp
80103d3f:	b8 00 00 00 00       	mov    $0x0,%eax
80103d44:	eb 21                	jmp    80103d67 <kill+0x7e>
int
kill(int pid) {
    struct proc *p;

    acquire(&ptable.lock);
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103d46:	05 98 00 00 00       	add    $0x98,%eax
80103d4b:	3d 74 54 11 80       	cmp    $0x80115474,%eax
80103d50:	75 bd                	jne    80103d0f <kill+0x26>
            }
            release(&ptable.lock);
            return 0;
        }
    }
    release(&ptable.lock);
80103d52:	83 ec 0c             	sub    $0xc,%esp
80103d55:	68 40 2e 11 80       	push   $0x80112e40
80103d5a:	e8 d2 03 00 00       	call   80104131 <release>
    return -1;
80103d5f:	83 c4 10             	add    $0x10,%esp
80103d62:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103d67:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d6a:	c9                   	leave  
80103d6b:	c3                   	ret    

80103d6c <procdump>:
//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void) {
80103d6c:	55                   	push   %ebp
80103d6d:	89 e5                	mov    %esp,%ebp
80103d6f:	57                   	push   %edi
80103d70:	56                   	push   %esi
80103d71:	53                   	push   %ebx
80103d72:	83 ec 3c             	sub    $0x3c,%esp
80103d75:	bb e0 2e 11 80       	mov    $0x80112ee0,%ebx
80103d7a:	bf e0 54 11 80       	mov    $0x801154e0,%edi
80103d7f:	89 de                	mov    %ebx,%esi
    struct proc *p;
    char *state;
    uint pc[10];

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
        if (p->state == UNUSED)
80103d81:	8b 43 a0             	mov    -0x60(%ebx),%eax
80103d84:	85 c0                	test   %eax,%eax
80103d86:	0f 84 86 00 00 00    	je     80103e12 <procdump+0xa6>
            continue;
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
            state = states[p->state];
        else
            state = "???";
80103d8c:	ba e0 72 10 80       	mov    $0x801072e0,%edx
    uint pc[10];

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
        if (p->state == UNUSED)
            continue;
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103d91:	83 f8 05             	cmp    $0x5,%eax
80103d94:	77 11                	ja     80103da7 <procdump+0x3b>
80103d96:	8b 14 85 40 73 10 80 	mov    -0x7fef8cc0(,%eax,4),%edx
80103d9d:	85 d2                	test   %edx,%edx
            state = states[p->state];
        else
            state = "???";
80103d9f:	b8 e0 72 10 80       	mov    $0x801072e0,%eax
80103da4:	0f 44 d0             	cmove  %eax,%edx
        cprintf("%d %s %s", p->pid, state, p->name);
80103da7:	56                   	push   %esi
80103da8:	52                   	push   %edx
80103da9:	ff 76 a4             	pushl  -0x5c(%esi)
80103dac:	68 e4 72 10 80       	push   $0x801072e4
80103db1:	e8 33 c8 ff ff       	call   801005e9 <cprintf>
        if (p->state == SLEEPING) {
80103db6:	83 c4 10             	add    $0x10,%esp
80103db9:	83 7e a0 02          	cmpl   $0x2,-0x60(%esi)
80103dbd:	75 43                	jne    80103e02 <procdump+0x96>
            getcallerpcs((uint *) p->context->ebp + 2, pc);
80103dbf:	83 ec 08             	sub    $0x8,%esp
80103dc2:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103dc5:	50                   	push   %eax
80103dc6:	8b 46 b0             	mov    -0x50(%esi),%eax
80103dc9:	8b 40 0c             	mov    0xc(%eax),%eax
80103dcc:	83 c0 08             	add    $0x8,%eax
80103dcf:	50                   	push   %eax
80103dd0:	e8 ce 01 00 00       	call   80103fa3 <getcallerpcs>
            for (i = 0; i < 10 && pc[i] != 0; i++)
80103dd5:	8b 45 c0             	mov    -0x40(%ebp),%eax
80103dd8:	83 c4 10             	add    $0x10,%esp
80103ddb:	85 c0                	test   %eax,%eax
80103ddd:	75 43                	jne    80103e22 <procdump+0xb6>
80103ddf:	eb 21                	jmp    80103e02 <procdump+0x96>
                cprintf(" %p", pc[i]);
80103de1:	83 ec 08             	sub    $0x8,%esp
80103de4:	50                   	push   %eax
80103de5:	68 21 6d 10 80       	push   $0x80106d21
80103dea:	e8 fa c7 ff ff       	call   801005e9 <cprintf>
80103def:	83 c6 04             	add    $0x4,%esi
        else
            state = "???";
        cprintf("%d %s %s", p->pid, state, p->name);
        if (p->state == SLEEPING) {
            getcallerpcs((uint *) p->context->ebp + 2, pc);
            for (i = 0; i < 10 && pc[i] != 0; i++)
80103df2:	83 c4 10             	add    $0x10,%esp
80103df5:	8d 45 e8             	lea    -0x18(%ebp),%eax
80103df8:	39 c6                	cmp    %eax,%esi
80103dfa:	74 06                	je     80103e02 <procdump+0x96>
80103dfc:	8b 06                	mov    (%esi),%eax
80103dfe:	85 c0                	test   %eax,%eax
80103e00:	75 df                	jne    80103de1 <procdump+0x75>
                cprintf(" %p", pc[i]);
        }
        cprintf("\n");
80103e02:	83 ec 0c             	sub    $0xc,%esp
80103e05:	68 8f 76 10 80       	push   $0x8010768f
80103e0a:	e8 da c7 ff ff       	call   801005e9 <cprintf>
80103e0f:	83 c4 10             	add    $0x10,%esp
80103e12:	81 c3 98 00 00 00    	add    $0x98,%ebx
    int i;
    struct proc *p;
    char *state;
    uint pc[10];

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103e18:	39 fb                	cmp    %edi,%ebx
80103e1a:	0f 85 5f ff ff ff    	jne    80103d7f <procdump+0x13>
80103e20:	eb 16                	jmp    80103e38 <procdump+0xcc>
            state = "???";
        cprintf("%d %s %s", p->pid, state, p->name);
        if (p->state == SLEEPING) {
            getcallerpcs((uint *) p->context->ebp + 2, pc);
            for (i = 0; i < 10 && pc[i] != 0; i++)
                cprintf(" %p", pc[i]);
80103e22:	83 ec 08             	sub    $0x8,%esp
80103e25:	50                   	push   %eax
80103e26:	68 21 6d 10 80       	push   $0x80106d21
80103e2b:	e8 b9 c7 ff ff       	call   801005e9 <cprintf>
80103e30:	8d 75 c4             	lea    -0x3c(%ebp),%esi
80103e33:	83 c4 10             	add    $0x10,%esp
80103e36:	eb c4                	jmp    80103dfc <procdump+0x90>
        }
        cprintf("\n");
    }
}
80103e38:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e3b:	5b                   	pop    %ebx
80103e3c:	5e                   	pop    %esi
80103e3d:	5f                   	pop    %edi
80103e3e:	5d                   	pop    %ebp
80103e3f:	c3                   	ret    

80103e40 <updatetime>:

//update the process' time variables (rtime and iotime)
//
void
updatetime() {
80103e40:	55                   	push   %ebp
80103e41:	89 e5                	mov    %esp,%ebp
80103e43:	83 ec 14             	sub    $0x14,%esp
    acquire(&ptable.lock);
80103e46:	68 40 2e 11 80       	push   $0x80112e40
80103e4b:	e8 1c 02 00 00       	call   8010406c <acquire>
80103e50:	83 c4 10             	add    $0x10,%esp
    struct proc *p;
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103e53:	b8 74 2e 11 80       	mov    $0x80112e74,%eax
//            if(p->trem==0)
//                cprintf("ERROR-trem is: %d, pid: %d\n",p->trem,p->pid);
//            p->trem--;
//        }

        if (p->state == SLEEPING) {
80103e58:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e5c:	75 07                	jne    80103e65 <updatetime+0x25>
            p->iotime++;
80103e5e:	83 80 88 00 00 00 01 	addl   $0x1,0x88(%eax)
//
void
updatetime() {
    acquire(&ptable.lock);
    struct proc *p;
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103e65:	05 98 00 00 00       	add    $0x98,%eax
80103e6a:	3d 74 54 11 80       	cmp    $0x80115474,%eax
80103e6f:	75 e7                	jne    80103e58 <updatetime+0x18>

        if (p->state == SLEEPING) {
            p->iotime++;
        }
    }
    if(myproc()!=0) {
80103e71:	e8 24 f5 ff ff       	call   8010339a <myproc>
80103e76:	85 c0                	test   %eax,%eax
80103e78:	74 15                	je     80103e8f <updatetime+0x4f>
        myproc()->rtime++;
80103e7a:	e8 1b f5 ff ff       	call   8010339a <myproc>
80103e7f:	83 80 8c 00 00 00 01 	addl   $0x1,0x8c(%eax)
        myproc()->trem--;
80103e86:	e8 0f f5 ff ff       	call   8010339a <myproc>
80103e8b:	83 68 7c 01          	subl   $0x1,0x7c(%eax)
    }
    release(&ptable.lock);
80103e8f:	83 ec 0c             	sub    $0xc,%esp
80103e92:	68 40 2e 11 80       	push   $0x80112e40
80103e97:	e8 95 02 00 00       	call   80104131 <release>
80103e9c:	83 c4 10             	add    $0x10,%esp
80103e9f:	c9                   	leave  
80103ea0:	c3                   	ret    

80103ea1 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80103ea1:	55                   	push   %ebp
80103ea2:	89 e5                	mov    %esp,%ebp
80103ea4:	53                   	push   %ebx
80103ea5:	83 ec 0c             	sub    $0xc,%esp
80103ea8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80103eab:	68 5c 73 10 80       	push   $0x8010735c
80103eb0:	8d 43 04             	lea    0x4(%ebx),%eax
80103eb3:	50                   	push   %eax
80103eb4:	e8 cf 00 00 00       	call   80103f88 <initlock>
  lk->name = name;
80103eb9:	8b 45 0c             	mov    0xc(%ebp),%eax
80103ebc:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
80103ebf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103ec5:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
}
80103ecc:	83 c4 10             	add    $0x10,%esp
80103ecf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ed2:	c9                   	leave  
80103ed3:	c3                   	ret    

80103ed4 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80103ed4:	55                   	push   %ebp
80103ed5:	89 e5                	mov    %esp,%ebp
80103ed7:	56                   	push   %esi
80103ed8:	53                   	push   %ebx
80103ed9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103edc:	8d 73 04             	lea    0x4(%ebx),%esi
80103edf:	83 ec 0c             	sub    $0xc,%esp
80103ee2:	56                   	push   %esi
80103ee3:	e8 84 01 00 00       	call   8010406c <acquire>
  while (lk->locked) {
80103ee8:	83 c4 10             	add    $0x10,%esp
80103eeb:	83 3b 00             	cmpl   $0x0,(%ebx)
80103eee:	74 12                	je     80103f02 <acquiresleep+0x2e>
    sleep(lk, &lk->lk);
80103ef0:	83 ec 08             	sub    $0x8,%esp
80103ef3:	56                   	push   %esi
80103ef4:	53                   	push   %ebx
80103ef5:	e8 6e fa ff ff       	call   80103968 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
80103efa:	83 c4 10             	add    $0x10,%esp
80103efd:	83 3b 00             	cmpl   $0x0,(%ebx)
80103f00:	75 ee                	jne    80103ef0 <acquiresleep+0x1c>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
80103f02:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80103f08:	e8 8d f4 ff ff       	call   8010339a <myproc>
80103f0d:	8b 40 10             	mov    0x10(%eax),%eax
80103f10:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80103f13:	83 ec 0c             	sub    $0xc,%esp
80103f16:	56                   	push   %esi
80103f17:	e8 15 02 00 00       	call   80104131 <release>
}
80103f1c:	83 c4 10             	add    $0x10,%esp
80103f1f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103f22:	5b                   	pop    %ebx
80103f23:	5e                   	pop    %esi
80103f24:	5d                   	pop    %ebp
80103f25:	c3                   	ret    

80103f26 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80103f26:	55                   	push   %ebp
80103f27:	89 e5                	mov    %esp,%ebp
80103f29:	56                   	push   %esi
80103f2a:	53                   	push   %ebx
80103f2b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103f2e:	8d 73 04             	lea    0x4(%ebx),%esi
80103f31:	83 ec 0c             	sub    $0xc,%esp
80103f34:	56                   	push   %esi
80103f35:	e8 32 01 00 00       	call   8010406c <acquire>
  lk->locked = 0;
80103f3a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103f40:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80103f47:	89 1c 24             	mov    %ebx,(%esp)
80103f4a:	e8 71 fd ff ff       	call   80103cc0 <wakeup>
  release(&lk->lk);
80103f4f:	89 34 24             	mov    %esi,(%esp)
80103f52:	e8 da 01 00 00       	call   80104131 <release>
}
80103f57:	83 c4 10             	add    $0x10,%esp
80103f5a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103f5d:	5b                   	pop    %ebx
80103f5e:	5e                   	pop    %esi
80103f5f:	5d                   	pop    %ebp
80103f60:	c3                   	ret    

80103f61 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80103f61:	55                   	push   %ebp
80103f62:	89 e5                	mov    %esp,%ebp
80103f64:	56                   	push   %esi
80103f65:	53                   	push   %ebx
80103f66:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;
  
  acquire(&lk->lk);
80103f69:	8d 5e 04             	lea    0x4(%esi),%ebx
80103f6c:	83 ec 0c             	sub    $0xc,%esp
80103f6f:	53                   	push   %ebx
80103f70:	e8 f7 00 00 00       	call   8010406c <acquire>
  r = lk->locked;
80103f75:	8b 36                	mov    (%esi),%esi
  release(&lk->lk);
80103f77:	89 1c 24             	mov    %ebx,(%esp)
80103f7a:	e8 b2 01 00 00       	call   80104131 <release>
  return r;
}
80103f7f:	89 f0                	mov    %esi,%eax
80103f81:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103f84:	5b                   	pop    %ebx
80103f85:	5e                   	pop    %esi
80103f86:	5d                   	pop    %ebp
80103f87:	c3                   	ret    

80103f88 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80103f88:	55                   	push   %ebp
80103f89:	89 e5                	mov    %esp,%ebp
80103f8b:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80103f8e:	8b 55 0c             	mov    0xc(%ebp),%edx
80103f91:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80103f94:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80103f9a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80103fa1:	5d                   	pop    %ebp
80103fa2:	c3                   	ret    

80103fa3 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80103fa3:	55                   	push   %ebp
80103fa4:	89 e5                	mov    %esp,%ebp
80103fa6:	53                   	push   %ebx
80103fa7:	8b 45 08             	mov    0x8(%ebp),%eax
80103faa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80103fad:	8d 90 f8 ff ff 7f    	lea    0x7ffffff8(%eax),%edx
80103fb3:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
80103fb9:	76 3a                	jbe    80103ff5 <getcallerpcs+0x52>
80103fbb:	eb 31                	jmp    80103fee <getcallerpcs+0x4b>
80103fbd:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80103fc3:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80103fc9:	77 12                	ja     80103fdd <getcallerpcs+0x3a>
      break;
    pcs[i] = ebp[1];     // saved %eip
80103fcb:	8b 5a 04             	mov    0x4(%edx),%ebx
80103fce:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
    ebp = (uint*)ebp[0]; // saved %ebp
80103fd1:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80103fd3:	83 c0 01             	add    $0x1,%eax
80103fd6:	83 f8 0a             	cmp    $0xa,%eax
80103fd9:	75 e2                	jne    80103fbd <getcallerpcs+0x1a>
80103fdb:	eb 27                	jmp    80104004 <getcallerpcs+0x61>
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80103fdd:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80103fe4:	83 c0 01             	add    $0x1,%eax
80103fe7:	83 f8 09             	cmp    $0x9,%eax
80103fea:	7e f1                	jle    80103fdd <getcallerpcs+0x3a>
80103fec:	eb 16                	jmp    80104004 <getcallerpcs+0x61>
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80103fee:	b8 00 00 00 00       	mov    $0x0,%eax
80103ff3:	eb e8                	jmp    80103fdd <getcallerpcs+0x3a>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
80103ff5:	8b 50 fc             	mov    -0x4(%eax),%edx
80103ff8:	89 11                	mov    %edx,(%ecx)
    ebp = (uint*)ebp[0]; // saved %ebp
80103ffa:	8b 50 f8             	mov    -0x8(%eax),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80103ffd:	b8 01 00 00 00       	mov    $0x1,%eax
80104002:	eb b9                	jmp    80103fbd <getcallerpcs+0x1a>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104004:	5b                   	pop    %ebx
80104005:	5d                   	pop    %ebp
80104006:	c3                   	ret    

80104007 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104007:	55                   	push   %ebp
80104008:	89 e5                	mov    %esp,%ebp
8010400a:	53                   	push   %ebx
8010400b:	83 ec 04             	sub    $0x4,%esp
8010400e:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
80104011:	b8 00 00 00 00       	mov    $0x0,%eax
80104016:	83 3a 00             	cmpl   $0x0,(%edx)
80104019:	74 10                	je     8010402b <holding+0x24>
8010401b:	8b 5a 08             	mov    0x8(%edx),%ebx
8010401e:	e8 e1 f2 ff ff       	call   80103304 <mycpu>
80104023:	39 c3                	cmp    %eax,%ebx
80104025:	0f 94 c0             	sete   %al
80104028:	0f b6 c0             	movzbl %al,%eax
}
8010402b:	83 c4 04             	add    $0x4,%esp
8010402e:	5b                   	pop    %ebx
8010402f:	5d                   	pop    %ebp
80104030:	c3                   	ret    

80104031 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104031:	55                   	push   %ebp
80104032:	89 e5                	mov    %esp,%ebp
80104034:	53                   	push   %ebx
80104035:	83 ec 04             	sub    $0x4,%esp
80104038:	9c                   	pushf  
80104039:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
8010403a:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010403b:	e8 c4 f2 ff ff       	call   80103304 <mycpu>
80104040:	83 b8 a4 00 00 00 00 	cmpl   $0x0,0xa4(%eax)
80104047:	75 11                	jne    8010405a <pushcli+0x29>
    mycpu()->intena = eflags & FL_IF;
80104049:	e8 b6 f2 ff ff       	call   80103304 <mycpu>
8010404e:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104054:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010405a:	e8 a5 f2 ff ff       	call   80103304 <mycpu>
8010405f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104066:	83 c4 04             	add    $0x4,%esp
80104069:	5b                   	pop    %ebx
8010406a:	5d                   	pop    %ebp
8010406b:	c3                   	ret    

8010406c <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
8010406c:	55                   	push   %ebp
8010406d:	89 e5                	mov    %esp,%ebp
8010406f:	53                   	push   %ebx
80104070:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104073:	e8 b9 ff ff ff       	call   80104031 <pushcli>
  if(holding(lk))
80104078:	83 ec 0c             	sub    $0xc,%esp
8010407b:	ff 75 08             	pushl  0x8(%ebp)
8010407e:	e8 84 ff ff ff       	call   80104007 <holding>
80104083:	83 c4 10             	add    $0x10,%esp
80104086:	85 c0                	test   %eax,%eax
80104088:	74 0d                	je     80104097 <acquire+0x2b>
    panic("acquire");
8010408a:	83 ec 0c             	sub    $0xc,%esp
8010408d:	68 67 73 10 80       	push   $0x80107367
80104092:	e8 b6 c2 ff ff       	call   8010034d <panic>
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104097:	b9 01 00 00 00       	mov    $0x1,%ecx

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
8010409c:	8b 55 08             	mov    0x8(%ebp),%edx
8010409f:	89 c8                	mov    %ecx,%eax
801040a1:	f0 87 02             	lock xchg %eax,(%edx)
801040a4:	85 c0                	test   %eax,%eax
801040a6:	75 f4                	jne    8010409c <acquire+0x30>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
801040a8:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
801040ad:	8b 5d 08             	mov    0x8(%ebp),%ebx
801040b0:	e8 4f f2 ff ff       	call   80103304 <mycpu>
801040b5:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
801040b8:	83 ec 08             	sub    $0x8,%esp
801040bb:	8b 45 08             	mov    0x8(%ebp),%eax
801040be:	83 c0 0c             	add    $0xc,%eax
801040c1:	50                   	push   %eax
801040c2:	8d 45 08             	lea    0x8(%ebp),%eax
801040c5:	50                   	push   %eax
801040c6:	e8 d8 fe ff ff       	call   80103fa3 <getcallerpcs>
}
801040cb:	83 c4 10             	add    $0x10,%esp
801040ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040d1:	c9                   	leave  
801040d2:	c3                   	ret    

801040d3 <popcli>:
  mycpu()->ncli += 1;
}

void
popcli(void)
{
801040d3:	55                   	push   %ebp
801040d4:	89 e5                	mov    %esp,%ebp
801040d6:	83 ec 08             	sub    $0x8,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801040d9:	9c                   	pushf  
801040da:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801040db:	f6 c4 02             	test   $0x2,%ah
801040de:	74 0d                	je     801040ed <popcli+0x1a>
    panic("popcli - interruptible");
801040e0:	83 ec 0c             	sub    $0xc,%esp
801040e3:	68 6f 73 10 80       	push   $0x8010736f
801040e8:	e8 60 c2 ff ff       	call   8010034d <panic>
  if(--mycpu()->ncli < 0)
801040ed:	e8 12 f2 ff ff       	call   80103304 <mycpu>
801040f2:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
801040f8:	8d 51 ff             	lea    -0x1(%ecx),%edx
801040fb:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80104101:	85 d2                	test   %edx,%edx
80104103:	79 0d                	jns    80104112 <popcli+0x3f>
    panic("popcli");
80104105:	83 ec 0c             	sub    $0xc,%esp
80104108:	68 86 73 10 80       	push   $0x80107386
8010410d:	e8 3b c2 ff ff       	call   8010034d <panic>
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104112:	e8 ed f1 ff ff       	call   80103304 <mycpu>
80104117:	83 b8 a4 00 00 00 00 	cmpl   $0x0,0xa4(%eax)
8010411e:	75 0f                	jne    8010412f <popcli+0x5c>
80104120:	e8 df f1 ff ff       	call   80103304 <mycpu>
80104125:	83 b8 a8 00 00 00 00 	cmpl   $0x0,0xa8(%eax)
8010412c:	74 01                	je     8010412f <popcli+0x5c>
}

static inline void
sti(void)
{
  asm volatile("sti");
8010412e:	fb                   	sti    
    sti();
}
8010412f:	c9                   	leave  
80104130:	c3                   	ret    

80104131 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
80104131:	55                   	push   %ebp
80104132:	89 e5                	mov    %esp,%ebp
80104134:	53                   	push   %ebx
80104135:	83 ec 10             	sub    $0x10,%esp
80104138:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
8010413b:	53                   	push   %ebx
8010413c:	e8 c6 fe ff ff       	call   80104007 <holding>
80104141:	83 c4 10             	add    $0x10,%esp
80104144:	85 c0                	test   %eax,%eax
80104146:	75 0d                	jne    80104155 <release+0x24>
    panic("release");
80104148:	83 ec 0c             	sub    $0xc,%esp
8010414b:	68 8d 73 10 80       	push   $0x8010738d
80104150:	e8 f8 c1 ff ff       	call   8010034d <panic>

  lk->pcs[0] = 0;
80104155:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
8010415c:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
80104163:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104168:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)

  popcli();
8010416e:	e8 60 ff ff ff       	call   801040d3 <popcli>
}
80104173:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104176:	c9                   	leave  
80104177:	c3                   	ret    

80104178 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104178:	55                   	push   %ebp
80104179:	89 e5                	mov    %esp,%ebp
8010417b:	57                   	push   %edi
8010417c:	53                   	push   %ebx
8010417d:	8b 55 08             	mov    0x8(%ebp),%edx
80104180:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104183:	f6 c2 03             	test   $0x3,%dl
80104186:	75 26                	jne    801041ae <memset+0x36>
80104188:	f6 c1 03             	test   $0x3,%cl
8010418b:	75 21                	jne    801041ae <memset+0x36>
    c &= 0xFF;
8010418d:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
80104191:	c1 e9 02             	shr    $0x2,%ecx
80104194:	89 fb                	mov    %edi,%ebx
80104196:	c1 e3 18             	shl    $0x18,%ebx
80104199:	89 f8                	mov    %edi,%eax
8010419b:	c1 e0 10             	shl    $0x10,%eax
8010419e:	09 d8                	or     %ebx,%eax
801041a0:	09 f8                	or     %edi,%eax
801041a2:	c1 e7 08             	shl    $0x8,%edi
801041a5:	09 f8                	or     %edi,%eax
801041a7:	89 d7                	mov    %edx,%edi
801041a9:	fc                   	cld    
801041aa:	f3 ab                	rep stos %eax,%es:(%edi)
801041ac:	eb 08                	jmp    801041b6 <memset+0x3e>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
801041ae:	89 d7                	mov    %edx,%edi
801041b0:	8b 45 0c             	mov    0xc(%ebp),%eax
801041b3:	fc                   	cld    
801041b4:	f3 aa                	rep stos %al,%es:(%edi)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
801041b6:	89 d0                	mov    %edx,%eax
801041b8:	5b                   	pop    %ebx
801041b9:	5f                   	pop    %edi
801041ba:	5d                   	pop    %ebp
801041bb:	c3                   	ret    

801041bc <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801041bc:	55                   	push   %ebp
801041bd:	89 e5                	mov    %esp,%ebp
801041bf:	57                   	push   %edi
801041c0:	56                   	push   %esi
801041c1:	53                   	push   %ebx
801041c2:	8b 5d 08             	mov    0x8(%ebp),%ebx
801041c5:	8b 75 0c             	mov    0xc(%ebp),%esi
801041c8:	8b 45 10             	mov    0x10(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801041cb:	85 c0                	test   %eax,%eax
801041cd:	74 39                	je     80104208 <memcmp+0x4c>
801041cf:	8d 78 ff             	lea    -0x1(%eax),%edi
    if(*s1 != *s2)
801041d2:	0f b6 13             	movzbl (%ebx),%edx
801041d5:	0f b6 0e             	movzbl (%esi),%ecx
801041d8:	38 ca                	cmp    %cl,%dl
801041da:	75 17                	jne    801041f3 <memcmp+0x37>
801041dc:	b8 00 00 00 00       	mov    $0x0,%eax
801041e1:	eb 1a                	jmp    801041fd <memcmp+0x41>
801041e3:	0f b6 54 03 01       	movzbl 0x1(%ebx,%eax,1),%edx
801041e8:	83 c0 01             	add    $0x1,%eax
801041eb:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
801041ef:	38 ca                	cmp    %cl,%dl
801041f1:	74 0a                	je     801041fd <memcmp+0x41>
      return *s1 - *s2;
801041f3:	0f b6 c2             	movzbl %dl,%eax
801041f6:	0f b6 c9             	movzbl %cl,%ecx
801041f9:	29 c8                	sub    %ecx,%eax
801041fb:	eb 10                	jmp    8010420d <memcmp+0x51>
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801041fd:	39 f8                	cmp    %edi,%eax
801041ff:	75 e2                	jne    801041e3 <memcmp+0x27>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80104201:	b8 00 00 00 00       	mov    $0x0,%eax
80104206:	eb 05                	jmp    8010420d <memcmp+0x51>
80104208:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010420d:	5b                   	pop    %ebx
8010420e:	5e                   	pop    %esi
8010420f:	5f                   	pop    %edi
80104210:	5d                   	pop    %ebp
80104211:	c3                   	ret    

80104212 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104212:	55                   	push   %ebp
80104213:	89 e5                	mov    %esp,%ebp
80104215:	56                   	push   %esi
80104216:	53                   	push   %ebx
80104217:	8b 45 08             	mov    0x8(%ebp),%eax
8010421a:	8b 75 0c             	mov    0xc(%ebp),%esi
8010421d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104220:	39 c6                	cmp    %eax,%esi
80104222:	72 0b                	jb     8010422f <memmove+0x1d>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104224:	ba 00 00 00 00       	mov    $0x0,%edx
80104229:	85 db                	test   %ebx,%ebx
8010422b:	75 25                	jne    80104252 <memmove+0x40>
8010422d:	eb 31                	jmp    80104260 <memmove+0x4e>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010422f:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
80104232:	39 c8                	cmp    %ecx,%eax
80104234:	73 ee                	jae    80104224 <memmove+0x12>
    s += n;
    d += n;
    while(n-- > 0)
80104236:	8d 53 ff             	lea    -0x1(%ebx),%edx
80104239:	85 db                	test   %ebx,%ebx
8010423b:	74 23                	je     80104260 <memmove+0x4e>
      *--d = *--s;
8010423d:	29 d9                	sub    %ebx,%ecx
8010423f:	89 cb                	mov    %ecx,%ebx
80104241:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104245:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80104248:	83 ea 01             	sub    $0x1,%edx
8010424b:	83 fa ff             	cmp    $0xffffffff,%edx
8010424e:	75 f1                	jne    80104241 <memmove+0x2f>
80104250:	eb 0e                	jmp    80104260 <memmove+0x4e>
      *--d = *--s;
  } else
    while(n-- > 0)
      *d++ = *s++;
80104252:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104256:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104259:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
8010425c:	39 d3                	cmp    %edx,%ebx
8010425e:	75 f2                	jne    80104252 <memmove+0x40>
      *d++ = *s++;

  return dst;
}
80104260:	5b                   	pop    %ebx
80104261:	5e                   	pop    %esi
80104262:	5d                   	pop    %ebp
80104263:	c3                   	ret    

80104264 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104264:	55                   	push   %ebp
80104265:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
80104267:	ff 75 10             	pushl  0x10(%ebp)
8010426a:	ff 75 0c             	pushl  0xc(%ebp)
8010426d:	ff 75 08             	pushl  0x8(%ebp)
80104270:	e8 9d ff ff ff       	call   80104212 <memmove>
}
80104275:	c9                   	leave  
80104276:	c3                   	ret    

80104277 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104277:	55                   	push   %ebp
80104278:	89 e5                	mov    %esp,%ebp
8010427a:	56                   	push   %esi
8010427b:	53                   	push   %ebx
8010427c:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010427f:	8b 55 0c             	mov    0xc(%ebp),%edx
80104282:	8b 75 10             	mov    0x10(%ebp),%esi
  while(n > 0 && *p && *p == *q)
80104285:	85 f6                	test   %esi,%esi
80104287:	74 29                	je     801042b2 <strncmp+0x3b>
80104289:	0f b6 03             	movzbl (%ebx),%eax
8010428c:	84 c0                	test   %al,%al
8010428e:	74 30                	je     801042c0 <strncmp+0x49>
80104290:	3a 02                	cmp    (%edx),%al
80104292:	75 2c                	jne    801042c0 <strncmp+0x49>
80104294:	8d 43 01             	lea    0x1(%ebx),%eax
80104297:	01 de                	add    %ebx,%esi
    n--, p++, q++;
80104299:	89 c3                	mov    %eax,%ebx
8010429b:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
8010429e:	39 c6                	cmp    %eax,%esi
801042a0:	74 17                	je     801042b9 <strncmp+0x42>
801042a2:	0f b6 08             	movzbl (%eax),%ecx
801042a5:	84 c9                	test   %cl,%cl
801042a7:	74 17                	je     801042c0 <strncmp+0x49>
801042a9:	83 c0 01             	add    $0x1,%eax
801042ac:	3a 0a                	cmp    (%edx),%cl
801042ae:	74 e9                	je     80104299 <strncmp+0x22>
801042b0:	eb 0e                	jmp    801042c0 <strncmp+0x49>
    n--, p++, q++;
  if(n == 0)
    return 0;
801042b2:	b8 00 00 00 00       	mov    $0x0,%eax
801042b7:	eb 0f                	jmp    801042c8 <strncmp+0x51>
801042b9:	b8 00 00 00 00       	mov    $0x0,%eax
801042be:	eb 08                	jmp    801042c8 <strncmp+0x51>
  return (uchar)*p - (uchar)*q;
801042c0:	0f b6 03             	movzbl (%ebx),%eax
801042c3:	0f b6 12             	movzbl (%edx),%edx
801042c6:	29 d0                	sub    %edx,%eax
}
801042c8:	5b                   	pop    %ebx
801042c9:	5e                   	pop    %esi
801042ca:	5d                   	pop    %ebp
801042cb:	c3                   	ret    

801042cc <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801042cc:	55                   	push   %ebp
801042cd:	89 e5                	mov    %esp,%ebp
801042cf:	57                   	push   %edi
801042d0:	56                   	push   %esi
801042d1:	53                   	push   %ebx
801042d2:	8b 7d 08             	mov    0x8(%ebp),%edi
801042d5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801042d8:	8b 55 10             	mov    0x10(%ebp),%edx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801042db:	89 f9                	mov    %edi,%ecx
801042dd:	eb 02                	jmp    801042e1 <strncpy+0x15>
801042df:	89 f2                	mov    %esi,%edx
801042e1:	8d 72 ff             	lea    -0x1(%edx),%esi
801042e4:	85 d2                	test   %edx,%edx
801042e6:	7f 0e                	jg     801042f6 <strncpy+0x2a>
    ;
  while(n-- > 0)
801042e8:	bb 00 00 00 00       	mov    $0x0,%ebx
801042ed:	83 ea 01             	sub    $0x1,%edx
801042f0:	85 f6                	test   %esi,%esi
801042f2:	7f 15                	jg     80104309 <strncpy+0x3d>
801042f4:	eb 22                	jmp    80104318 <strncpy+0x4c>
strncpy(char *s, const char *t, int n)
{
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801042f6:	83 c1 01             	add    $0x1,%ecx
801042f9:	83 c3 01             	add    $0x1,%ebx
801042fc:	0f b6 43 ff          	movzbl -0x1(%ebx),%eax
80104300:	88 41 ff             	mov    %al,-0x1(%ecx)
80104303:	84 c0                	test   %al,%al
80104305:	75 d8                	jne    801042df <strncpy+0x13>
80104307:	eb df                	jmp    801042e8 <strncpy+0x1c>
    ;
  while(n-- > 0)
    *s++ = 0;
80104309:	c6 04 19 00          	movb   $0x0,(%ecx,%ebx,1)
8010430d:	83 c3 01             	add    $0x1,%ebx
80104310:	89 d6                	mov    %edx,%esi
80104312:	29 de                	sub    %ebx,%esi
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80104314:	85 f6                	test   %esi,%esi
80104316:	7f f1                	jg     80104309 <strncpy+0x3d>
    *s++ = 0;
  return os;
}
80104318:	89 f8                	mov    %edi,%eax
8010431a:	5b                   	pop    %ebx
8010431b:	5e                   	pop    %esi
8010431c:	5f                   	pop    %edi
8010431d:	5d                   	pop    %ebp
8010431e:	c3                   	ret    

8010431f <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
8010431f:	55                   	push   %ebp
80104320:	89 e5                	mov    %esp,%ebp
80104322:	56                   	push   %esi
80104323:	53                   	push   %ebx
80104324:	8b 45 08             	mov    0x8(%ebp),%eax
80104327:	8b 55 0c             	mov    0xc(%ebp),%edx
8010432a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  if(n <= 0)
8010432d:	85 c9                	test   %ecx,%ecx
8010432f:	7e 1e                	jle    8010434f <safestrcpy+0x30>
80104331:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104335:	89 c1                	mov    %eax,%ecx
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104337:	39 f2                	cmp    %esi,%edx
80104339:	74 11                	je     8010434c <safestrcpy+0x2d>
8010433b:	83 c1 01             	add    $0x1,%ecx
8010433e:	83 c2 01             	add    $0x1,%edx
80104341:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104345:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104348:	84 db                	test   %bl,%bl
8010434a:	75 eb                	jne    80104337 <safestrcpy+0x18>
    ;
  *s = 0;
8010434c:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
8010434f:	5b                   	pop    %ebx
80104350:	5e                   	pop    %esi
80104351:	5d                   	pop    %ebp
80104352:	c3                   	ret    

80104353 <strlen>:

int
strlen(const char *s)
{
80104353:	55                   	push   %ebp
80104354:	89 e5                	mov    %esp,%ebp
80104356:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
80104359:	80 3a 00             	cmpb   $0x0,(%edx)
8010435c:	74 10                	je     8010436e <strlen+0x1b>
8010435e:	b8 00 00 00 00       	mov    $0x0,%eax
80104363:	83 c0 01             	add    $0x1,%eax
80104366:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
8010436a:	75 f7                	jne    80104363 <strlen+0x10>
8010436c:	eb 05                	jmp    80104373 <strlen+0x20>
8010436e:	b8 00 00 00 00       	mov    $0x0,%eax
    ;
  return n;
}
80104373:	5d                   	pop    %ebp
80104374:	c3                   	ret    

80104375 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104375:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104379:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
8010437d:	55                   	push   %ebp
  pushl %ebx
8010437e:	53                   	push   %ebx
  pushl %esi
8010437f:	56                   	push   %esi
  pushl %edi
80104380:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104381:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104383:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80104385:	5f                   	pop    %edi
  popl %esi
80104386:	5e                   	pop    %esi
  popl %ebx
80104387:	5b                   	pop    %ebx
  popl %ebp
80104388:	5d                   	pop    %ebp
  ret
80104389:	c3                   	ret    

8010438a <fetchint>:
// library system call function. The saved user %esp points
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip) {
8010438a:	55                   	push   %ebp
8010438b:	89 e5                	mov    %esp,%ebp
8010438d:	53                   	push   %ebx
8010438e:	83 ec 04             	sub    $0x4,%esp
80104391:	8b 5d 08             	mov    0x8(%ebp),%ebx
    struct proc *curproc = myproc();
80104394:	e8 01 f0 ff ff       	call   8010339a <myproc>

    if (addr >= curproc->sz || addr + 4 > curproc->sz)
80104399:	8b 00                	mov    (%eax),%eax
8010439b:	39 d8                	cmp    %ebx,%eax
8010439d:	76 15                	jbe    801043b4 <fetchint+0x2a>
8010439f:	8d 53 04             	lea    0x4(%ebx),%edx
801043a2:	39 d0                	cmp    %edx,%eax
801043a4:	72 15                	jb     801043bb <fetchint+0x31>
        return -1;
    *ip = *(int *) (addr);
801043a6:	8b 13                	mov    (%ebx),%edx
801043a8:	8b 45 0c             	mov    0xc(%ebp),%eax
801043ab:	89 10                	mov    %edx,(%eax)
    return 0;
801043ad:	b8 00 00 00 00       	mov    $0x0,%eax
801043b2:	eb 0c                	jmp    801043c0 <fetchint+0x36>
int
fetchint(uint addr, int *ip) {
    struct proc *curproc = myproc();

    if (addr >= curproc->sz || addr + 4 > curproc->sz)
        return -1;
801043b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801043b9:	eb 05                	jmp    801043c0 <fetchint+0x36>
801043bb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    *ip = *(int *) (addr);
    return 0;
}
801043c0:	83 c4 04             	add    $0x4,%esp
801043c3:	5b                   	pop    %ebx
801043c4:	5d                   	pop    %ebp
801043c5:	c3                   	ret    

801043c6 <fetchstr>:

// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp) {
801043c6:	55                   	push   %ebp
801043c7:	89 e5                	mov    %esp,%ebp
801043c9:	53                   	push   %ebx
801043ca:	83 ec 04             	sub    $0x4,%esp
801043cd:	8b 5d 08             	mov    0x8(%ebp),%ebx
    char *s, *ep;
    struct proc *curproc = myproc();
801043d0:	e8 c5 ef ff ff       	call   8010339a <myproc>

    if (addr >= curproc->sz)
801043d5:	39 18                	cmp    %ebx,(%eax)
801043d7:	76 2d                	jbe    80104406 <fetchstr+0x40>
        return -1;
    *pp = (char *) addr;
801043d9:	89 da                	mov    %ebx,%edx
801043db:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801043de:	89 19                	mov    %ebx,(%ecx)
    ep = (char *) curproc->sz;
801043e0:	8b 00                	mov    (%eax),%eax
    for (s = *pp; s < ep; s++) {
801043e2:	39 c3                	cmp    %eax,%ebx
801043e4:	73 27                	jae    8010440d <fetchstr+0x47>
        if (*s == 0)
801043e6:	80 3b 00             	cmpb   $0x0,(%ebx)
801043e9:	75 0d                	jne    801043f8 <fetchstr+0x32>
801043eb:	eb 05                	jmp    801043f2 <fetchstr+0x2c>
801043ed:	80 3a 00             	cmpb   $0x0,(%edx)
801043f0:	75 06                	jne    801043f8 <fetchstr+0x32>
            return s - *pp;
801043f2:	89 d0                	mov    %edx,%eax
801043f4:	29 d8                	sub    %ebx,%eax
801043f6:	eb 1a                	jmp    80104412 <fetchstr+0x4c>

    if (addr >= curproc->sz)
        return -1;
    *pp = (char *) addr;
    ep = (char *) curproc->sz;
    for (s = *pp; s < ep; s++) {
801043f8:	83 c2 01             	add    $0x1,%edx
801043fb:	39 d0                	cmp    %edx,%eax
801043fd:	77 ee                	ja     801043ed <fetchstr+0x27>
        if (*s == 0)
            return s - *pp;
    }
    return -1;
801043ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104404:	eb 0c                	jmp    80104412 <fetchstr+0x4c>
fetchstr(uint addr, char **pp) {
    char *s, *ep;
    struct proc *curproc = myproc();

    if (addr >= curproc->sz)
        return -1;
80104406:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010440b:	eb 05                	jmp    80104412 <fetchstr+0x4c>
    ep = (char *) curproc->sz;
    for (s = *pp; s < ep; s++) {
        if (*s == 0)
            return s - *pp;
    }
    return -1;
8010440d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104412:	83 c4 04             	add    $0x4,%esp
80104415:	5b                   	pop    %ebx
80104416:	5d                   	pop    %ebp
80104417:	c3                   	ret    

80104418 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip) {
80104418:	55                   	push   %ebp
80104419:	89 e5                	mov    %esp,%ebp
8010441b:	83 ec 08             	sub    $0x8,%esp
    return fetchint((myproc()->tf->esp) + 4 + 4 * n, ip);
8010441e:	e8 77 ef ff ff       	call   8010339a <myproc>
80104423:	83 ec 08             	sub    $0x8,%esp
80104426:	ff 75 0c             	pushl  0xc(%ebp)
80104429:	8b 40 18             	mov    0x18(%eax),%eax
8010442c:	8b 40 44             	mov    0x44(%eax),%eax
8010442f:	8b 55 08             	mov    0x8(%ebp),%edx
80104432:	8d 44 90 04          	lea    0x4(%eax,%edx,4),%eax
80104436:	50                   	push   %eax
80104437:	e8 4e ff ff ff       	call   8010438a <fetchint>
}
8010443c:	c9                   	leave  
8010443d:	c3                   	ret    

8010443e <argptr>:

// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size) {
8010443e:	55                   	push   %ebp
8010443f:	89 e5                	mov    %esp,%ebp
80104441:	56                   	push   %esi
80104442:	53                   	push   %ebx
80104443:	83 ec 10             	sub    $0x10,%esp
80104446:	8b 5d 10             	mov    0x10(%ebp),%ebx
    int i;
    struct proc *curproc = myproc();
80104449:	e8 4c ef ff ff       	call   8010339a <myproc>
8010444e:	89 c6                	mov    %eax,%esi

    if (argint(n, &i) < 0)
80104450:	83 ec 08             	sub    $0x8,%esp
80104453:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104456:	50                   	push   %eax
80104457:	ff 75 08             	pushl  0x8(%ebp)
8010445a:	e8 b9 ff ff ff       	call   80104418 <argint>
        return -1;
    if (size < 0 || (uint) i >= curproc->sz || (uint) i + size > curproc->sz)
8010445f:	89 da                	mov    %ebx,%edx
80104461:	c1 ea 1f             	shr    $0x1f,%edx
80104464:	83 c4 10             	add    $0x10,%esp
80104467:	84 d2                	test   %dl,%dl
80104469:	75 22                	jne    8010448d <argptr+0x4f>
8010446b:	c1 e8 1f             	shr    $0x1f,%eax
8010446e:	84 c0                	test   %al,%al
80104470:	75 1b                	jne    8010448d <argptr+0x4f>
80104472:	8b 16                	mov    (%esi),%edx
80104474:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104477:	39 c2                	cmp    %eax,%edx
80104479:	76 19                	jbe    80104494 <argptr+0x56>
8010447b:	01 c3                	add    %eax,%ebx
8010447d:	39 da                	cmp    %ebx,%edx
8010447f:	72 1a                	jb     8010449b <argptr+0x5d>
        return -1;
    *pp = (char *) i;
80104481:	8b 55 0c             	mov    0xc(%ebp),%edx
80104484:	89 02                	mov    %eax,(%edx)
    return 0;
80104486:	b8 00 00 00 00       	mov    $0x0,%eax
8010448b:	eb 13                	jmp    801044a0 <argptr+0x62>
    struct proc *curproc = myproc();

    if (argint(n, &i) < 0)
        return -1;
    if (size < 0 || (uint) i >= curproc->sz || (uint) i + size > curproc->sz)
        return -1;
8010448d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104492:	eb 0c                	jmp    801044a0 <argptr+0x62>
80104494:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104499:	eb 05                	jmp    801044a0 <argptr+0x62>
8010449b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    *pp = (char *) i;
    return 0;
}
801044a0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801044a3:	5b                   	pop    %ebx
801044a4:	5e                   	pop    %esi
801044a5:	5d                   	pop    %ebp
801044a6:	c3                   	ret    

801044a7 <argstr>:
// Fetch the nth word-sized system call argument as a string pointer.
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp) {
801044a7:	55                   	push   %ebp
801044a8:	89 e5                	mov    %esp,%ebp
801044aa:	83 ec 20             	sub    $0x20,%esp
    int addr;
    if (argint(n, &addr) < 0)
801044ad:	8d 45 f4             	lea    -0xc(%ebp),%eax
801044b0:	50                   	push   %eax
801044b1:	ff 75 08             	pushl  0x8(%ebp)
801044b4:	e8 5f ff ff ff       	call   80104418 <argint>
801044b9:	83 c4 10             	add    $0x10,%esp
801044bc:	85 c0                	test   %eax,%eax
801044be:	78 13                	js     801044d3 <argstr+0x2c>
        return -1;
    return fetchstr(addr, pp);
801044c0:	83 ec 08             	sub    $0x8,%esp
801044c3:	ff 75 0c             	pushl  0xc(%ebp)
801044c6:	ff 75 f4             	pushl  -0xc(%ebp)
801044c9:	e8 f8 fe ff ff       	call   801043c6 <fetchstr>
801044ce:	83 c4 10             	add    $0x10,%esp
801044d1:	eb 05                	jmp    801044d8 <argstr+0x31>
// between this check and being used by the kernel.)
int
argstr(int n, char **pp) {
    int addr;
    if (argint(n, &addr) < 0)
        return -1;
801044d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return fetchstr(addr, pp);
}
801044d8:	c9                   	leave  
801044d9:	c3                   	ret    

801044da <syscall>:
        [SYS_wait2]          sys_wait2,
        [SYS_set_priority]   sys_set_priority,
};

void
syscall(void) {
801044da:	55                   	push   %ebp
801044db:	89 e5                	mov    %esp,%ebp
801044dd:	56                   	push   %esi
801044de:	53                   	push   %ebx
    int num;
    struct proc *curproc = myproc();
801044df:	e8 b6 ee ff ff       	call   8010339a <myproc>
801044e4:	89 c3                	mov    %eax,%ebx

    num = curproc->tf->eax;
801044e6:	8b 70 18             	mov    0x18(%eax),%esi
801044e9:	8b 46 1c             	mov    0x1c(%esi),%eax
    if (num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801044ec:	8d 50 ff             	lea    -0x1(%eax),%edx
801044ef:	83 fa 1a             	cmp    $0x1a,%edx
801044f2:	77 12                	ja     80104506 <syscall+0x2c>
801044f4:	8b 14 85 c0 73 10 80 	mov    -0x7fef8c40(,%eax,4),%edx
801044fb:	85 d2                	test   %edx,%edx
801044fd:	74 07                	je     80104506 <syscall+0x2c>
        curproc->tf->eax = syscalls[num]();
801044ff:	ff d2                	call   *%edx
80104501:	89 46 1c             	mov    %eax,0x1c(%esi)
80104504:	eb 1f                	jmp    80104525 <syscall+0x4b>
    } else {
        cprintf("%d %s: unknown sys call %d\n",
80104506:	50                   	push   %eax
                curproc->pid, curproc->name, num);
80104507:	8d 43 6c             	lea    0x6c(%ebx),%eax

    num = curproc->tf->eax;
    if (num > 0 && num < NELEM(syscalls) && syscalls[num]) {
        curproc->tf->eax = syscalls[num]();
    } else {
        cprintf("%d %s: unknown sys call %d\n",
8010450a:	50                   	push   %eax
8010450b:	ff 73 10             	pushl  0x10(%ebx)
8010450e:	68 95 73 10 80       	push   $0x80107395
80104513:	e8 d1 c0 ff ff       	call   801005e9 <cprintf>
                curproc->pid, curproc->name, num);
        curproc->tf->eax = -1;
80104518:	8b 43 18             	mov    0x18(%ebx),%eax
8010451b:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
80104522:	83 c4 10             	add    $0x10,%esp
    }
}
80104525:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104528:	5b                   	pop    %ebx
80104529:	5e                   	pop    %esi
8010452a:	5d                   	pop    %ebp
8010452b:	c3                   	ret    

8010452c <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
8010452c:	55                   	push   %ebp
8010452d:	89 e5                	mov    %esp,%ebp
8010452f:	56                   	push   %esi
80104530:	53                   	push   %ebx
80104531:	83 ec 18             	sub    $0x18,%esp
80104534:	89 d6                	mov    %edx,%esi
80104536:	89 cb                	mov    %ecx,%ebx
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104538:	8d 55 f4             	lea    -0xc(%ebp),%edx
8010453b:	52                   	push   %edx
8010453c:	50                   	push   %eax
8010453d:	e8 d6 fe ff ff       	call   80104418 <argint>
80104542:	83 c4 10             	add    $0x10,%esp
80104545:	85 c0                	test   %eax,%eax
80104547:	78 29                	js     80104572 <argfd+0x46>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104549:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010454d:	77 2a                	ja     80104579 <argfd+0x4d>
8010454f:	e8 46 ee ff ff       	call   8010339a <myproc>
80104554:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104557:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
8010455b:	85 c0                	test   %eax,%eax
8010455d:	74 21                	je     80104580 <argfd+0x54>
    return -1;
  if(pfd)
8010455f:	85 f6                	test   %esi,%esi
80104561:	74 02                	je     80104565 <argfd+0x39>
    *pfd = fd;
80104563:	89 16                	mov    %edx,(%esi)
  if(pf)
80104565:	85 db                	test   %ebx,%ebx
80104567:	74 1e                	je     80104587 <argfd+0x5b>
    *pf = f;
80104569:	89 03                	mov    %eax,(%ebx)
  return 0;
8010456b:	b8 00 00 00 00       	mov    $0x0,%eax
80104570:	eb 1a                	jmp    8010458c <argfd+0x60>
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
80104572:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104577:	eb 13                	jmp    8010458c <argfd+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    return -1;
80104579:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010457e:	eb 0c                	jmp    8010458c <argfd+0x60>
80104580:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104585:	eb 05                	jmp    8010458c <argfd+0x60>
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
80104587:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010458c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010458f:	5b                   	pop    %ebx
80104590:	5e                   	pop    %esi
80104591:	5d                   	pop    %ebp
80104592:	c3                   	ret    

80104593 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80104593:	55                   	push   %ebp
80104594:	89 e5                	mov    %esp,%ebp
80104596:	53                   	push   %ebx
80104597:	83 ec 04             	sub    $0x4,%esp
8010459a:	89 c3                	mov    %eax,%ebx
  int fd;
  struct proc *curproc = myproc();
8010459c:	e8 f9 ed ff ff       	call   8010339a <myproc>

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
801045a1:	83 78 28 00          	cmpl   $0x0,0x28(%eax)
801045a5:	74 0e                	je     801045b5 <fdalloc+0x22>
801045a7:	ba 01 00 00 00       	mov    $0x1,%edx
801045ac:	83 7c 90 28 00       	cmpl   $0x0,0x28(%eax,%edx,4)
801045b1:	75 0f                	jne    801045c2 <fdalloc+0x2f>
801045b3:	eb 05                	jmp    801045ba <fdalloc+0x27>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
801045b5:	ba 00 00 00 00       	mov    $0x0,%edx
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
801045ba:	89 5c 90 28          	mov    %ebx,0x28(%eax,%edx,4)
      return fd;
801045be:	89 d0                	mov    %edx,%eax
801045c0:	eb 0d                	jmp    801045cf <fdalloc+0x3c>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
801045c2:	83 c2 01             	add    $0x1,%edx
801045c5:	83 fa 10             	cmp    $0x10,%edx
801045c8:	75 e2                	jne    801045ac <fdalloc+0x19>
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
801045ca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801045cf:	83 c4 04             	add    $0x4,%esp
801045d2:	5b                   	pop    %ebx
801045d3:	5d                   	pop    %ebp
801045d4:	c3                   	ret    

801045d5 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801045d5:	55                   	push   %ebp
801045d6:	89 e5                	mov    %esp,%ebp
801045d8:	57                   	push   %edi
801045d9:	56                   	push   %esi
801045da:	53                   	push   %ebx
801045db:	83 ec 44             	sub    $0x44,%esp
801045de:	89 55 c4             	mov    %edx,-0x3c(%ebp)
801045e1:	89 4d c0             	mov    %ecx,-0x40(%ebp)
801045e4:	8b 7d 08             	mov    0x8(%ebp),%edi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801045e7:	8d 55 d6             	lea    -0x2a(%ebp),%edx
801045ea:	52                   	push   %edx
801045eb:	50                   	push   %eax
801045ec:	e8 b9 d6 ff ff       	call   80101caa <nameiparent>
801045f1:	83 c4 10             	add    $0x10,%esp
801045f4:	85 c0                	test   %eax,%eax
801045f6:	0f 84 34 01 00 00    	je     80104730 <create+0x15b>
801045fc:	89 c3                	mov    %eax,%ebx
    return 0;
  ilock(dp);
801045fe:	83 ec 0c             	sub    $0xc,%esp
80104601:	50                   	push   %eax
80104602:	e8 f3 ce ff ff       	call   801014fa <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104607:	83 c4 0c             	add    $0xc,%esp
8010460a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010460d:	50                   	push   %eax
8010460e:	8d 45 d6             	lea    -0x2a(%ebp),%eax
80104611:	50                   	push   %eax
80104612:	53                   	push   %ebx
80104613:	e8 b6 d3 ff ff       	call   801019ce <dirlookup>
80104618:	89 c6                	mov    %eax,%esi
8010461a:	83 c4 10             	add    $0x10,%esp
8010461d:	85 c0                	test   %eax,%eax
8010461f:	74 3e                	je     8010465f <create+0x8a>
    iunlockput(dp);
80104621:	83 ec 0c             	sub    $0xc,%esp
80104624:	53                   	push   %ebx
80104625:	e8 13 d1 ff ff       	call   8010173d <iunlockput>
    ilock(ip);
8010462a:	89 34 24             	mov    %esi,(%esp)
8010462d:	e8 c8 ce ff ff       	call   801014fa <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104632:	83 c4 10             	add    $0x10,%esp
80104635:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
8010463a:	75 0d                	jne    80104649 <create+0x74>
      return ip;
8010463c:	89 f0                	mov    %esi,%eax
  ilock(dp);

  if((ip = dirlookup(dp, name, &off)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
8010463e:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104643:	0f 84 ec 00 00 00    	je     80104735 <create+0x160>
      return ip;
    iunlockput(ip);
80104649:	83 ec 0c             	sub    $0xc,%esp
8010464c:	56                   	push   %esi
8010464d:	e8 eb d0 ff ff       	call   8010173d <iunlockput>
    return 0;
80104652:	83 c4 10             	add    $0x10,%esp
80104655:	b8 00 00 00 00       	mov    $0x0,%eax
8010465a:	e9 d6 00 00 00       	jmp    80104735 <create+0x160>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
8010465f:	83 ec 08             	sub    $0x8,%esp
80104662:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104666:	50                   	push   %eax
80104667:	ff 33                	pushl  (%ebx)
80104669:	e8 39 cd ff ff       	call   801013a7 <ialloc>
8010466e:	89 c6                	mov    %eax,%esi
80104670:	83 c4 10             	add    $0x10,%esp
80104673:	85 c0                	test   %eax,%eax
80104675:	75 0d                	jne    80104684 <create+0xaf>
    panic("create: ialloc");
80104677:	83 ec 0c             	sub    $0xc,%esp
8010467a:	68 30 74 10 80       	push   $0x80107430
8010467f:	e8 c9 bc ff ff       	call   8010034d <panic>

  ilock(ip);
80104684:	83 ec 0c             	sub    $0xc,%esp
80104687:	50                   	push   %eax
80104688:	e8 6d ce ff ff       	call   801014fa <ilock>
  ip->major = major;
8010468d:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104691:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104695:	66 89 7e 54          	mov    %di,0x54(%esi)
  ip->nlink = 1;
80104699:	66 c7 46 56 01 00    	movw   $0x1,0x56(%esi)
  iupdate(ip);
8010469f:	89 34 24             	mov    %esi,(%esp)
801046a2:	e8 a9 cd ff ff       	call   80101450 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
801046a7:	83 c4 10             	add    $0x10,%esp
801046aa:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
801046af:	75 4b                	jne    801046fc <create+0x127>
    dp->nlink++;  // for ".."
801046b1:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
801046b6:	83 ec 0c             	sub    $0xc,%esp
801046b9:	53                   	push   %ebx
801046ba:	e8 91 cd ff ff       	call   80101450 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801046bf:	83 c4 0c             	add    $0xc,%esp
801046c2:	ff 76 04             	pushl  0x4(%esi)
801046c5:	68 40 74 10 80       	push   $0x80107440
801046ca:	56                   	push   %esi
801046cb:	e8 0b d5 ff ff       	call   80101bdb <dirlink>
801046d0:	83 c4 10             	add    $0x10,%esp
801046d3:	85 c0                	test   %eax,%eax
801046d5:	78 18                	js     801046ef <create+0x11a>
801046d7:	83 ec 04             	sub    $0x4,%esp
801046da:	ff 73 04             	pushl  0x4(%ebx)
801046dd:	68 3f 74 10 80       	push   $0x8010743f
801046e2:	56                   	push   %esi
801046e3:	e8 f3 d4 ff ff       	call   80101bdb <dirlink>
801046e8:	83 c4 10             	add    $0x10,%esp
801046eb:	85 c0                	test   %eax,%eax
801046ed:	79 0d                	jns    801046fc <create+0x127>
      panic("create dots");
801046ef:	83 ec 0c             	sub    $0xc,%esp
801046f2:	68 42 74 10 80       	push   $0x80107442
801046f7:	e8 51 bc ff ff       	call   8010034d <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
801046fc:	83 ec 04             	sub    $0x4,%esp
801046ff:	ff 76 04             	pushl  0x4(%esi)
80104702:	8d 45 d6             	lea    -0x2a(%ebp),%eax
80104705:	50                   	push   %eax
80104706:	53                   	push   %ebx
80104707:	e8 cf d4 ff ff       	call   80101bdb <dirlink>
8010470c:	83 c4 10             	add    $0x10,%esp
8010470f:	85 c0                	test   %eax,%eax
80104711:	79 0d                	jns    80104720 <create+0x14b>
    panic("create: dirlink");
80104713:	83 ec 0c             	sub    $0xc,%esp
80104716:	68 4e 74 10 80       	push   $0x8010744e
8010471b:	e8 2d bc ff ff       	call   8010034d <panic>

  iunlockput(dp);
80104720:	83 ec 0c             	sub    $0xc,%esp
80104723:	53                   	push   %ebx
80104724:	e8 14 d0 ff ff       	call   8010173d <iunlockput>

  return ip;
80104729:	83 c4 10             	add    $0x10,%esp
8010472c:	89 f0                	mov    %esi,%eax
8010472e:	eb 05                	jmp    80104735 <create+0x160>
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;
80104730:	b8 00 00 00 00       	mov    $0x0,%eax
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104735:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104738:	5b                   	pop    %ebx
80104739:	5e                   	pop    %esi
8010473a:	5f                   	pop    %edi
8010473b:	5d                   	pop    %ebp
8010473c:	c3                   	ret    

8010473d <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
8010473d:	55                   	push   %ebp
8010473e:	89 e5                	mov    %esp,%ebp
80104740:	53                   	push   %ebx
80104741:	83 ec 14             	sub    $0x14,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104744:	8d 4d f4             	lea    -0xc(%ebp),%ecx
80104747:	ba 00 00 00 00       	mov    $0x0,%edx
8010474c:	b8 00 00 00 00       	mov    $0x0,%eax
80104751:	e8 d6 fd ff ff       	call   8010452c <argfd>
80104756:	85 c0                	test   %eax,%eax
80104758:	78 20                	js     8010477a <sys_dup+0x3d>
    return -1;
  if((fd=fdalloc(f)) < 0)
8010475a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010475d:	e8 31 fe ff ff       	call   80104593 <fdalloc>
80104762:	89 c3                	mov    %eax,%ebx
80104764:	85 c0                	test   %eax,%eax
80104766:	78 19                	js     80104781 <sys_dup+0x44>
    return -1;
  filedup(f);
80104768:	83 ec 0c             	sub    $0xc,%esp
8010476b:	ff 75 f4             	pushl  -0xc(%ebp)
8010476e:	e8 9e c5 ff ff       	call   80100d11 <filedup>
  return fd;
80104773:	83 c4 10             	add    $0x10,%esp
80104776:	89 d8                	mov    %ebx,%eax
80104778:	eb 0c                	jmp    80104786 <sys_dup+0x49>
{
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
8010477a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010477f:	eb 05                	jmp    80104786 <sys_dup+0x49>
  if((fd=fdalloc(f)) < 0)
    return -1;
80104781:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  filedup(f);
  return fd;
}
80104786:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104789:	c9                   	leave  
8010478a:	c3                   	ret    

8010478b <sys_read>:

int
sys_read(void)
{
8010478b:	55                   	push   %ebp
8010478c:	89 e5                	mov    %esp,%ebp
8010478e:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104791:	8d 4d f4             	lea    -0xc(%ebp),%ecx
80104794:	ba 00 00 00 00       	mov    $0x0,%edx
80104799:	b8 00 00 00 00       	mov    $0x0,%eax
8010479e:	e8 89 fd ff ff       	call   8010452c <argfd>
801047a3:	85 c0                	test   %eax,%eax
801047a5:	78 43                	js     801047ea <sys_read+0x5f>
801047a7:	83 ec 08             	sub    $0x8,%esp
801047aa:	8d 45 f0             	lea    -0x10(%ebp),%eax
801047ad:	50                   	push   %eax
801047ae:	6a 02                	push   $0x2
801047b0:	e8 63 fc ff ff       	call   80104418 <argint>
801047b5:	83 c4 10             	add    $0x10,%esp
801047b8:	85 c0                	test   %eax,%eax
801047ba:	78 35                	js     801047f1 <sys_read+0x66>
801047bc:	83 ec 04             	sub    $0x4,%esp
801047bf:	ff 75 f0             	pushl  -0x10(%ebp)
801047c2:	8d 45 ec             	lea    -0x14(%ebp),%eax
801047c5:	50                   	push   %eax
801047c6:	6a 01                	push   $0x1
801047c8:	e8 71 fc ff ff       	call   8010443e <argptr>
801047cd:	83 c4 10             	add    $0x10,%esp
801047d0:	85 c0                	test   %eax,%eax
801047d2:	78 24                	js     801047f8 <sys_read+0x6d>
    return -1;
  return fileread(f, p, n);
801047d4:	83 ec 04             	sub    $0x4,%esp
801047d7:	ff 75 f0             	pushl  -0x10(%ebp)
801047da:	ff 75 ec             	pushl  -0x14(%ebp)
801047dd:	ff 75 f4             	pushl  -0xc(%ebp)
801047e0:	e8 6d c6 ff ff       	call   80100e52 <fileread>
801047e5:	83 c4 10             	add    $0x10,%esp
801047e8:	eb 13                	jmp    801047fd <sys_read+0x72>
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
801047ea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801047ef:	eb 0c                	jmp    801047fd <sys_read+0x72>
801047f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801047f6:	eb 05                	jmp    801047fd <sys_read+0x72>
801047f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fileread(f, p, n);
}
801047fd:	c9                   	leave  
801047fe:	c3                   	ret    

801047ff <sys_write>:

int
sys_write(void)
{
801047ff:	55                   	push   %ebp
80104800:	89 e5                	mov    %esp,%ebp
80104802:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104805:	8d 4d f4             	lea    -0xc(%ebp),%ecx
80104808:	ba 00 00 00 00       	mov    $0x0,%edx
8010480d:	b8 00 00 00 00       	mov    $0x0,%eax
80104812:	e8 15 fd ff ff       	call   8010452c <argfd>
80104817:	85 c0                	test   %eax,%eax
80104819:	78 43                	js     8010485e <sys_write+0x5f>
8010481b:	83 ec 08             	sub    $0x8,%esp
8010481e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104821:	50                   	push   %eax
80104822:	6a 02                	push   $0x2
80104824:	e8 ef fb ff ff       	call   80104418 <argint>
80104829:	83 c4 10             	add    $0x10,%esp
8010482c:	85 c0                	test   %eax,%eax
8010482e:	78 35                	js     80104865 <sys_write+0x66>
80104830:	83 ec 04             	sub    $0x4,%esp
80104833:	ff 75 f0             	pushl  -0x10(%ebp)
80104836:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104839:	50                   	push   %eax
8010483a:	6a 01                	push   $0x1
8010483c:	e8 fd fb ff ff       	call   8010443e <argptr>
80104841:	83 c4 10             	add    $0x10,%esp
80104844:	85 c0                	test   %eax,%eax
80104846:	78 24                	js     8010486c <sys_write+0x6d>
    return -1;
  return filewrite(f, p, n);
80104848:	83 ec 04             	sub    $0x4,%esp
8010484b:	ff 75 f0             	pushl  -0x10(%ebp)
8010484e:	ff 75 ec             	pushl  -0x14(%ebp)
80104851:	ff 75 f4             	pushl  -0xc(%ebp)
80104854:	e8 7c c6 ff ff       	call   80100ed5 <filewrite>
80104859:	83 c4 10             	add    $0x10,%esp
8010485c:	eb 13                	jmp    80104871 <sys_write+0x72>
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
8010485e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104863:	eb 0c                	jmp    80104871 <sys_write+0x72>
80104865:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010486a:	eb 05                	jmp    80104871 <sys_write+0x72>
8010486c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filewrite(f, p, n);
}
80104871:	c9                   	leave  
80104872:	c3                   	ret    

80104873 <sys_close>:

int
sys_close(void)
{
80104873:	55                   	push   %ebp
80104874:	89 e5                	mov    %esp,%ebp
80104876:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80104879:	8d 4d f0             	lea    -0x10(%ebp),%ecx
8010487c:	8d 55 f4             	lea    -0xc(%ebp),%edx
8010487f:	b8 00 00 00 00       	mov    $0x0,%eax
80104884:	e8 a3 fc ff ff       	call   8010452c <argfd>
80104889:	85 c0                	test   %eax,%eax
8010488b:	78 25                	js     801048b2 <sys_close+0x3f>
    return -1;
  myproc()->ofile[fd] = 0;
8010488d:	e8 08 eb ff ff       	call   8010339a <myproc>
80104892:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104895:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
8010489c:	00 
  fileclose(f);
8010489d:	83 ec 0c             	sub    $0xc,%esp
801048a0:	ff 75 f0             	pushl  -0x10(%ebp)
801048a3:	e8 ae c4 ff ff       	call   80100d56 <fileclose>
  return 0;
801048a8:	83 c4 10             	add    $0x10,%esp
801048ab:	b8 00 00 00 00       	mov    $0x0,%eax
801048b0:	eb 05                	jmp    801048b7 <sys_close+0x44>
{
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
801048b2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  myproc()->ofile[fd] = 0;
  fileclose(f);
  return 0;
}
801048b7:	c9                   	leave  
801048b8:	c3                   	ret    

801048b9 <sys_fstat>:

int
sys_fstat(void)
{
801048b9:	55                   	push   %ebp
801048ba:	89 e5                	mov    %esp,%ebp
801048bc:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801048bf:	8d 4d f4             	lea    -0xc(%ebp),%ecx
801048c2:	ba 00 00 00 00       	mov    $0x0,%edx
801048c7:	b8 00 00 00 00       	mov    $0x0,%eax
801048cc:	e8 5b fc ff ff       	call   8010452c <argfd>
801048d1:	85 c0                	test   %eax,%eax
801048d3:	78 2a                	js     801048ff <sys_fstat+0x46>
801048d5:	83 ec 04             	sub    $0x4,%esp
801048d8:	6a 14                	push   $0x14
801048da:	8d 45 f0             	lea    -0x10(%ebp),%eax
801048dd:	50                   	push   %eax
801048de:	6a 01                	push   $0x1
801048e0:	e8 59 fb ff ff       	call   8010443e <argptr>
801048e5:	83 c4 10             	add    $0x10,%esp
801048e8:	85 c0                	test   %eax,%eax
801048ea:	78 1a                	js     80104906 <sys_fstat+0x4d>
    return -1;
  return filestat(f, st);
801048ec:	83 ec 08             	sub    $0x8,%esp
801048ef:	ff 75 f0             	pushl  -0x10(%ebp)
801048f2:	ff 75 f4             	pushl  -0xc(%ebp)
801048f5:	e8 11 c5 ff ff       	call   80100e0b <filestat>
801048fa:	83 c4 10             	add    $0x10,%esp
801048fd:	eb 0c                	jmp    8010490b <sys_fstat+0x52>
{
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
    return -1;
801048ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104904:	eb 05                	jmp    8010490b <sys_fstat+0x52>
80104906:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filestat(f, st);
}
8010490b:	c9                   	leave  
8010490c:	c3                   	ret    

8010490d <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
8010490d:	55                   	push   %ebp
8010490e:	89 e5                	mov    %esp,%ebp
80104910:	56                   	push   %esi
80104911:	53                   	push   %ebx
80104912:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104915:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104918:	50                   	push   %eax
80104919:	6a 00                	push   $0x0
8010491b:	e8 87 fb ff ff       	call   801044a7 <argstr>
80104920:	83 c4 10             	add    $0x10,%esp
80104923:	85 c0                	test   %eax,%eax
80104925:	0f 88 21 01 00 00    	js     80104a4c <sys_link+0x13f>
8010492b:	83 ec 08             	sub    $0x8,%esp
8010492e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104931:	50                   	push   %eax
80104932:	6a 01                	push   $0x1
80104934:	e8 6e fb ff ff       	call   801044a7 <argstr>
80104939:	83 c4 10             	add    $0x10,%esp
8010493c:	85 c0                	test   %eax,%eax
8010493e:	0f 88 0f 01 00 00    	js     80104a53 <sys_link+0x146>
    return -1;

  begin_op();
80104944:	e8 67 de ff ff       	call   801027b0 <begin_op>
  if((ip = namei(old)) == 0){
80104949:	83 ec 0c             	sub    $0xc,%esp
8010494c:	ff 75 e0             	pushl  -0x20(%ebp)
8010494f:	e8 3e d3 ff ff       	call   80101c92 <namei>
80104954:	89 c3                	mov    %eax,%ebx
80104956:	83 c4 10             	add    $0x10,%esp
80104959:	85 c0                	test   %eax,%eax
8010495b:	75 0f                	jne    8010496c <sys_link+0x5f>
    end_op();
8010495d:	e8 c8 de ff ff       	call   8010282a <end_op>
    return -1;
80104962:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104967:	e9 ec 00 00 00       	jmp    80104a58 <sys_link+0x14b>
  }

  ilock(ip);
8010496c:	83 ec 0c             	sub    $0xc,%esp
8010496f:	50                   	push   %eax
80104970:	e8 85 cb ff ff       	call   801014fa <ilock>
  if(ip->type == T_DIR){
80104975:	83 c4 10             	add    $0x10,%esp
80104978:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010497d:	75 1b                	jne    8010499a <sys_link+0x8d>
    iunlockput(ip);
8010497f:	83 ec 0c             	sub    $0xc,%esp
80104982:	53                   	push   %ebx
80104983:	e8 b5 cd ff ff       	call   8010173d <iunlockput>
    end_op();
80104988:	e8 9d de ff ff       	call   8010282a <end_op>
    return -1;
8010498d:	83 c4 10             	add    $0x10,%esp
80104990:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104995:	e9 be 00 00 00       	jmp    80104a58 <sys_link+0x14b>
  }

  ip->nlink++;
8010499a:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
8010499f:	83 ec 0c             	sub    $0xc,%esp
801049a2:	53                   	push   %ebx
801049a3:	e8 a8 ca ff ff       	call   80101450 <iupdate>
  iunlock(ip);
801049a8:	89 1c 24             	mov    %ebx,(%esp)
801049ab:	e8 0c cc ff ff       	call   801015bc <iunlock>

  if((dp = nameiparent(new, name)) == 0)
801049b0:	83 c4 08             	add    $0x8,%esp
801049b3:	8d 45 ea             	lea    -0x16(%ebp),%eax
801049b6:	50                   	push   %eax
801049b7:	ff 75 e4             	pushl  -0x1c(%ebp)
801049ba:	e8 eb d2 ff ff       	call   80101caa <nameiparent>
801049bf:	89 c6                	mov    %eax,%esi
801049c1:	83 c4 10             	add    $0x10,%esp
801049c4:	85 c0                	test   %eax,%eax
801049c6:	74 57                	je     80104a1f <sys_link+0x112>
    goto bad;
  ilock(dp);
801049c8:	83 ec 0c             	sub    $0xc,%esp
801049cb:	50                   	push   %eax
801049cc:	e8 29 cb ff ff       	call   801014fa <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801049d1:	83 c4 10             	add    $0x10,%esp
801049d4:	8b 03                	mov    (%ebx),%eax
801049d6:	39 06                	cmp    %eax,(%esi)
801049d8:	75 17                	jne    801049f1 <sys_link+0xe4>
801049da:	83 ec 04             	sub    $0x4,%esp
801049dd:	ff 73 04             	pushl  0x4(%ebx)
801049e0:	8d 45 ea             	lea    -0x16(%ebp),%eax
801049e3:	50                   	push   %eax
801049e4:	56                   	push   %esi
801049e5:	e8 f1 d1 ff ff       	call   80101bdb <dirlink>
801049ea:	83 c4 10             	add    $0x10,%esp
801049ed:	85 c0                	test   %eax,%eax
801049ef:	79 0e                	jns    801049ff <sys_link+0xf2>
    iunlockput(dp);
801049f1:	83 ec 0c             	sub    $0xc,%esp
801049f4:	56                   	push   %esi
801049f5:	e8 43 cd ff ff       	call   8010173d <iunlockput>
    goto bad;
801049fa:	83 c4 10             	add    $0x10,%esp
801049fd:	eb 20                	jmp    80104a1f <sys_link+0x112>
  }
  iunlockput(dp);
801049ff:	83 ec 0c             	sub    $0xc,%esp
80104a02:	56                   	push   %esi
80104a03:	e8 35 cd ff ff       	call   8010173d <iunlockput>
  iput(ip);
80104a08:	89 1c 24             	mov    %ebx,(%esp)
80104a0b:	e8 f1 cb ff ff       	call   80101601 <iput>

  end_op();
80104a10:	e8 15 de ff ff       	call   8010282a <end_op>

  return 0;
80104a15:	83 c4 10             	add    $0x10,%esp
80104a18:	b8 00 00 00 00       	mov    $0x0,%eax
80104a1d:	eb 39                	jmp    80104a58 <sys_link+0x14b>

bad:
  ilock(ip);
80104a1f:	83 ec 0c             	sub    $0xc,%esp
80104a22:	53                   	push   %ebx
80104a23:	e8 d2 ca ff ff       	call   801014fa <ilock>
  ip->nlink--;
80104a28:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104a2d:	89 1c 24             	mov    %ebx,(%esp)
80104a30:	e8 1b ca ff ff       	call   80101450 <iupdate>
  iunlockput(ip);
80104a35:	89 1c 24             	mov    %ebx,(%esp)
80104a38:	e8 00 cd ff ff       	call   8010173d <iunlockput>
  end_op();
80104a3d:	e8 e8 dd ff ff       	call   8010282a <end_op>
  return -1;
80104a42:	83 c4 10             	add    $0x10,%esp
80104a45:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a4a:	eb 0c                	jmp    80104a58 <sys_link+0x14b>
{
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
    return -1;
80104a4c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a51:	eb 05                	jmp    80104a58 <sys_link+0x14b>
80104a53:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80104a58:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a5b:	5b                   	pop    %ebx
80104a5c:	5e                   	pop    %esi
80104a5d:	5d                   	pop    %ebp
80104a5e:	c3                   	ret    

80104a5f <sys_unlink>:
}

//PAGEBREAK!
int
sys_unlink(void)
{
80104a5f:	55                   	push   %ebp
80104a60:	89 e5                	mov    %esp,%ebp
80104a62:	57                   	push   %edi
80104a63:	56                   	push   %esi
80104a64:	53                   	push   %ebx
80104a65:	83 ec 54             	sub    $0x54,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80104a68:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104a6b:	50                   	push   %eax
80104a6c:	6a 00                	push   $0x0
80104a6e:	e8 34 fa ff ff       	call   801044a7 <argstr>
80104a73:	83 c4 10             	add    $0x10,%esp
80104a76:	85 c0                	test   %eax,%eax
80104a78:	0f 88 80 01 00 00    	js     80104bfe <sys_unlink+0x19f>
    return -1;

  begin_op();
80104a7e:	e8 2d dd ff ff       	call   801027b0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104a83:	83 ec 08             	sub    $0x8,%esp
80104a86:	8d 45 ca             	lea    -0x36(%ebp),%eax
80104a89:	50                   	push   %eax
80104a8a:	ff 75 c4             	pushl  -0x3c(%ebp)
80104a8d:	e8 18 d2 ff ff       	call   80101caa <nameiparent>
80104a92:	89 c7                	mov    %eax,%edi
80104a94:	83 c4 10             	add    $0x10,%esp
80104a97:	85 c0                	test   %eax,%eax
80104a99:	75 0f                	jne    80104aaa <sys_unlink+0x4b>
    end_op();
80104a9b:	e8 8a dd ff ff       	call   8010282a <end_op>
    return -1;
80104aa0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104aa5:	e9 69 01 00 00       	jmp    80104c13 <sys_unlink+0x1b4>
  }

  ilock(dp);
80104aaa:	83 ec 0c             	sub    $0xc,%esp
80104aad:	50                   	push   %eax
80104aae:	e8 47 ca ff ff       	call   801014fa <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104ab3:	83 c4 08             	add    $0x8,%esp
80104ab6:	68 40 74 10 80       	push   $0x80107440
80104abb:	8d 45 ca             	lea    -0x36(%ebp),%eax
80104abe:	50                   	push   %eax
80104abf:	e8 f5 ce ff ff       	call   801019b9 <namecmp>
80104ac4:	83 c4 10             	add    $0x10,%esp
80104ac7:	85 c0                	test   %eax,%eax
80104ac9:	0f 84 17 01 00 00    	je     80104be6 <sys_unlink+0x187>
80104acf:	83 ec 08             	sub    $0x8,%esp
80104ad2:	68 3f 74 10 80       	push   $0x8010743f
80104ad7:	8d 45 ca             	lea    -0x36(%ebp),%eax
80104ada:	50                   	push   %eax
80104adb:	e8 d9 ce ff ff       	call   801019b9 <namecmp>
80104ae0:	83 c4 10             	add    $0x10,%esp
80104ae3:	85 c0                	test   %eax,%eax
80104ae5:	0f 84 fb 00 00 00    	je     80104be6 <sys_unlink+0x187>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80104aeb:	83 ec 04             	sub    $0x4,%esp
80104aee:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104af1:	50                   	push   %eax
80104af2:	8d 45 ca             	lea    -0x36(%ebp),%eax
80104af5:	50                   	push   %eax
80104af6:	57                   	push   %edi
80104af7:	e8 d2 ce ff ff       	call   801019ce <dirlookup>
80104afc:	89 c3                	mov    %eax,%ebx
80104afe:	83 c4 10             	add    $0x10,%esp
80104b01:	85 c0                	test   %eax,%eax
80104b03:	0f 84 dd 00 00 00    	je     80104be6 <sys_unlink+0x187>
    goto bad;
  ilock(ip);
80104b09:	83 ec 0c             	sub    $0xc,%esp
80104b0c:	50                   	push   %eax
80104b0d:	e8 e8 c9 ff ff       	call   801014fa <ilock>

  if(ip->nlink < 1)
80104b12:	83 c4 10             	add    $0x10,%esp
80104b15:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104b1a:	7f 0d                	jg     80104b29 <sys_unlink+0xca>
    panic("unlink: nlink < 1");
80104b1c:	83 ec 0c             	sub    $0xc,%esp
80104b1f:	68 5e 74 10 80       	push   $0x8010745e
80104b24:	e8 24 b8 ff ff       	call   8010034d <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80104b29:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104b2e:	75 40                	jne    80104b70 <sys_unlink+0x111>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104b30:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80104b34:	76 3a                	jbe    80104b70 <sys_unlink+0x111>
80104b36:	be 20 00 00 00       	mov    $0x20,%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104b3b:	6a 10                	push   $0x10
80104b3d:	56                   	push   %esi
80104b3e:	8d 45 b0             	lea    -0x50(%ebp),%eax
80104b41:	50                   	push   %eax
80104b42:	53                   	push   %ebx
80104b43:	e8 40 cc ff ff       	call   80101788 <readi>
80104b48:	83 c4 10             	add    $0x10,%esp
80104b4b:	83 f8 10             	cmp    $0x10,%eax
80104b4e:	74 0d                	je     80104b5d <sys_unlink+0xfe>
      panic("isdirempty: readi");
80104b50:	83 ec 0c             	sub    $0xc,%esp
80104b53:	68 70 74 10 80       	push   $0x80107470
80104b58:	e8 f0 b7 ff ff       	call   8010034d <panic>
    if(de.inum != 0)
80104b5d:	66 83 7d b0 00       	cmpw   $0x0,-0x50(%ebp)
80104b62:	0f 85 9d 00 00 00    	jne    80104c05 <sys_unlink+0x1a6>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104b68:	83 c6 10             	add    $0x10,%esi
80104b6b:	3b 73 58             	cmp    0x58(%ebx),%esi
80104b6e:	72 cb                	jb     80104b3b <sys_unlink+0xdc>
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
80104b70:	83 ec 04             	sub    $0x4,%esp
80104b73:	6a 10                	push   $0x10
80104b75:	6a 00                	push   $0x0
80104b77:	8d 75 d8             	lea    -0x28(%ebp),%esi
80104b7a:	56                   	push   %esi
80104b7b:	e8 f8 f5 ff ff       	call   80104178 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104b80:	6a 10                	push   $0x10
80104b82:	ff 75 c0             	pushl  -0x40(%ebp)
80104b85:	56                   	push   %esi
80104b86:	57                   	push   %edi
80104b87:	e8 ff cc ff ff       	call   8010188b <writei>
80104b8c:	83 c4 20             	add    $0x20,%esp
80104b8f:	83 f8 10             	cmp    $0x10,%eax
80104b92:	74 0d                	je     80104ba1 <sys_unlink+0x142>
    panic("unlink: writei");
80104b94:	83 ec 0c             	sub    $0xc,%esp
80104b97:	68 82 74 10 80       	push   $0x80107482
80104b9c:	e8 ac b7 ff ff       	call   8010034d <panic>
  if(ip->type == T_DIR){
80104ba1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104ba6:	75 11                	jne    80104bb9 <sys_unlink+0x15a>
    dp->nlink--;
80104ba8:	66 83 6f 56 01       	subw   $0x1,0x56(%edi)
    iupdate(dp);
80104bad:	83 ec 0c             	sub    $0xc,%esp
80104bb0:	57                   	push   %edi
80104bb1:	e8 9a c8 ff ff       	call   80101450 <iupdate>
80104bb6:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
80104bb9:	83 ec 0c             	sub    $0xc,%esp
80104bbc:	57                   	push   %edi
80104bbd:	e8 7b cb ff ff       	call   8010173d <iunlockput>

  ip->nlink--;
80104bc2:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104bc7:	89 1c 24             	mov    %ebx,(%esp)
80104bca:	e8 81 c8 ff ff       	call   80101450 <iupdate>
  iunlockput(ip);
80104bcf:	89 1c 24             	mov    %ebx,(%esp)
80104bd2:	e8 66 cb ff ff       	call   8010173d <iunlockput>

  end_op();
80104bd7:	e8 4e dc ff ff       	call   8010282a <end_op>

  return 0;
80104bdc:	83 c4 10             	add    $0x10,%esp
80104bdf:	b8 00 00 00 00       	mov    $0x0,%eax
80104be4:	eb 2d                	jmp    80104c13 <sys_unlink+0x1b4>

bad:
  iunlockput(dp);
80104be6:	83 ec 0c             	sub    $0xc,%esp
80104be9:	57                   	push   %edi
80104bea:	e8 4e cb ff ff       	call   8010173d <iunlockput>
  end_op();
80104bef:	e8 36 dc ff ff       	call   8010282a <end_op>
  return -1;
80104bf4:	83 c4 10             	add    $0x10,%esp
80104bf7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104bfc:	eb 15                	jmp    80104c13 <sys_unlink+0x1b4>
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
    return -1;
80104bfe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c03:	eb 0e                	jmp    80104c13 <sys_unlink+0x1b4>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
80104c05:	83 ec 0c             	sub    $0xc,%esp
80104c08:	53                   	push   %ebx
80104c09:	e8 2f cb ff ff       	call   8010173d <iunlockput>
    goto bad;
80104c0e:	83 c4 10             	add    $0x10,%esp
80104c11:	eb d3                	jmp    80104be6 <sys_unlink+0x187>

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80104c13:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c16:	5b                   	pop    %ebx
80104c17:	5e                   	pop    %esi
80104c18:	5f                   	pop    %edi
80104c19:	5d                   	pop    %ebp
80104c1a:	c3                   	ret    

80104c1b <sys_open>:
  return ip;
}

int
sys_open(void)
{
80104c1b:	55                   	push   %ebp
80104c1c:	89 e5                	mov    %esp,%ebp
80104c1e:	57                   	push   %edi
80104c1f:	56                   	push   %esi
80104c20:	53                   	push   %ebx
80104c21:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80104c24:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104c27:	50                   	push   %eax
80104c28:	6a 00                	push   $0x0
80104c2a:	e8 78 f8 ff ff       	call   801044a7 <argstr>
80104c2f:	83 c4 10             	add    $0x10,%esp
80104c32:	85 c0                	test   %eax,%eax
80104c34:	0f 88 14 01 00 00    	js     80104d4e <sys_open+0x133>
80104c3a:	83 ec 08             	sub    $0x8,%esp
80104c3d:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104c40:	50                   	push   %eax
80104c41:	6a 01                	push   $0x1
80104c43:	e8 d0 f7 ff ff       	call   80104418 <argint>
80104c48:	83 c4 10             	add    $0x10,%esp
80104c4b:	85 c0                	test   %eax,%eax
80104c4d:	0f 88 02 01 00 00    	js     80104d55 <sys_open+0x13a>
    return -1;

  begin_op();
80104c53:	e8 58 db ff ff       	call   801027b0 <begin_op>

  if(omode & O_CREATE){
80104c58:	f6 45 e1 02          	testb  $0x2,-0x1f(%ebp)
80104c5c:	74 2f                	je     80104c8d <sys_open+0x72>
    ip = create(path, T_FILE, 0, 0);
80104c5e:	83 ec 0c             	sub    $0xc,%esp
80104c61:	6a 00                	push   $0x0
80104c63:	b9 00 00 00 00       	mov    $0x0,%ecx
80104c68:	ba 02 00 00 00       	mov    $0x2,%edx
80104c6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104c70:	e8 60 f9 ff ff       	call   801045d5 <create>
80104c75:	89 c7                	mov    %eax,%edi
    if(ip == 0){
80104c77:	83 c4 10             	add    $0x10,%esp
80104c7a:	85 c0                	test   %eax,%eax
80104c7c:	75 66                	jne    80104ce4 <sys_open+0xc9>
      end_op();
80104c7e:	e8 a7 db ff ff       	call   8010282a <end_op>
      return -1;
80104c83:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c88:	e9 dd 00 00 00       	jmp    80104d6a <sys_open+0x14f>
    }
  } else {
    if((ip = namei(path)) == 0){
80104c8d:	83 ec 0c             	sub    $0xc,%esp
80104c90:	ff 75 e4             	pushl  -0x1c(%ebp)
80104c93:	e8 fa cf ff ff       	call   80101c92 <namei>
80104c98:	89 c7                	mov    %eax,%edi
80104c9a:	83 c4 10             	add    $0x10,%esp
80104c9d:	85 c0                	test   %eax,%eax
80104c9f:	75 0f                	jne    80104cb0 <sys_open+0x95>
      end_op();
80104ca1:	e8 84 db ff ff       	call   8010282a <end_op>
      return -1;
80104ca6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104cab:	e9 ba 00 00 00       	jmp    80104d6a <sys_open+0x14f>
    }
    ilock(ip);
80104cb0:	83 ec 0c             	sub    $0xc,%esp
80104cb3:	50                   	push   %eax
80104cb4:	e8 41 c8 ff ff       	call   801014fa <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80104cb9:	83 c4 10             	add    $0x10,%esp
80104cbc:	66 83 7f 50 01       	cmpw   $0x1,0x50(%edi)
80104cc1:	75 21                	jne    80104ce4 <sys_open+0xc9>
80104cc3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80104cc7:	74 1b                	je     80104ce4 <sys_open+0xc9>
      iunlockput(ip);
80104cc9:	83 ec 0c             	sub    $0xc,%esp
80104ccc:	57                   	push   %edi
80104ccd:	e8 6b ca ff ff       	call   8010173d <iunlockput>
      end_op();
80104cd2:	e8 53 db ff ff       	call   8010282a <end_op>
      return -1;
80104cd7:	83 c4 10             	add    $0x10,%esp
80104cda:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104cdf:	e9 86 00 00 00       	jmp    80104d6a <sys_open+0x14f>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80104ce4:	e8 b7 bf ff ff       	call   80100ca0 <filealloc>
80104ce9:	89 c3                	mov    %eax,%ebx
80104ceb:	85 c0                	test   %eax,%eax
80104ced:	74 0d                	je     80104cfc <sys_open+0xe1>
80104cef:	e8 9f f8 ff ff       	call   80104593 <fdalloc>
80104cf4:	89 c6                	mov    %eax,%esi
80104cf6:	85 c0                	test   %eax,%eax
80104cf8:	79 1a                	jns    80104d14 <sys_open+0xf9>
80104cfa:	eb 60                	jmp    80104d5c <sys_open+0x141>
    if(f)
      fileclose(f);
    iunlockput(ip);
80104cfc:	83 ec 0c             	sub    $0xc,%esp
80104cff:	57                   	push   %edi
80104d00:	e8 38 ca ff ff       	call   8010173d <iunlockput>
    end_op();
80104d05:	e8 20 db ff ff       	call   8010282a <end_op>
    return -1;
80104d0a:	83 c4 10             	add    $0x10,%esp
80104d0d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d12:	eb 56                	jmp    80104d6a <sys_open+0x14f>
  }
  iunlock(ip);
80104d14:	83 ec 0c             	sub    $0xc,%esp
80104d17:	57                   	push   %edi
80104d18:	e8 9f c8 ff ff       	call   801015bc <iunlock>
  end_op();
80104d1d:	e8 08 db ff ff       	call   8010282a <end_op>

  f->type = FD_INODE;
80104d22:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  f->ip = ip;
80104d28:	89 7b 10             	mov    %edi,0x10(%ebx)
  f->off = 0;
80104d2b:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  f->readable = !(omode & O_WRONLY);
80104d32:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104d35:	89 d0                	mov    %edx,%eax
80104d37:	83 f0 01             	xor    $0x1,%eax
80104d3a:	83 e0 01             	and    $0x1,%eax
80104d3d:	88 43 08             	mov    %al,0x8(%ebx)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80104d40:	83 c4 10             	add    $0x10,%esp
80104d43:	f6 c2 03             	test   $0x3,%dl
80104d46:	0f 95 43 09          	setne  0x9(%ebx)
  return fd;
80104d4a:	89 f0                	mov    %esi,%eax
80104d4c:	eb 1c                	jmp    80104d6a <sys_open+0x14f>
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
    return -1;
80104d4e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d53:	eb 15                	jmp    80104d6a <sys_open+0x14f>
80104d55:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d5a:	eb 0e                	jmp    80104d6a <sys_open+0x14f>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
80104d5c:	83 ec 0c             	sub    $0xc,%esp
80104d5f:	53                   	push   %ebx
80104d60:	e8 f1 bf ff ff       	call   80100d56 <fileclose>
80104d65:	83 c4 10             	add    $0x10,%esp
80104d68:	eb 92                	jmp    80104cfc <sys_open+0xe1>
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
80104d6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d6d:	5b                   	pop    %ebx
80104d6e:	5e                   	pop    %esi
80104d6f:	5f                   	pop    %edi
80104d70:	5d                   	pop    %ebp
80104d71:	c3                   	ret    

80104d72 <sys_mkdir>:

int
sys_mkdir(void)
{
80104d72:	55                   	push   %ebp
80104d73:	89 e5                	mov    %esp,%ebp
80104d75:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80104d78:	e8 33 da ff ff       	call   801027b0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80104d7d:	83 ec 08             	sub    $0x8,%esp
80104d80:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d83:	50                   	push   %eax
80104d84:	6a 00                	push   $0x0
80104d86:	e8 1c f7 ff ff       	call   801044a7 <argstr>
80104d8b:	83 c4 10             	add    $0x10,%esp
80104d8e:	85 c0                	test   %eax,%eax
80104d90:	78 1e                	js     80104db0 <sys_mkdir+0x3e>
80104d92:	83 ec 0c             	sub    $0xc,%esp
80104d95:	6a 00                	push   $0x0
80104d97:	b9 00 00 00 00       	mov    $0x0,%ecx
80104d9c:	ba 01 00 00 00       	mov    $0x1,%edx
80104da1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104da4:	e8 2c f8 ff ff       	call   801045d5 <create>
80104da9:	83 c4 10             	add    $0x10,%esp
80104dac:	85 c0                	test   %eax,%eax
80104dae:	75 0c                	jne    80104dbc <sys_mkdir+0x4a>
    end_op();
80104db0:	e8 75 da ff ff       	call   8010282a <end_op>
    return -1;
80104db5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104dba:	eb 16                	jmp    80104dd2 <sys_mkdir+0x60>
  }
  iunlockput(ip);
80104dbc:	83 ec 0c             	sub    $0xc,%esp
80104dbf:	50                   	push   %eax
80104dc0:	e8 78 c9 ff ff       	call   8010173d <iunlockput>
  end_op();
80104dc5:	e8 60 da ff ff       	call   8010282a <end_op>
  return 0;
80104dca:	83 c4 10             	add    $0x10,%esp
80104dcd:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104dd2:	c9                   	leave  
80104dd3:	c3                   	ret    

80104dd4 <sys_mknod>:

int
sys_mknod(void)
{
80104dd4:	55                   	push   %ebp
80104dd5:	89 e5                	mov    %esp,%ebp
80104dd7:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80104dda:	e8 d1 d9 ff ff       	call   801027b0 <begin_op>
  if((argstr(0, &path)) < 0 ||
80104ddf:	83 ec 08             	sub    $0x8,%esp
80104de2:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104de5:	50                   	push   %eax
80104de6:	6a 00                	push   $0x0
80104de8:	e8 ba f6 ff ff       	call   801044a7 <argstr>
80104ded:	83 c4 10             	add    $0x10,%esp
80104df0:	85 c0                	test   %eax,%eax
80104df2:	78 4a                	js     80104e3e <sys_mknod+0x6a>
     argint(1, &major) < 0 ||
80104df4:	83 ec 08             	sub    $0x8,%esp
80104df7:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104dfa:	50                   	push   %eax
80104dfb:	6a 01                	push   $0x1
80104dfd:	e8 16 f6 ff ff       	call   80104418 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
80104e02:	83 c4 10             	add    $0x10,%esp
80104e05:	85 c0                	test   %eax,%eax
80104e07:	78 35                	js     80104e3e <sys_mknod+0x6a>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80104e09:	83 ec 08             	sub    $0x8,%esp
80104e0c:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104e0f:	50                   	push   %eax
80104e10:	6a 02                	push   $0x2
80104e12:	e8 01 f6 ff ff       	call   80104418 <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80104e17:	83 c4 10             	add    $0x10,%esp
80104e1a:	85 c0                	test   %eax,%eax
80104e1c:	78 20                	js     80104e3e <sys_mknod+0x6a>
     argint(2, &minor) < 0 ||
80104e1e:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80104e22:	83 ec 0c             	sub    $0xc,%esp
80104e25:	0f bf 45 ec          	movswl -0x14(%ebp),%eax
80104e29:	50                   	push   %eax
80104e2a:	ba 03 00 00 00       	mov    $0x3,%edx
80104e2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e32:	e8 9e f7 ff ff       	call   801045d5 <create>
80104e37:	83 c4 10             	add    $0x10,%esp
80104e3a:	85 c0                	test   %eax,%eax
80104e3c:	75 0c                	jne    80104e4a <sys_mknod+0x76>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80104e3e:	e8 e7 d9 ff ff       	call   8010282a <end_op>
    return -1;
80104e43:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e48:	eb 16                	jmp    80104e60 <sys_mknod+0x8c>
  }
  iunlockput(ip);
80104e4a:	83 ec 0c             	sub    $0xc,%esp
80104e4d:	50                   	push   %eax
80104e4e:	e8 ea c8 ff ff       	call   8010173d <iunlockput>
  end_op();
80104e53:	e8 d2 d9 ff ff       	call   8010282a <end_op>
  return 0;
80104e58:	83 c4 10             	add    $0x10,%esp
80104e5b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104e60:	c9                   	leave  
80104e61:	c3                   	ret    

80104e62 <sys_chdir>:

int
sys_chdir(void)
{
80104e62:	55                   	push   %ebp
80104e63:	89 e5                	mov    %esp,%ebp
80104e65:	56                   	push   %esi
80104e66:	53                   	push   %ebx
80104e67:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80104e6a:	e8 2b e5 ff ff       	call   8010339a <myproc>
80104e6f:	89 c6                	mov    %eax,%esi
  
  begin_op();
80104e71:	e8 3a d9 ff ff       	call   801027b0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80104e76:	83 ec 08             	sub    $0x8,%esp
80104e79:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e7c:	50                   	push   %eax
80104e7d:	6a 00                	push   $0x0
80104e7f:	e8 23 f6 ff ff       	call   801044a7 <argstr>
80104e84:	83 c4 10             	add    $0x10,%esp
80104e87:	85 c0                	test   %eax,%eax
80104e89:	78 14                	js     80104e9f <sys_chdir+0x3d>
80104e8b:	83 ec 0c             	sub    $0xc,%esp
80104e8e:	ff 75 f4             	pushl  -0xc(%ebp)
80104e91:	e8 fc cd ff ff       	call   80101c92 <namei>
80104e96:	89 c3                	mov    %eax,%ebx
80104e98:	83 c4 10             	add    $0x10,%esp
80104e9b:	85 c0                	test   %eax,%eax
80104e9d:	75 0c                	jne    80104eab <sys_chdir+0x49>
    end_op();
80104e9f:	e8 86 d9 ff ff       	call   8010282a <end_op>
    return -1;
80104ea4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ea9:	eb 4f                	jmp    80104efa <sys_chdir+0x98>
  }
  ilock(ip);
80104eab:	83 ec 0c             	sub    $0xc,%esp
80104eae:	50                   	push   %eax
80104eaf:	e8 46 c6 ff ff       	call   801014fa <ilock>
  if(ip->type != T_DIR){
80104eb4:	83 c4 10             	add    $0x10,%esp
80104eb7:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104ebc:	74 18                	je     80104ed6 <sys_chdir+0x74>
    iunlockput(ip);
80104ebe:	83 ec 0c             	sub    $0xc,%esp
80104ec1:	53                   	push   %ebx
80104ec2:	e8 76 c8 ff ff       	call   8010173d <iunlockput>
    end_op();
80104ec7:	e8 5e d9 ff ff       	call   8010282a <end_op>
    return -1;
80104ecc:	83 c4 10             	add    $0x10,%esp
80104ecf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ed4:	eb 24                	jmp    80104efa <sys_chdir+0x98>
  }
  iunlock(ip);
80104ed6:	83 ec 0c             	sub    $0xc,%esp
80104ed9:	53                   	push   %ebx
80104eda:	e8 dd c6 ff ff       	call   801015bc <iunlock>
  iput(curproc->cwd);
80104edf:	83 c4 04             	add    $0x4,%esp
80104ee2:	ff 76 68             	pushl  0x68(%esi)
80104ee5:	e8 17 c7 ff ff       	call   80101601 <iput>
  end_op();
80104eea:	e8 3b d9 ff ff       	call   8010282a <end_op>
  curproc->cwd = ip;
80104eef:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80104ef2:	83 c4 10             	add    $0x10,%esp
80104ef5:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104efa:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104efd:	5b                   	pop    %ebx
80104efe:	5e                   	pop    %esi
80104eff:	5d                   	pop    %ebp
80104f00:	c3                   	ret    

80104f01 <sys_exec>:

int
sys_exec(void)
{
80104f01:	55                   	push   %ebp
80104f02:	89 e5                	mov    %esp,%ebp
80104f04:	57                   	push   %edi
80104f05:	56                   	push   %esi
80104f06:	53                   	push   %ebx
80104f07:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80104f0d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104f10:	50                   	push   %eax
80104f11:	6a 00                	push   $0x0
80104f13:	e8 8f f5 ff ff       	call   801044a7 <argstr>
80104f18:	83 c4 10             	add    $0x10,%esp
80104f1b:	85 c0                	test   %eax,%eax
80104f1d:	0f 88 a9 00 00 00    	js     80104fcc <sys_exec+0xcb>
80104f23:	83 ec 08             	sub    $0x8,%esp
80104f26:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80104f2c:	50                   	push   %eax
80104f2d:	6a 01                	push   $0x1
80104f2f:	e8 e4 f4 ff ff       	call   80104418 <argint>
80104f34:	83 c4 10             	add    $0x10,%esp
80104f37:	85 c0                	test   %eax,%eax
80104f39:	0f 88 94 00 00 00    	js     80104fd3 <sys_exec+0xd2>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80104f3f:	83 ec 04             	sub    $0x4,%esp
80104f42:	68 80 00 00 00       	push   $0x80
80104f47:	6a 00                	push   $0x0
80104f49:	8d b5 64 ff ff ff    	lea    -0x9c(%ebp),%esi
80104f4f:	56                   	push   %esi
80104f50:	e8 23 f2 ff ff       	call   80104178 <memset>
80104f55:	83 c4 10             	add    $0x10,%esp
80104f58:	bb 00 00 00 00       	mov    $0x0,%ebx
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80104f5d:	8d bd 5c ff ff ff    	lea    -0xa4(%ebp),%edi
80104f63:	83 ec 08             	sub    $0x8,%esp
80104f66:	57                   	push   %edi
80104f67:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80104f6d:	8d 04 98             	lea    (%eax,%ebx,4),%eax
80104f70:	50                   	push   %eax
80104f71:	e8 14 f4 ff ff       	call   8010438a <fetchint>
80104f76:	83 c4 10             	add    $0x10,%esp
80104f79:	85 c0                	test   %eax,%eax
80104f7b:	78 5d                	js     80104fda <sys_exec+0xd9>
      return -1;
    if(uarg == 0){
80104f7d:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
80104f83:	85 c0                	test   %eax,%eax
80104f85:	75 22                	jne    80104fa9 <sys_exec+0xa8>
      argv[i] = 0;
80104f87:	c7 84 9d 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%ebx,4)
80104f8e:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80104f92:	83 ec 08             	sub    $0x8,%esp
80104f95:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80104f9b:	50                   	push   %eax
80104f9c:	ff 75 e4             	pushl  -0x1c(%ebp)
80104f9f:	e8 53 b9 ff ff       	call   801008f7 <exec>
80104fa4:	83 c4 10             	add    $0x10,%esp
80104fa7:	eb 3d                	jmp    80104fe6 <sys_exec+0xe5>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80104fa9:	83 ec 08             	sub    $0x8,%esp
80104fac:	56                   	push   %esi
80104fad:	50                   	push   %eax
80104fae:	e8 13 f4 ff ff       	call   801043c6 <fetchstr>
80104fb3:	83 c4 10             	add    $0x10,%esp
80104fb6:	85 c0                	test   %eax,%eax
80104fb8:	78 27                	js     80104fe1 <sys_exec+0xe0>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80104fba:	83 c3 01             	add    $0x1,%ebx
80104fbd:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
80104fc0:	83 fb 20             	cmp    $0x20,%ebx
80104fc3:	75 9e                	jne    80104f63 <sys_exec+0x62>
      return -1;
80104fc5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fca:	eb 1a                	jmp    80104fe6 <sys_exec+0xe5>
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
80104fcc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fd1:	eb 13                	jmp    80104fe6 <sys_exec+0xe5>
80104fd3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fd8:	eb 0c                	jmp    80104fe6 <sys_exec+0xe5>
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
80104fda:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fdf:	eb 05                	jmp    80104fe6 <sys_exec+0xe5>
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
80104fe1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return exec(path, argv);
}
80104fe6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104fe9:	5b                   	pop    %ebx
80104fea:	5e                   	pop    %esi
80104feb:	5f                   	pop    %edi
80104fec:	5d                   	pop    %ebp
80104fed:	c3                   	ret    

80104fee <sys_pipe>:

int
sys_pipe(void)
{
80104fee:	55                   	push   %ebp
80104fef:	89 e5                	mov    %esp,%ebp
80104ff1:	53                   	push   %ebx
80104ff2:	83 ec 18             	sub    $0x18,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80104ff5:	6a 08                	push   $0x8
80104ff7:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ffa:	50                   	push   %eax
80104ffb:	6a 00                	push   $0x0
80104ffd:	e8 3c f4 ff ff       	call   8010443e <argptr>
80105002:	83 c4 10             	add    $0x10,%esp
80105005:	85 c0                	test   %eax,%eax
80105007:	78 65                	js     8010506e <sys_pipe+0x80>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105009:	83 ec 08             	sub    $0x8,%esp
8010500c:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010500f:	50                   	push   %eax
80105010:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105013:	50                   	push   %eax
80105014:	e8 a7 dd ff ff       	call   80102dc0 <pipealloc>
80105019:	83 c4 10             	add    $0x10,%esp
8010501c:	85 c0                	test   %eax,%eax
8010501e:	78 55                	js     80105075 <sys_pipe+0x87>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105020:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105023:	e8 6b f5 ff ff       	call   80104593 <fdalloc>
80105028:	89 c3                	mov    %eax,%ebx
8010502a:	85 c0                	test   %eax,%eax
8010502c:	78 0e                	js     8010503c <sys_pipe+0x4e>
8010502e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105031:	e8 5d f5 ff ff       	call   80104593 <fdalloc>
80105036:	85 c0                	test   %eax,%eax
80105038:	79 22                	jns    8010505c <sys_pipe+0x6e>
8010503a:	eb 40                	jmp    8010507c <sys_pipe+0x8e>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
8010503c:	83 ec 0c             	sub    $0xc,%esp
8010503f:	ff 75 f0             	pushl  -0x10(%ebp)
80105042:	e8 0f bd ff ff       	call   80100d56 <fileclose>
    fileclose(wf);
80105047:	83 c4 04             	add    $0x4,%esp
8010504a:	ff 75 ec             	pushl  -0x14(%ebp)
8010504d:	e8 04 bd ff ff       	call   80100d56 <fileclose>
    return -1;
80105052:	83 c4 10             	add    $0x10,%esp
80105055:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010505a:	eb 2f                	jmp    8010508b <sys_pipe+0x9d>
  }
  fd[0] = fd0;
8010505c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010505f:	89 1a                	mov    %ebx,(%edx)
  fd[1] = fd1;
80105061:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105064:	89 42 04             	mov    %eax,0x4(%edx)
  return 0;
80105067:	b8 00 00 00 00       	mov    $0x0,%eax
8010506c:	eb 1d                	jmp    8010508b <sys_pipe+0x9d>
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
8010506e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105073:	eb 16                	jmp    8010508b <sys_pipe+0x9d>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
80105075:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010507a:	eb 0f                	jmp    8010508b <sys_pipe+0x9d>
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
8010507c:	e8 19 e3 ff ff       	call   8010339a <myproc>
80105081:	c7 44 98 28 00 00 00 	movl   $0x0,0x28(%eax,%ebx,4)
80105088:	00 
80105089:	eb b1                	jmp    8010503c <sys_pipe+0x4e>
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
8010508b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010508e:	c9                   	leave  
8010508f:	c3                   	ret    

80105090 <sys_yield>:
};

struct variable_pair variable_array[MAX_VARIABLES];

int sys_yield(void)
{
80105090:	55                   	push   %ebp
80105091:	89 e5                	mov    %esp,%ebp
80105093:	83 ec 08             	sub    $0x8,%esp
  yield(); 
80105096:	e8 59 e8 ff ff       	call   801038f4 <yield>
  return 0;
}
8010509b:	b8 00 00 00 00       	mov    $0x0,%eax
801050a0:	c9                   	leave  
801050a1:	c3                   	ret    

801050a2 <sys_fork>:

int
sys_fork(void)
{
801050a2:	55                   	push   %ebp
801050a3:	89 e5                	mov    %esp,%ebp
801050a5:	83 ec 08             	sub    $0x8,%esp
  return fork();
801050a8:	e8 9d e4 ff ff       	call   8010354a <fork>
}
801050ad:	c9                   	leave  
801050ae:	c3                   	ret    

801050af <sys_exit>:

int
sys_exit(void)
{
801050af:	55                   	push   %ebp
801050b0:	89 e5                	mov    %esp,%ebp
801050b2:	83 ec 08             	sub    $0x8,%esp
  exit();
801050b5:	e8 6e e7 ff ff       	call   80103828 <exit>
  return 0;  // not reached
}
801050ba:	b8 00 00 00 00       	mov    $0x0,%eax
801050bf:	c9                   	leave  
801050c0:	c3                   	ret    

801050c1 <sys_wait>:

int
sys_wait(void)
{
801050c1:	55                   	push   %ebp
801050c2:	89 e5                	mov    %esp,%ebp
801050c4:	83 ec 08             	sub    $0x8,%esp
  return wait();
801050c7:	e8 f8 e9 ff ff       	call   80103ac4 <wait>
}
801050cc:	c9                   	leave  
801050cd:	c3                   	ret    

801050ce <sys_kill>:

int
sys_kill(void)
{
801050ce:	55                   	push   %ebp
801050cf:	89 e5                	mov    %esp,%ebp
801050d1:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801050d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801050d7:	50                   	push   %eax
801050d8:	6a 00                	push   $0x0
801050da:	e8 39 f3 ff ff       	call   80104418 <argint>
801050df:	83 c4 10             	add    $0x10,%esp
801050e2:	85 c0                	test   %eax,%eax
801050e4:	78 10                	js     801050f6 <sys_kill+0x28>
    return -1;
  return kill(pid);
801050e6:	83 ec 0c             	sub    $0xc,%esp
801050e9:	ff 75 f4             	pushl  -0xc(%ebp)
801050ec:	e8 f8 eb ff ff       	call   80103ce9 <kill>
801050f1:	83 c4 10             	add    $0x10,%esp
801050f4:	eb 05                	jmp    801050fb <sys_kill+0x2d>
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
801050f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return kill(pid);
}
801050fb:	c9                   	leave  
801050fc:	c3                   	ret    

801050fd <sys_getpid>:

int
sys_getpid(void)
{
801050fd:	55                   	push   %ebp
801050fe:	89 e5                	mov    %esp,%ebp
80105100:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105103:	e8 92 e2 ff ff       	call   8010339a <myproc>
80105108:	8b 40 10             	mov    0x10(%eax),%eax
}
8010510b:	c9                   	leave  
8010510c:	c3                   	ret    

8010510d <sys_sbrk>:

int
sys_sbrk(void)
{
8010510d:	55                   	push   %ebp
8010510e:	89 e5                	mov    %esp,%ebp
80105110:	53                   	push   %ebx
80105111:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105114:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105117:	50                   	push   %eax
80105118:	6a 00                	push   $0x0
8010511a:	e8 f9 f2 ff ff       	call   80104418 <argint>
8010511f:	83 c4 10             	add    $0x10,%esp
80105122:	85 c0                	test   %eax,%eax
80105124:	78 21                	js     80105147 <sys_sbrk+0x3a>
    return -1;
  addr = myproc()->sz;
80105126:	e8 6f e2 ff ff       	call   8010339a <myproc>
8010512b:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
8010512d:	83 ec 0c             	sub    $0xc,%esp
80105130:	ff 75 f4             	pushl  -0xc(%ebp)
80105133:	e8 a3 e3 ff ff       	call   801034db <growproc>
80105138:	83 c4 10             	add    $0x10,%esp
8010513b:	85 c0                	test   %eax,%eax
    return -1;
  return addr;
8010513d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105142:	0f 49 c3             	cmovns %ebx,%eax
80105145:	eb 05                	jmp    8010514c <sys_sbrk+0x3f>
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
80105147:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}
8010514c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010514f:	c9                   	leave  
80105150:	c3                   	ret    

80105151 <sys_sleep>:

int
sys_sleep(void)
{
80105151:	55                   	push   %ebp
80105152:	89 e5                	mov    %esp,%ebp
80105154:	53                   	push   %ebx
80105155:	83 ec 1c             	sub    $0x1c,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105158:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010515b:	50                   	push   %eax
8010515c:	6a 00                	push   $0x0
8010515e:	e8 b5 f2 ff ff       	call   80104418 <argint>
80105163:	83 c4 10             	add    $0x10,%esp
80105166:	85 c0                	test   %eax,%eax
80105168:	78 76                	js     801051e0 <sys_sleep+0x8f>
    return -1;
  acquire(&tickslock);
8010516a:	83 ec 0c             	sub    $0xc,%esp
8010516d:	68 80 55 11 80       	push   $0x80115580
80105172:	e8 f5 ee ff ff       	call   8010406c <acquire>
  ticks0 = ticks;
80105177:	8b 1d c0 5d 11 80    	mov    0x80115dc0,%ebx
  while(ticks - ticks0 < n){
8010517d:	83 c4 10             	add    $0x10,%esp
80105180:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105184:	74 43                	je     801051c9 <sys_sleep+0x78>
    if(myproc()->killed){
80105186:	e8 0f e2 ff ff       	call   8010339a <myproc>
8010518b:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
8010518f:	74 17                	je     801051a8 <sys_sleep+0x57>
      release(&tickslock);
80105191:	83 ec 0c             	sub    $0xc,%esp
80105194:	68 80 55 11 80       	push   $0x80115580
80105199:	e8 93 ef ff ff       	call   80104131 <release>
      return -1;
8010519e:	83 c4 10             	add    $0x10,%esp
801051a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051a6:	eb 3d                	jmp    801051e5 <sys_sleep+0x94>
    }
    sleep(&ticks, &tickslock);
801051a8:	83 ec 08             	sub    $0x8,%esp
801051ab:	68 80 55 11 80       	push   $0x80115580
801051b0:	68 c0 5d 11 80       	push   $0x80115dc0
801051b5:	e8 ae e7 ff ff       	call   80103968 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801051ba:	a1 c0 5d 11 80       	mov    0x80115dc0,%eax
801051bf:	29 d8                	sub    %ebx,%eax
801051c1:	83 c4 10             	add    $0x10,%esp
801051c4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801051c7:	72 bd                	jb     80105186 <sys_sleep+0x35>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
801051c9:	83 ec 0c             	sub    $0xc,%esp
801051cc:	68 80 55 11 80       	push   $0x80115580
801051d1:	e8 5b ef ff ff       	call   80104131 <release>
  return 0;
801051d6:	83 c4 10             	add    $0x10,%esp
801051d9:	b8 00 00 00 00       	mov    $0x0,%eax
801051de:	eb 05                	jmp    801051e5 <sys_sleep+0x94>
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
801051e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
801051e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801051e8:	c9                   	leave  
801051e9:	c3                   	ret    

801051ea <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801051ea:	55                   	push   %ebp
801051eb:	89 e5                	mov    %esp,%ebp
801051ed:	53                   	push   %ebx
801051ee:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801051f1:	68 80 55 11 80       	push   $0x80115580
801051f6:	e8 71 ee ff ff       	call   8010406c <acquire>
  xticks = ticks;
801051fb:	8b 1d c0 5d 11 80    	mov    0x80115dc0,%ebx
  release(&tickslock);
80105201:	c7 04 24 80 55 11 80 	movl   $0x80115580,(%esp)
80105208:	e8 24 ef ff ff       	call   80104131 <release>
  return xticks;
}
8010520d:	89 d8                	mov    %ebx,%eax
8010520f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105212:	c9                   	leave  
80105213:	c3                   	ret    

80105214 <sys_wait2>:
    return remvariable(variable);
    
}

int
sys_wait2(void){
80105214:	55                   	push   %ebp
80105215:	89 e5                	mov    %esp,%ebp
80105217:	83 ec 20             	sub    $0x20,%esp
    int pid;
    int* wtime;
    int* rtime;
    int* iotime;
    if(argint(0, &pid) < 0 || argint(1, (int *)&wtime) < 0 || argint(2, (int *)&rtime) < 0 || argint(3, (int *)&iotime) < 0){
8010521a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010521d:	50                   	push   %eax
8010521e:	6a 00                	push   $0x0
80105220:	e8 f3 f1 ff ff       	call   80104418 <argint>
80105225:	83 c4 10             	add    $0x10,%esp
80105228:	85 c0                	test   %eax,%eax
8010522a:	78 55                	js     80105281 <sys_wait2+0x6d>
8010522c:	83 ec 08             	sub    $0x8,%esp
8010522f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105232:	50                   	push   %eax
80105233:	6a 01                	push   $0x1
80105235:	e8 de f1 ff ff       	call   80104418 <argint>
8010523a:	83 c4 10             	add    $0x10,%esp
8010523d:	85 c0                	test   %eax,%eax
8010523f:	78 47                	js     80105288 <sys_wait2+0x74>
80105241:	83 ec 08             	sub    $0x8,%esp
80105244:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105247:	50                   	push   %eax
80105248:	6a 02                	push   $0x2
8010524a:	e8 c9 f1 ff ff       	call   80104418 <argint>
8010524f:	83 c4 10             	add    $0x10,%esp
80105252:	85 c0                	test   %eax,%eax
80105254:	78 39                	js     8010528f <sys_wait2+0x7b>
80105256:	83 ec 08             	sub    $0x8,%esp
80105259:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010525c:	50                   	push   %eax
8010525d:	6a 03                	push   $0x3
8010525f:	e8 b4 f1 ff ff       	call   80104418 <argint>
80105264:	83 c4 10             	add    $0x10,%esp
80105267:	85 c0                	test   %eax,%eax
80105269:	78 2b                	js     80105296 <sys_wait2+0x82>
        return -1;
    }
    return wait2(pid,wtime,rtime,iotime);
8010526b:	ff 75 e8             	pushl  -0x18(%ebp)
8010526e:	ff 75 ec             	pushl  -0x14(%ebp)
80105271:	ff 75 f0             	pushl  -0x10(%ebp)
80105274:	ff 75 f4             	pushl  -0xc(%ebp)
80105277:	e8 1d e9 ff ff       	call   80103b99 <wait2>
8010527c:	83 c4 10             	add    $0x10,%esp
8010527f:	eb 1a                	jmp    8010529b <sys_wait2+0x87>
    int pid;
    int* wtime;
    int* rtime;
    int* iotime;
    if(argint(0, &pid) < 0 || argint(1, (int *)&wtime) < 0 || argint(2, (int *)&rtime) < 0 || argint(3, (int *)&iotime) < 0){
        return -1;
80105281:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105286:	eb 13                	jmp    8010529b <sys_wait2+0x87>
80105288:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010528d:	eb 0c                	jmp    8010529b <sys_wait2+0x87>
8010528f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105294:	eb 05                	jmp    8010529b <sys_wait2+0x87>
80105296:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    return wait2(pid,wtime,rtime,iotime);
}
8010529b:	c9                   	leave  
8010529c:	c3                   	ret    

8010529d <sys_set_priority>:

int
sys_set_priority(void){
8010529d:	55                   	push   %ebp
8010529e:	89 e5                	mov    %esp,%ebp
801052a0:	83 ec 20             	sub    $0x20,%esp
    int priority;
    if(argint(0, &priority)<0)
801052a3:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052a6:	50                   	push   %eax
801052a7:	6a 00                	push   $0x0
801052a9:	e8 6a f1 ff ff       	call   80104418 <argint>
801052ae:	83 c4 10             	add    $0x10,%esp
801052b1:	85 c0                	test   %eax,%eax
801052b3:	78 10                	js     801052c5 <sys_set_priority+0x28>
        return -1;
    return  set_priority(priority);
801052b5:	83 ec 0c             	sub    $0xc,%esp
801052b8:	ff 75 f4             	pushl  -0xc(%ebp)
801052bb:	e8 d6 e3 ff ff       	call   80103696 <set_priority>
801052c0:	83 c4 10             	add    $0x10,%esp
801052c3:	eb 05                	jmp    801052ca <sys_set_priority+0x2d>

int
sys_set_priority(void){
    int priority;
    if(argint(0, &priority)<0)
        return -1;
801052c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return  set_priority(priority);
}
801052ca:	c9                   	leave  
801052cb:	c3                   	ret    

801052cc <onlyLetters>:


int onlyLetters(char* s){
801052cc:	55                   	push   %ebp
801052cd:	89 e5                	mov    %esp,%ebp
801052cf:	56                   	push   %esi
801052d0:	53                   	push   %ebx
801052d1:	8b 75 08             	mov    0x8(%ebp),%esi
    int i;
    for(i=0; i<strlen(s); i++){
801052d4:	bb 00 00 00 00       	mov    $0x0,%ebx
801052d9:	eb 0e                	jmp    801052e9 <onlyLetters+0x1d>
        if(!(s[i]>='a' && s[i]<='z' )|| (s[i]>='A' && s[i]<='Z'))
801052db:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
801052df:	83 e8 61             	sub    $0x61,%eax
801052e2:	3c 19                	cmp    $0x19,%al
801052e4:	77 1a                	ja     80105300 <onlyLetters+0x34>
}


int onlyLetters(char* s){
    int i;
    for(i=0; i<strlen(s); i++){
801052e6:	83 c3 01             	add    $0x1,%ebx
801052e9:	83 ec 0c             	sub    $0xc,%esp
801052ec:	56                   	push   %esi
801052ed:	e8 61 f0 ff ff       	call   80104353 <strlen>
801052f2:	83 c4 10             	add    $0x10,%esp
801052f5:	39 c3                	cmp    %eax,%ebx
801052f7:	7c e2                	jl     801052db <onlyLetters+0xf>
        if(!(s[i]>='a' && s[i]<='z' )|| (s[i]>='A' && s[i]<='Z'))
            return 0;
    }
    return 1;
801052f9:	b8 01 00 00 00       	mov    $0x1,%eax
801052fe:	eb 05                	jmp    80105305 <onlyLetters+0x39>

int onlyLetters(char* s){
    int i;
    for(i=0; i<strlen(s); i++){
        if(!(s[i]>='a' && s[i]<='z' )|| (s[i]>='A' && s[i]<='Z'))
            return 0;
80105300:	b8 00 00 00 00       	mov    $0x0,%eax
    }
    return 1;
}
80105305:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105308:	5b                   	pop    %ebx
80105309:	5e                   	pop    %esi
8010530a:	5d                   	pop    %ebp
8010530b:	c3                   	ret    

8010530c <getFreeIndex>:
//get a free index for a variable. if none available, returns -1
int getFreeIndex(char* variable){
8010530c:	55                   	push   %ebp
8010530d:	89 e5                	mov    %esp,%ebp
8010530f:	57                   	push   %edi
80105310:	56                   	push   %esi
80105311:	53                   	push   %ebx
80105312:	83 ec 1c             	sub    $0x1c,%esp
80105315:	8b 7d 08             	mov    0x8(%ebp),%edi
    int i;
    for(i=0; i<MAX_VARIABLES; i++){
80105318:	bb 00 00 00 00       	mov    $0x0,%ebx
        char* current_variable=variable_array[i].variable;
8010531d:	8b 34 dd 80 54 11 80 	mov    -0x7feeab80(,%ebx,8),%esi
        if(strlen(variable) == strlen(current_variable) && strncmp(variable,current_variable,strlen(variable))==0)
80105324:	83 ec 0c             	sub    $0xc,%esp
80105327:	57                   	push   %edi
80105328:	e8 26 f0 ff ff       	call   80104353 <strlen>
8010532d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80105330:	89 34 24             	mov    %esi,(%esp)
80105333:	e8 1b f0 ff ff       	call   80104353 <strlen>
80105338:	83 c4 10             	add    $0x10,%esp
8010533b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
8010533e:	75 1b                	jne    8010535b <getFreeIndex+0x4f>
80105340:	83 ec 0c             	sub    $0xc,%esp
80105343:	57                   	push   %edi
80105344:	e8 0a f0 ff ff       	call   80104353 <strlen>
80105349:	83 c4 0c             	add    $0xc,%esp
8010534c:	50                   	push   %eax
8010534d:	56                   	push   %esi
8010534e:	57                   	push   %edi
8010534f:	e8 23 ef ff ff       	call   80104277 <strncmp>
80105354:	83 c4 10             	add    $0x10,%esp
80105357:	85 c0                	test   %eax,%eax
80105359:	74 30                	je     8010538b <getFreeIndex+0x7f>
    return 1;
}
//get a free index for a variable. if none available, returns -1
int getFreeIndex(char* variable){
    int i;
    for(i=0; i<MAX_VARIABLES; i++){
8010535b:	83 c3 01             	add    $0x1,%ebx
8010535e:	83 fb 20             	cmp    $0x20,%ebx
80105361:	75 ba                	jne    8010531d <getFreeIndex+0x11>
80105363:	b8 00 00 00 00       	mov    $0x0,%eax
        char* current_variable=variable_array[i].variable;
        if(strlen(variable) == strlen(current_variable) && strncmp(variable,current_variable,strlen(variable))==0)
            return i;
    }
    for(i=0; i<MAX_VARIABLES; i++){
         if(variable_array[i].variable == 0 && variable_array[i].value == 0)
80105368:	83 3c c5 80 54 11 80 	cmpl   $0x0,-0x7feeab80(,%eax,8)
8010536f:	00 
80105370:	75 0a                	jne    8010537c <getFreeIndex+0x70>
80105372:	83 3c c5 84 54 11 80 	cmpl   $0x0,-0x7feeab7c(,%eax,8)
80105379:	00 
8010537a:	74 11                	je     8010538d <getFreeIndex+0x81>
    for(i=0; i<MAX_VARIABLES; i++){
        char* current_variable=variable_array[i].variable;
        if(strlen(variable) == strlen(current_variable) && strncmp(variable,current_variable,strlen(variable))==0)
            return i;
    }
    for(i=0; i<MAX_VARIABLES; i++){
8010537c:	83 c0 01             	add    $0x1,%eax
8010537f:	83 f8 20             	cmp    $0x20,%eax
80105382:	75 e4                	jne    80105368 <getFreeIndex+0x5c>
         if(variable_array[i].variable == 0 && variable_array[i].value == 0)
            return i;
    }
    return -1;
80105384:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105389:	eb 02                	jmp    8010538d <getFreeIndex+0x81>
8010538b:	89 d8                	mov    %ebx,%eax
    
}
8010538d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105390:	5b                   	pop    %ebx
80105391:	5e                   	pop    %esi
80105392:	5f                   	pop    %edi
80105393:	5d                   	pop    %ebp
80105394:	c3                   	ret    

80105395 <setvariable>:


//implementation of setVariable
int setvariable(char* variable, char* value){
80105395:	55                   	push   %ebp
80105396:	89 e5                	mov    %esp,%ebp
80105398:	56                   	push   %esi
80105399:	53                   	push   %ebx
8010539a:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010539d:	8b 75 0c             	mov    0xc(%ebp),%esi
    
    int freeIndex;
    //if illegal input
    if(!onlyLetters(variable) || strlen(variable)>32 || strlen(value)>128)
801053a0:	83 ec 0c             	sub    $0xc,%esp
801053a3:	53                   	push   %ebx
801053a4:	e8 23 ff ff ff       	call   801052cc <onlyLetters>
801053a9:	83 c4 10             	add    $0x10,%esp
801053ac:	85 c0                	test   %eax,%eax
801053ae:	74 4a                	je     801053fa <setvariable+0x65>
801053b0:	83 ec 0c             	sub    $0xc,%esp
801053b3:	53                   	push   %ebx
801053b4:	e8 9a ef ff ff       	call   80104353 <strlen>
801053b9:	83 c4 10             	add    $0x10,%esp
801053bc:	83 f8 20             	cmp    $0x20,%eax
801053bf:	7f 40                	jg     80105401 <setvariable+0x6c>
801053c1:	83 ec 0c             	sub    $0xc,%esp
801053c4:	56                   	push   %esi
801053c5:	e8 89 ef ff ff       	call   80104353 <strlen>
801053ca:	83 c4 10             	add    $0x10,%esp
801053cd:	3d 80 00 00 00       	cmp    $0x80,%eax
801053d2:	7f 34                	jg     80105408 <setvariable+0x73>
        return -2;
    if((freeIndex=getFreeIndex(variable))==-1)
801053d4:	83 ec 0c             	sub    $0xc,%esp
801053d7:	53                   	push   %ebx
801053d8:	e8 2f ff ff ff       	call   8010530c <getFreeIndex>
801053dd:	83 c4 10             	add    $0x10,%esp
801053e0:	83 f8 ff             	cmp    $0xffffffff,%eax
801053e3:	74 2a                	je     8010540f <setvariable+0x7a>
        return -1;
    //------------------
    variable_array[freeIndex].variable=variable;
801053e5:	89 1c c5 80 54 11 80 	mov    %ebx,-0x7feeab80(,%eax,8)
    variable_array[freeIndex].value=value;
801053ec:	89 34 c5 84 54 11 80 	mov    %esi,-0x7feeab7c(,%eax,8)
    return 0;
801053f3:	b8 00 00 00 00       	mov    $0x0,%eax
801053f8:	eb 1a                	jmp    80105414 <setvariable+0x7f>
int setvariable(char* variable, char* value){
    
    int freeIndex;
    //if illegal input
    if(!onlyLetters(variable) || strlen(variable)>32 || strlen(value)>128)
        return -2;
801053fa:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
801053ff:	eb 13                	jmp    80105414 <setvariable+0x7f>
80105401:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
80105406:	eb 0c                	jmp    80105414 <setvariable+0x7f>
80105408:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
8010540d:	eb 05                	jmp    80105414 <setvariable+0x7f>
    if((freeIndex=getFreeIndex(variable))==-1)
        return -1;
8010540f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    //------------------
    variable_array[freeIndex].variable=variable;
    variable_array[freeIndex].value=value;
    return 0;
}
80105414:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105417:	5b                   	pop    %ebx
80105418:	5e                   	pop    %esi
80105419:	5d                   	pop    %ebp
8010541a:	c3                   	ret    

8010541b <sys_setvariable>:

//added task 1.2
//task 1.2 implementations

int
sys_setvariable(void){
8010541b:	55                   	push   %ebp
8010541c:	89 e5                	mov    %esp,%ebp
8010541e:	83 ec 20             	sub    $0x20,%esp
    char* variable;
    char* value;
    if(argstr(0, &variable) < 0 || argstr(1, &value)<0)
80105421:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105424:	50                   	push   %eax
80105425:	6a 00                	push   $0x0
80105427:	e8 7b f0 ff ff       	call   801044a7 <argstr>
8010542c:	83 c4 10             	add    $0x10,%esp
8010542f:	85 c0                	test   %eax,%eax
80105431:	78 28                	js     8010545b <sys_setvariable+0x40>
80105433:	83 ec 08             	sub    $0x8,%esp
80105436:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105439:	50                   	push   %eax
8010543a:	6a 01                	push   $0x1
8010543c:	e8 66 f0 ff ff       	call   801044a7 <argstr>
80105441:	83 c4 10             	add    $0x10,%esp
80105444:	85 c0                	test   %eax,%eax
80105446:	78 1a                	js     80105462 <sys_setvariable+0x47>
        return -1;
    return setvariable(variable , value);
80105448:	83 ec 08             	sub    $0x8,%esp
8010544b:	ff 75 f0             	pushl  -0x10(%ebp)
8010544e:	ff 75 f4             	pushl  -0xc(%ebp)
80105451:	e8 3f ff ff ff       	call   80105395 <setvariable>
80105456:	83 c4 10             	add    $0x10,%esp
80105459:	eb 0c                	jmp    80105467 <sys_setvariable+0x4c>
int
sys_setvariable(void){
    char* variable;
    char* value;
    if(argstr(0, &variable) < 0 || argstr(1, &value)<0)
        return -1;
8010545b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105460:	eb 05                	jmp    80105467 <sys_setvariable+0x4c>
80105462:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return setvariable(variable , value);
}
80105467:	c9                   	leave  
80105468:	c3                   	ret    

80105469 <getvariable>:
    variable_array[freeIndex].value=value;
    return 0;
}

//implementation of getVariable
int getvariable(char* variable, char* value){
80105469:	55                   	push   %ebp
8010546a:	89 e5                	mov    %esp,%ebp
8010546c:	57                   	push   %edi
8010546d:	56                   	push   %esi
8010546e:	53                   	push   %ebx
8010546f:	83 ec 0c             	sub    $0xc,%esp
80105472:	8b 7d 08             	mov    0x8(%ebp),%edi
    int i;
    for(i=0; i<MAX_VARIABLES; i++){
80105475:	bb 00 00 00 00       	mov    $0x0,%ebx
        if(strncmp(variable_array[i].variable,variable, strlen(variable))==0){
8010547a:	83 ec 0c             	sub    $0xc,%esp
8010547d:	57                   	push   %edi
8010547e:	e8 d0 ee ff ff       	call   80104353 <strlen>
80105483:	83 c4 0c             	add    $0xc,%esp
80105486:	50                   	push   %eax
80105487:	57                   	push   %edi
80105488:	ff 34 dd 80 54 11 80 	pushl  -0x7feeab80(,%ebx,8)
8010548f:	e8 e3 ed ff ff       	call   80104277 <strncmp>
80105494:	89 c6                	mov    %eax,%esi
80105496:	83 c4 10             	add    $0x10,%esp
80105499:	85 c0                	test   %eax,%eax
8010549b:	75 39                	jne    801054d6 <getvariable+0x6d>
            strncpy(value,variable_array[i].value,strlen(variable_array[i].value));
8010549d:	83 ec 0c             	sub    $0xc,%esp
801054a0:	ff 34 dd 84 54 11 80 	pushl  -0x7feeab7c(,%ebx,8)
801054a7:	e8 a7 ee ff ff       	call   80104353 <strlen>
801054ac:	83 c4 0c             	add    $0xc,%esp
801054af:	50                   	push   %eax
801054b0:	ff 34 dd 84 54 11 80 	pushl  -0x7feeab7c(,%ebx,8)
801054b7:	ff 75 0c             	pushl  0xc(%ebp)
801054ba:	e8 0d ee ff ff       	call   801042cc <strncpy>
            value[strlen(value)]=0; //null terminate the value
801054bf:	83 c4 04             	add    $0x4,%esp
801054c2:	ff 75 0c             	pushl  0xc(%ebp)
801054c5:	e8 89 ee ff ff       	call   80104353 <strlen>
801054ca:	8b 55 0c             	mov    0xc(%ebp),%edx
801054cd:	c6 04 02 00          	movb   $0x0,(%edx,%eax,1)
            return 0;
801054d1:	83 c4 10             	add    $0x10,%esp
801054d4:	eb 0d                	jmp    801054e3 <getvariable+0x7a>
}

//implementation of getVariable
int getvariable(char* variable, char* value){
    int i;
    for(i=0; i<MAX_VARIABLES; i++){
801054d6:	83 c3 01             	add    $0x1,%ebx
801054d9:	83 fb 20             	cmp    $0x20,%ebx
801054dc:	75 9c                	jne    8010547a <getvariable+0x11>
            strncpy(value,variable_array[i].value,strlen(variable_array[i].value));
            value[strlen(value)]=0; //null terminate the value
            return 0;
        }
    }
    return -1;
801054de:	be ff ff ff ff       	mov    $0xffffffff,%esi
}
801054e3:	89 f0                	mov    %esi,%eax
801054e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801054e8:	5b                   	pop    %ebx
801054e9:	5e                   	pop    %esi
801054ea:	5f                   	pop    %edi
801054eb:	5d                   	pop    %ebp
801054ec:	c3                   	ret    

801054ed <sys_getvariable>:
    if(argstr(0, &variable) < 0 || argstr(1, &value)<0)
        return -1;
    return setvariable(variable , value);
}
int
sys_getvariable(void){
801054ed:	55                   	push   %ebp
801054ee:	89 e5                	mov    %esp,%ebp
801054f0:	83 ec 20             	sub    $0x20,%esp
    char* variable;
    char* value;
    if(argstr(0, &variable) < 0 || argstr(1, &value)<0)
801054f3:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054f6:	50                   	push   %eax
801054f7:	6a 00                	push   $0x0
801054f9:	e8 a9 ef ff ff       	call   801044a7 <argstr>
801054fe:	83 c4 10             	add    $0x10,%esp
80105501:	85 c0                	test   %eax,%eax
80105503:	78 28                	js     8010552d <sys_getvariable+0x40>
80105505:	83 ec 08             	sub    $0x8,%esp
80105508:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010550b:	50                   	push   %eax
8010550c:	6a 01                	push   $0x1
8010550e:	e8 94 ef ff ff       	call   801044a7 <argstr>
80105513:	83 c4 10             	add    $0x10,%esp
80105516:	85 c0                	test   %eax,%eax
80105518:	78 1a                	js     80105534 <sys_getvariable+0x47>
        return -1;
    return getvariable(variable , value);
8010551a:	83 ec 08             	sub    $0x8,%esp
8010551d:	ff 75 f0             	pushl  -0x10(%ebp)
80105520:	ff 75 f4             	pushl  -0xc(%ebp)
80105523:	e8 41 ff ff ff       	call   80105469 <getvariable>
80105528:	83 c4 10             	add    $0x10,%esp
8010552b:	eb 0c                	jmp    80105539 <sys_getvariable+0x4c>
int
sys_getvariable(void){
    char* variable;
    char* value;
    if(argstr(0, &variable) < 0 || argstr(1, &value)<0)
        return -1;
8010552d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105532:	eb 05                	jmp    80105539 <sys_getvariable+0x4c>
80105534:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return getvariable(variable , value);
}
80105539:	c9                   	leave  
8010553a:	c3                   	ret    

8010553b <remvariable>:
    }
    return -1;
}

//implementation of remVariable
int remvariable(char* variable){
8010553b:	55                   	push   %ebp
8010553c:	89 e5                	mov    %esp,%ebp
8010553e:	56                   	push   %esi
8010553f:	53                   	push   %ebx
80105540:	8b 75 08             	mov    0x8(%ebp),%esi
    int i;
    for(i=0; i<MAX_VARIABLES; i++){
80105543:	bb 00 00 00 00       	mov    $0x0,%ebx
        if(strncmp(variable_array[i].variable,variable, strlen(variable)==0)){
80105548:	83 ec 0c             	sub    $0xc,%esp
8010554b:	56                   	push   %esi
8010554c:	e8 02 ee ff ff       	call   80104353 <strlen>
80105551:	83 c4 0c             	add    $0xc,%esp
80105554:	85 c0                	test   %eax,%eax
80105556:	0f 94 c0             	sete   %al
80105559:	0f b6 c0             	movzbl %al,%eax
8010555c:	50                   	push   %eax
8010555d:	56                   	push   %esi
8010555e:	ff 34 dd 80 54 11 80 	pushl  -0x7feeab80(,%ebx,8)
80105565:	e8 0d ed ff ff       	call   80104277 <strncmp>
8010556a:	83 c4 10             	add    $0x10,%esp
8010556d:	85 c0                	test   %eax,%eax
8010556f:	74 1d                	je     8010558e <remvariable+0x53>
            variable_array[i].variable=0;
80105571:	c7 04 dd 80 54 11 80 	movl   $0x0,-0x7feeab80(,%ebx,8)
80105578:	00 00 00 00 
            variable_array[i].value=0;
8010557c:	c7 04 dd 84 54 11 80 	movl   $0x0,-0x7feeab7c(,%ebx,8)
80105583:	00 00 00 00 
            //TODO: IN SHELL DO FREE!!!AHHHHHHHH (AFTER)
            return 0;
80105587:	b8 00 00 00 00       	mov    $0x0,%eax
8010558c:	eb 0d                	jmp    8010559b <remvariable+0x60>
}

//implementation of remVariable
int remvariable(char* variable){
    int i;
    for(i=0; i<MAX_VARIABLES; i++){
8010558e:	83 c3 01             	add    $0x1,%ebx
80105591:	83 fb 20             	cmp    $0x20,%ebx
80105594:	75 b2                	jne    80105548 <remvariable+0xd>
            variable_array[i].value=0;
            //TODO: IN SHELL DO FREE!!!AHHHHHHHH (AFTER)
            return 0;
        }
    }
    return -1;
80105596:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    
    
}
8010559b:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010559e:	5b                   	pop    %ebx
8010559f:	5e                   	pop    %esi
801055a0:	5d                   	pop    %ebp
801055a1:	c3                   	ret    

801055a2 <sys_remvariable>:
    if(argstr(0, &variable) < 0 || argstr(1, &value)<0)
        return -1;
    return getvariable(variable , value);
}
int
sys_remvariable(void){
801055a2:	55                   	push   %ebp
801055a3:	89 e5                	mov    %esp,%ebp
801055a5:	83 ec 20             	sub    $0x20,%esp
    char* variable;
    if(argstr(0, &variable) < 0)
801055a8:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055ab:	50                   	push   %eax
801055ac:	6a 00                	push   $0x0
801055ae:	e8 f4 ee ff ff       	call   801044a7 <argstr>
801055b3:	83 c4 10             	add    $0x10,%esp
801055b6:	85 c0                	test   %eax,%eax
801055b8:	78 10                	js     801055ca <sys_remvariable+0x28>
        return -1;
    return remvariable(variable);
801055ba:	83 ec 0c             	sub    $0xc,%esp
801055bd:	ff 75 f4             	pushl  -0xc(%ebp)
801055c0:	e8 76 ff ff ff       	call   8010553b <remvariable>
801055c5:	83 c4 10             	add    $0x10,%esp
801055c8:	eb 05                	jmp    801055cf <sys_remvariable+0x2d>
}
int
sys_remvariable(void){
    char* variable;
    if(argstr(0, &variable) < 0)
        return -1;
801055ca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return remvariable(variable);
    
}
801055cf:	c9                   	leave  
801055d0:	c3                   	ret    

801055d1 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801055d1:	1e                   	push   %ds
  pushl %es
801055d2:	06                   	push   %es
  pushl %fs
801055d3:	0f a0                	push   %fs
  pushl %gs
801055d5:	0f a8                	push   %gs
  pushal
801055d7:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801055d8:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801055dc:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801055de:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801055e0:	54                   	push   %esp
  call trap
801055e1:	e8 ba 00 00 00       	call   801056a0 <trap>
  addl $4, %esp
801055e6:	83 c4 04             	add    $0x4,%esp

801055e9 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801055e9:	61                   	popa   
  popl %gs
801055ea:	0f a9                	pop    %gs
  popl %fs
801055ec:	0f a1                	pop    %fs
  popl %es
801055ee:	07                   	pop    %es
  popl %ds
801055ef:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801055f0:	83 c4 08             	add    $0x8,%esp
  iret
801055f3:	cf                   	iret   

801055f4 <tvinit>:

void
tvinit(void) {
    int i;

    for (i = 0; i < 256; i++) SETGATE(idt[i], 0, SEG_KCODE << 3, vectors[i], 0);
801055f4:	b8 00 00 00 00       	mov    $0x0,%eax
801055f9:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105600:	66 89 14 c5 c0 55 11 	mov    %dx,-0x7feeaa40(,%eax,8)
80105607:	80 
80105608:	66 c7 04 c5 c2 55 11 	movw   $0x8,-0x7feeaa3e(,%eax,8)
8010560f:	80 08 00 
80105612:	c6 04 c5 c4 55 11 80 	movb   $0x0,-0x7feeaa3c(,%eax,8)
80105619:	00 
8010561a:	c6 04 c5 c5 55 11 80 	movb   $0x8e,-0x7feeaa3b(,%eax,8)
80105621:	8e 
80105622:	c1 ea 10             	shr    $0x10,%edx
80105625:	66 89 14 c5 c6 55 11 	mov    %dx,-0x7feeaa3a(,%eax,8)
8010562c:	80 
8010562d:	83 c0 01             	add    $0x1,%eax
80105630:	3d 00 01 00 00       	cmp    $0x100,%eax
80105635:	75 c2                	jne    801055f9 <tvinit+0x5>
extern uint vectors[];  // in vectors.S: array of 256 entry pointers
struct spinlock tickslock;
uint ticks;

void
tvinit(void) {
80105637:	55                   	push   %ebp
80105638:	89 e5                	mov    %esp,%ebp
8010563a:	83 ec 10             	sub    $0x10,%esp
    int i;

    for (i = 0; i < 256; i++) SETGATE(idt[i], 0, SEG_KCODE << 3, vectors[i], 0);
    SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
8010563d:	a1 08 a1 10 80       	mov    0x8010a108,%eax
80105642:	66 a3 c0 57 11 80    	mov    %ax,0x801157c0
80105648:	66 c7 05 c2 57 11 80 	movw   $0x8,0x801157c2
8010564f:	08 00 
80105651:	c6 05 c4 57 11 80 00 	movb   $0x0,0x801157c4
80105658:	c6 05 c5 57 11 80 ef 	movb   $0xef,0x801157c5
8010565f:	c1 e8 10             	shr    $0x10,%eax
80105662:	66 a3 c6 57 11 80    	mov    %ax,0x801157c6

    initlock(&tickslock, "time");
80105668:	68 91 74 10 80       	push   $0x80107491
8010566d:	68 80 55 11 80       	push   $0x80115580
80105672:	e8 11 e9 ff ff       	call   80103f88 <initlock>
}
80105677:	83 c4 10             	add    $0x10,%esp
8010567a:	c9                   	leave  
8010567b:	c3                   	ret    

8010567c <idtinit>:

void
idtinit(void) {
8010567c:	55                   	push   %ebp
8010567d:	89 e5                	mov    %esp,%ebp
8010567f:	83 ec 10             	sub    $0x10,%esp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80105682:	66 c7 45 fa ff 07    	movw   $0x7ff,-0x6(%ebp)
  pd[1] = (uint)p;
80105688:	b8 c0 55 11 80       	mov    $0x801155c0,%eax
8010568d:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105691:	c1 e8 10             	shr    $0x10,%eax
80105694:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80105698:	8d 45 fa             	lea    -0x6(%ebp),%eax
8010569b:	0f 01 18             	lidtl  (%eax)
    lidt(idt, sizeof(idt));
}
8010569e:	c9                   	leave  
8010569f:	c3                   	ret    

801056a0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf) {
801056a0:	55                   	push   %ebp
801056a1:	89 e5                	mov    %esp,%ebp
801056a3:	57                   	push   %edi
801056a4:	56                   	push   %esi
801056a5:	53                   	push   %ebx
801056a6:	83 ec 1c             	sub    $0x1c,%esp
801056a9:	8b 7d 08             	mov    0x8(%ebp),%edi
    if (tf->trapno == T_SYSCALL) {
801056ac:	8b 47 30             	mov    0x30(%edi),%eax
801056af:	83 f8 40             	cmp    $0x40,%eax
801056b2:	75 36                	jne    801056ea <trap+0x4a>

        if (myproc()->killed)
801056b4:	e8 e1 dc ff ff       	call   8010339a <myproc>
801056b9:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
801056bd:	74 05                	je     801056c4 <trap+0x24>
            exit();
801056bf:	e8 64 e1 ff ff       	call   80103828 <exit>
        myproc()->tf = tf;
801056c4:	e8 d1 dc ff ff       	call   8010339a <myproc>
801056c9:	89 78 18             	mov    %edi,0x18(%eax)
        syscall();
801056cc:	e8 09 ee ff ff       	call   801044da <syscall>
        if (myproc()->killed)
801056d1:	e8 c4 dc ff ff       	call   8010339a <myproc>
801056d6:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
801056da:	0f 84 ea 01 00 00    	je     801058ca <trap+0x22a>
            exit();
801056e0:	e8 43 e1 ff ff       	call   80103828 <exit>
801056e5:	e9 e0 01 00 00       	jmp    801058ca <trap+0x22a>
        return;
    }

    switch (tf->trapno) {
801056ea:	83 e8 20             	sub    $0x20,%eax
801056ed:	83 f8 1f             	cmp    $0x1f,%eax
801056f0:	0f 87 cf 00 00 00    	ja     801057c5 <trap+0x125>
801056f6:	ff 24 85 58 75 10 80 	jmp    *-0x7fef8aa8(,%eax,4)
        case T_IRQ0 + IRQ_TIMER:
            if (cpuid() == 0) {
801056fd:	e8 7d dc ff ff       	call   8010337f <cpuid>
80105702:	85 c0                	test   %eax,%eax
80105704:	75 62                	jne    80105768 <trap+0xc8>
                acquire(&tickslock);
80105706:	83 ec 0c             	sub    $0xc,%esp
80105709:	68 80 55 11 80       	push   $0x80115580
8010570e:	e8 59 e9 ff ff       	call   8010406c <acquire>
                ticks++;
80105713:	83 05 c0 5d 11 80 01 	addl   $0x1,0x80115dc0
                //added task2
                if(myproc()!=0 && ticks==100){
8010571a:	e8 7b dc ff ff       	call   8010339a <myproc>
8010571f:	83 c4 10             	add    $0x10,%esp
80105722:	85 c0                	test   %eax,%eax
80105724:	74 21                	je     80105747 <trap+0xa7>
80105726:	83 3d c0 5d 11 80 64 	cmpl   $0x64,0x80115dc0
8010572d:	75 18                	jne    80105747 <trap+0xa7>
                    cprintf("process: %d got to 100 ticks\n",myproc()->pid);
8010572f:	e8 66 dc ff ff       	call   8010339a <myproc>
80105734:	83 ec 08             	sub    $0x8,%esp
80105737:	ff 70 10             	pushl  0x10(%eax)
8010573a:	68 96 74 10 80       	push   $0x80107496
8010573f:	e8 a5 ae ff ff       	call   801005e9 <cprintf>
80105744:	83 c4 10             	add    $0x10,%esp
                }
                updatetime();
80105747:	e8 f4 e6 ff ff       	call   80103e40 <updatetime>
                wakeup(&ticks);
8010574c:	83 ec 0c             	sub    $0xc,%esp
8010574f:	68 c0 5d 11 80       	push   $0x80115dc0
80105754:	e8 67 e5 ff ff       	call   80103cc0 <wakeup>
                release(&tickslock);
80105759:	c7 04 24 80 55 11 80 	movl   $0x80115580,(%esp)
80105760:	e8 cc e9 ff ff       	call   80104131 <release>
80105765:	83 c4 10             	add    $0x10,%esp
            }
            lapiceoi();
80105768:	e8 f0 cc ff ff       	call   8010245d <lapiceoi>
            break;
8010576d:	e9 e2 00 00 00       	jmp    80105854 <trap+0x1b4>
        case T_IRQ0 + IRQ_IDE:
            ideintr();
80105772:	e8 80 c6 ff ff       	call   80101df7 <ideintr>
            lapiceoi();
80105777:	e8 e1 cc ff ff       	call   8010245d <lapiceoi>
            break;
8010577c:	e9 d3 00 00 00       	jmp    80105854 <trap+0x1b4>
        case T_IRQ0 + IRQ_IDE + 1:
            // Bochs generates spurious IDE1 interrupts.
            break;
        case T_IRQ0 + IRQ_KBD:
            kbdintr();
80105781:	e8 05 cb ff ff       	call   8010228b <kbdintr>
            lapiceoi();
80105786:	e8 d2 cc ff ff       	call   8010245d <lapiceoi>
            break;
8010578b:	e9 c4 00 00 00       	jmp    80105854 <trap+0x1b4>
        case T_IRQ0 + IRQ_COM1:
            uartintr();
80105790:	e8 74 02 00 00       	call   80105a09 <uartintr>
            lapiceoi();
80105795:	e8 c3 cc ff ff       	call   8010245d <lapiceoi>
            break;
8010579a:	e9 b5 00 00 00       	jmp    80105854 <trap+0x1b4>
        case T_IRQ0 + 7:
        case T_IRQ0 + IRQ_SPURIOUS:
            cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010579f:	8b 77 38             	mov    0x38(%edi),%esi
801057a2:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
801057a6:	e8 d4 db ff ff       	call   8010337f <cpuid>
801057ab:	56                   	push   %esi
801057ac:	53                   	push   %ebx
801057ad:	50                   	push   %eax
801057ae:	68 bc 74 10 80       	push   $0x801074bc
801057b3:	e8 31 ae ff ff       	call   801005e9 <cprintf>
                    cpuid(), tf->cs, tf->eip);
            lapiceoi();
801057b8:	e8 a0 cc ff ff       	call   8010245d <lapiceoi>
            break;
801057bd:	83 c4 10             	add    $0x10,%esp
801057c0:	e9 8f 00 00 00       	jmp    80105854 <trap+0x1b4>

            //PAGEBREAK: 13
        default:
            if (myproc() == 0 || (tf->cs & 3) == 0) {
801057c5:	e8 d0 db ff ff       	call   8010339a <myproc>
801057ca:	85 c0                	test   %eax,%eax
801057cc:	74 06                	je     801057d4 <trap+0x134>
801057ce:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
801057d2:	75 2b                	jne    801057ff <trap+0x15f>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801057d4:	0f 20 d6             	mov    %cr2,%esi
                // In kernel, it must be our mistake.
                cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801057d7:	8b 5f 38             	mov    0x38(%edi),%ebx
801057da:	e8 a0 db ff ff       	call   8010337f <cpuid>
801057df:	83 ec 0c             	sub    $0xc,%esp
801057e2:	56                   	push   %esi
801057e3:	53                   	push   %ebx
801057e4:	50                   	push   %eax
801057e5:	ff 77 30             	pushl  0x30(%edi)
801057e8:	68 e0 74 10 80       	push   $0x801074e0
801057ed:	e8 f7 ad ff ff       	call   801005e9 <cprintf>
                        tf->trapno, cpuid(), tf->eip, rcr2());
                panic("trap");
801057f2:	83 c4 14             	add    $0x14,%esp
801057f5:	68 b4 74 10 80       	push   $0x801074b4
801057fa:	e8 4e ab ff ff       	call   8010034d <panic>
801057ff:	0f 20 d0             	mov    %cr2,%eax
80105802:	89 45 d8             	mov    %eax,-0x28(%ebp)
            }
            // In user space, assume process misbehaved.
            cprintf("pid %d %s: trap %d err %d on cpu %d "
80105805:	8b 77 38             	mov    0x38(%edi),%esi
80105808:	e8 72 db ff ff       	call   8010337f <cpuid>
8010580d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80105810:	8b 5f 34             	mov    0x34(%edi),%ebx
80105813:	8b 4f 30             	mov    0x30(%edi),%ecx
80105816:	89 4d e0             	mov    %ecx,-0x20(%ebp)
                            "eip 0x%x addr 0x%x--kill proc\n",
                    myproc()->pid, myproc()->name, tf->trapno,
80105819:	e8 7c db ff ff       	call   8010339a <myproc>
8010581e:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105821:	e8 74 db ff ff       	call   8010339a <myproc>
                cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
                        tf->trapno, cpuid(), tf->eip, rcr2());
                panic("trap");
            }
            // In user space, assume process misbehaved.
            cprintf("pid %d %s: trap %d err %d on cpu %d "
80105826:	ff 75 d8             	pushl  -0x28(%ebp)
80105829:	56                   	push   %esi
8010582a:	ff 75 e4             	pushl  -0x1c(%ebp)
8010582d:	53                   	push   %ebx
8010582e:	ff 75 e0             	pushl  -0x20(%ebp)
                            "eip 0x%x addr 0x%x--kill proc\n",
                    myproc()->pid, myproc()->name, tf->trapno,
80105831:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105834:	83 c2 6c             	add    $0x6c,%edx
                cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
                        tf->trapno, cpuid(), tf->eip, rcr2());
                panic("trap");
            }
            // In user space, assume process misbehaved.
            cprintf("pid %d %s: trap %d err %d on cpu %d "
80105837:	52                   	push   %edx
80105838:	ff 70 10             	pushl  0x10(%eax)
8010583b:	68 14 75 10 80       	push   $0x80107514
80105840:	e8 a4 ad ff ff       	call   801005e9 <cprintf>
                            "eip 0x%x addr 0x%x--kill proc\n",
                    myproc()->pid, myproc()->name, tf->trapno,
                    tf->err, cpuid(), tf->eip, rcr2());
            myproc()->killed = 1;
80105845:	83 c4 20             	add    $0x20,%esp
80105848:	e8 4d db ff ff       	call   8010339a <myproc>
8010584d:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
    }

    // Force process exit if it has been killed and is in user space.
    // (If it is still executing in the kernel, let it keep running
    // until it gets to the regular system call return.)
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80105854:	e8 41 db ff ff       	call   8010339a <myproc>
80105859:	85 c0                	test   %eax,%eax
8010585b:	74 1d                	je     8010587a <trap+0x1da>
8010585d:	e8 38 db ff ff       	call   8010339a <myproc>
80105862:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80105866:	74 12                	je     8010587a <trap+0x1da>
80105868:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
8010586c:	83 e0 03             	and    $0x3,%eax
8010586f:	66 83 f8 03          	cmp    $0x3,%ax
80105873:	75 05                	jne    8010587a <trap+0x1da>
        exit();
80105875:	e8 ae df ff ff       	call   80103828 <exit>
    // Force process to give up CPU on clock tick.
    // If interrupts were on while locks held, would need to check nlock.
    //** ticks%QUANTUM==0 added task3

#ifndef FCFS
    if (myproc() && myproc()->state == RUNNING &&
8010587a:	e8 1b db ff ff       	call   8010339a <myproc>
8010587f:	85 c0                	test   %eax,%eax
80105881:	74 21                	je     801058a4 <trap+0x204>
80105883:	e8 12 db ff ff       	call   8010339a <myproc>
80105888:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
8010588c:	75 16                	jne    801058a4 <trap+0x204>
8010588e:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80105892:	75 10                	jne    801058a4 <trap+0x204>
        tf->trapno == T_IRQ0 + IRQ_TIMER && myproc()->trem<=0) {
80105894:	e8 01 db ff ff       	call   8010339a <myproc>
80105899:	83 78 7c 00          	cmpl   $0x0,0x7c(%eax)
8010589d:	7f 05                	jg     801058a4 <trap+0x204>
        yield();
8010589f:	e8 50 e0 ff ff       	call   801038f4 <yield>
    }

#endif

    // Check if the process has been killed since we yielded
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
801058a4:	e8 f1 da ff ff       	call   8010339a <myproc>
801058a9:	85 c0                	test   %eax,%eax
801058ab:	74 1d                	je     801058ca <trap+0x22a>
801058ad:	e8 e8 da ff ff       	call   8010339a <myproc>
801058b2:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
801058b6:	74 12                	je     801058ca <trap+0x22a>
801058b8:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
801058bc:	83 e0 03             	and    $0x3,%eax
801058bf:	66 83 f8 03          	cmp    $0x3,%ax
801058c3:	75 05                	jne    801058ca <trap+0x22a>
        exit();
801058c5:	e8 5e df ff ff       	call   80103828 <exit>
}
801058ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
801058cd:	5b                   	pop    %ebx
801058ce:	5e                   	pop    %esi
801058cf:	5f                   	pop    %edi
801058d0:	5d                   	pop    %ebp
801058d1:	c3                   	ret    

801058d2 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
801058d2:	55                   	push   %ebp
801058d3:	89 e5                	mov    %esp,%ebp
  if(!uart)
801058d5:	83 3d c8 a6 10 80 00 	cmpl   $0x0,0x8010a6c8
801058dc:	74 15                	je     801058f3 <uartgetc+0x21>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801058de:	ba fd 03 00 00       	mov    $0x3fd,%edx
801058e3:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801058e4:	a8 01                	test   $0x1,%al
801058e6:	74 12                	je     801058fa <uartgetc+0x28>
801058e8:	ba f8 03 00 00       	mov    $0x3f8,%edx
801058ed:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801058ee:	0f b6 c0             	movzbl %al,%eax
801058f1:	eb 0c                	jmp    801058ff <uartgetc+0x2d>

static int
uartgetc(void)
{
  if(!uart)
    return -1;
801058f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058f8:	eb 05                	jmp    801058ff <uartgetc+0x2d>
  if(!(inb(COM1+5) & 0x01))
    return -1;
801058fa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return inb(COM1+0);
}
801058ff:	5d                   	pop    %ebp
80105900:	c3                   	ret    

80105901 <uartputc>:
void
uartputc(int c)
{
  int i;

  if(!uart)
80105901:	83 3d c8 a6 10 80 00 	cmpl   $0x0,0x8010a6c8
80105908:	74 54                	je     8010595e <uartputc+0x5d>
    uartputc(*p);
}

void
uartputc(int c)
{
8010590a:	55                   	push   %ebp
8010590b:	89 e5                	mov    %esp,%ebp
8010590d:	56                   	push   %esi
8010590e:	53                   	push   %ebx
8010590f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105914:	ec                   	in     (%dx),%al
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105915:	a8 20                	test   $0x20,%al
80105917:	74 26                	je     8010593f <uartputc+0x3e>
80105919:	eb 19                	jmp    80105934 <uartputc+0x33>
    microdelay(10);
8010591b:	83 ec 0c             	sub    $0xc,%esp
8010591e:	6a 0a                	push   $0xa
80105920:	e8 56 cb ff ff       	call   8010247b <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105925:	83 c4 10             	add    $0x10,%esp
80105928:	83 eb 01             	sub    $0x1,%ebx
8010592b:	74 07                	je     80105934 <uartputc+0x33>
8010592d:	89 f2                	mov    %esi,%edx
8010592f:	ec                   	in     (%dx),%al
80105930:	a8 20                	test   $0x20,%al
80105932:	74 e7                	je     8010591b <uartputc+0x1a>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105934:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105939:	8b 45 08             	mov    0x8(%ebp),%eax
8010593c:	ee                   	out    %al,(%dx)
8010593d:	eb 19                	jmp    80105958 <uartputc+0x57>
    microdelay(10);
8010593f:	83 ec 0c             	sub    $0xc,%esp
80105942:	6a 0a                	push   $0xa
80105944:	e8 32 cb ff ff       	call   8010247b <microdelay>
80105949:	83 c4 10             	add    $0x10,%esp
8010594c:	bb 7f 00 00 00       	mov    $0x7f,%ebx
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105951:	be fd 03 00 00       	mov    $0x3fd,%esi
80105956:	eb d5                	jmp    8010592d <uartputc+0x2c>
  outb(COM1+0, c);
}
80105958:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010595b:	5b                   	pop    %ebx
8010595c:	5e                   	pop    %esi
8010595d:	5d                   	pop    %ebp
8010595e:	f3 c3                	repz ret 

80105960 <uartinit>:
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105960:	ba fa 03 00 00       	mov    $0x3fa,%edx
80105965:	b8 00 00 00 00       	mov    $0x0,%eax
8010596a:	ee                   	out    %al,(%dx)
8010596b:	ba fb 03 00 00       	mov    $0x3fb,%edx
80105970:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105975:	ee                   	out    %al,(%dx)
80105976:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010597b:	b8 0c 00 00 00       	mov    $0xc,%eax
80105980:	ee                   	out    %al,(%dx)
80105981:	ba f9 03 00 00       	mov    $0x3f9,%edx
80105986:	b8 00 00 00 00       	mov    $0x0,%eax
8010598b:	ee                   	out    %al,(%dx)
8010598c:	ba fb 03 00 00       	mov    $0x3fb,%edx
80105991:	b8 03 00 00 00       	mov    $0x3,%eax
80105996:	ee                   	out    %al,(%dx)
80105997:	ba fc 03 00 00       	mov    $0x3fc,%edx
8010599c:	b8 00 00 00 00       	mov    $0x0,%eax
801059a1:	ee                   	out    %al,(%dx)
801059a2:	ba f9 03 00 00       	mov    $0x3f9,%edx
801059a7:	b8 01 00 00 00       	mov    $0x1,%eax
801059ac:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801059ad:	ba fd 03 00 00       	mov    $0x3fd,%edx
801059b2:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
801059b3:	3c ff                	cmp    $0xff,%al
801059b5:	74 50                	je     80105a07 <uartinit+0xa7>

static int uart;    // is there a uart?

void
uartinit(void)
{
801059b7:	55                   	push   %ebp
801059b8:	89 e5                	mov    %esp,%ebp
801059ba:	53                   	push   %ebx
801059bb:	83 ec 0c             	sub    $0xc,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
    return;
  uart = 1;
801059be:	c7 05 c8 a6 10 80 01 	movl   $0x1,0x8010a6c8
801059c5:	00 00 00 
801059c8:	ba fa 03 00 00       	mov    $0x3fa,%edx
801059cd:	ec                   	in     (%dx),%al
801059ce:	ba f8 03 00 00       	mov    $0x3f8,%edx
801059d3:	ec                   	in     (%dx),%al

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);
801059d4:	6a 00                	push   $0x0
801059d6:	6a 04                	push   $0x4
801059d8:	e8 2c c6 ff ff       	call   80102009 <ioapicenable>
801059dd:	83 c4 10             	add    $0x10,%esp
801059e0:	b8 78 00 00 00       	mov    $0x78,%eax
801059e5:	bb d8 75 10 80       	mov    $0x801075d8,%ebx

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
801059ea:	83 ec 0c             	sub    $0xc,%esp
801059ed:	0f be c0             	movsbl %al,%eax
801059f0:	50                   	push   %eax
801059f1:	e8 0b ff ff ff       	call   80105901 <uartputc>
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801059f6:	83 c3 01             	add    $0x1,%ebx
801059f9:	0f b6 03             	movzbl (%ebx),%eax
801059fc:	83 c4 10             	add    $0x10,%esp
801059ff:	84 c0                	test   %al,%al
80105a01:	75 e7                	jne    801059ea <uartinit+0x8a>
    uartputc(*p);
}
80105a03:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a06:	c9                   	leave  
80105a07:	f3 c3                	repz ret 

80105a09 <uartintr>:
  return inb(COM1+0);
}

void
uartintr(void)
{
80105a09:	55                   	push   %ebp
80105a0a:	89 e5                	mov    %esp,%ebp
80105a0c:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105a0f:	68 d2 58 10 80       	push   $0x801058d2
80105a14:	e8 10 ad ff ff       	call   80100729 <consoleintr>
}
80105a19:	83 c4 10             	add    $0x10,%esp
80105a1c:	c9                   	leave  
80105a1d:	c3                   	ret    

80105a1e <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105a1e:	6a 00                	push   $0x0
  pushl $0
80105a20:	6a 00                	push   $0x0
  jmp alltraps
80105a22:	e9 aa fb ff ff       	jmp    801055d1 <alltraps>

80105a27 <vector1>:
.globl vector1
vector1:
  pushl $0
80105a27:	6a 00                	push   $0x0
  pushl $1
80105a29:	6a 01                	push   $0x1
  jmp alltraps
80105a2b:	e9 a1 fb ff ff       	jmp    801055d1 <alltraps>

80105a30 <vector2>:
.globl vector2
vector2:
  pushl $0
80105a30:	6a 00                	push   $0x0
  pushl $2
80105a32:	6a 02                	push   $0x2
  jmp alltraps
80105a34:	e9 98 fb ff ff       	jmp    801055d1 <alltraps>

80105a39 <vector3>:
.globl vector3
vector3:
  pushl $0
80105a39:	6a 00                	push   $0x0
  pushl $3
80105a3b:	6a 03                	push   $0x3
  jmp alltraps
80105a3d:	e9 8f fb ff ff       	jmp    801055d1 <alltraps>

80105a42 <vector4>:
.globl vector4
vector4:
  pushl $0
80105a42:	6a 00                	push   $0x0
  pushl $4
80105a44:	6a 04                	push   $0x4
  jmp alltraps
80105a46:	e9 86 fb ff ff       	jmp    801055d1 <alltraps>

80105a4b <vector5>:
.globl vector5
vector5:
  pushl $0
80105a4b:	6a 00                	push   $0x0
  pushl $5
80105a4d:	6a 05                	push   $0x5
  jmp alltraps
80105a4f:	e9 7d fb ff ff       	jmp    801055d1 <alltraps>

80105a54 <vector6>:
.globl vector6
vector6:
  pushl $0
80105a54:	6a 00                	push   $0x0
  pushl $6
80105a56:	6a 06                	push   $0x6
  jmp alltraps
80105a58:	e9 74 fb ff ff       	jmp    801055d1 <alltraps>

80105a5d <vector7>:
.globl vector7
vector7:
  pushl $0
80105a5d:	6a 00                	push   $0x0
  pushl $7
80105a5f:	6a 07                	push   $0x7
  jmp alltraps
80105a61:	e9 6b fb ff ff       	jmp    801055d1 <alltraps>

80105a66 <vector8>:
.globl vector8
vector8:
  pushl $8
80105a66:	6a 08                	push   $0x8
  jmp alltraps
80105a68:	e9 64 fb ff ff       	jmp    801055d1 <alltraps>

80105a6d <vector9>:
.globl vector9
vector9:
  pushl $0
80105a6d:	6a 00                	push   $0x0
  pushl $9
80105a6f:	6a 09                	push   $0x9
  jmp alltraps
80105a71:	e9 5b fb ff ff       	jmp    801055d1 <alltraps>

80105a76 <vector10>:
.globl vector10
vector10:
  pushl $10
80105a76:	6a 0a                	push   $0xa
  jmp alltraps
80105a78:	e9 54 fb ff ff       	jmp    801055d1 <alltraps>

80105a7d <vector11>:
.globl vector11
vector11:
  pushl $11
80105a7d:	6a 0b                	push   $0xb
  jmp alltraps
80105a7f:	e9 4d fb ff ff       	jmp    801055d1 <alltraps>

80105a84 <vector12>:
.globl vector12
vector12:
  pushl $12
80105a84:	6a 0c                	push   $0xc
  jmp alltraps
80105a86:	e9 46 fb ff ff       	jmp    801055d1 <alltraps>

80105a8b <vector13>:
.globl vector13
vector13:
  pushl $13
80105a8b:	6a 0d                	push   $0xd
  jmp alltraps
80105a8d:	e9 3f fb ff ff       	jmp    801055d1 <alltraps>

80105a92 <vector14>:
.globl vector14
vector14:
  pushl $14
80105a92:	6a 0e                	push   $0xe
  jmp alltraps
80105a94:	e9 38 fb ff ff       	jmp    801055d1 <alltraps>

80105a99 <vector15>:
.globl vector15
vector15:
  pushl $0
80105a99:	6a 00                	push   $0x0
  pushl $15
80105a9b:	6a 0f                	push   $0xf
  jmp alltraps
80105a9d:	e9 2f fb ff ff       	jmp    801055d1 <alltraps>

80105aa2 <vector16>:
.globl vector16
vector16:
  pushl $0
80105aa2:	6a 00                	push   $0x0
  pushl $16
80105aa4:	6a 10                	push   $0x10
  jmp alltraps
80105aa6:	e9 26 fb ff ff       	jmp    801055d1 <alltraps>

80105aab <vector17>:
.globl vector17
vector17:
  pushl $17
80105aab:	6a 11                	push   $0x11
  jmp alltraps
80105aad:	e9 1f fb ff ff       	jmp    801055d1 <alltraps>

80105ab2 <vector18>:
.globl vector18
vector18:
  pushl $0
80105ab2:	6a 00                	push   $0x0
  pushl $18
80105ab4:	6a 12                	push   $0x12
  jmp alltraps
80105ab6:	e9 16 fb ff ff       	jmp    801055d1 <alltraps>

80105abb <vector19>:
.globl vector19
vector19:
  pushl $0
80105abb:	6a 00                	push   $0x0
  pushl $19
80105abd:	6a 13                	push   $0x13
  jmp alltraps
80105abf:	e9 0d fb ff ff       	jmp    801055d1 <alltraps>

80105ac4 <vector20>:
.globl vector20
vector20:
  pushl $0
80105ac4:	6a 00                	push   $0x0
  pushl $20
80105ac6:	6a 14                	push   $0x14
  jmp alltraps
80105ac8:	e9 04 fb ff ff       	jmp    801055d1 <alltraps>

80105acd <vector21>:
.globl vector21
vector21:
  pushl $0
80105acd:	6a 00                	push   $0x0
  pushl $21
80105acf:	6a 15                	push   $0x15
  jmp alltraps
80105ad1:	e9 fb fa ff ff       	jmp    801055d1 <alltraps>

80105ad6 <vector22>:
.globl vector22
vector22:
  pushl $0
80105ad6:	6a 00                	push   $0x0
  pushl $22
80105ad8:	6a 16                	push   $0x16
  jmp alltraps
80105ada:	e9 f2 fa ff ff       	jmp    801055d1 <alltraps>

80105adf <vector23>:
.globl vector23
vector23:
  pushl $0
80105adf:	6a 00                	push   $0x0
  pushl $23
80105ae1:	6a 17                	push   $0x17
  jmp alltraps
80105ae3:	e9 e9 fa ff ff       	jmp    801055d1 <alltraps>

80105ae8 <vector24>:
.globl vector24
vector24:
  pushl $0
80105ae8:	6a 00                	push   $0x0
  pushl $24
80105aea:	6a 18                	push   $0x18
  jmp alltraps
80105aec:	e9 e0 fa ff ff       	jmp    801055d1 <alltraps>

80105af1 <vector25>:
.globl vector25
vector25:
  pushl $0
80105af1:	6a 00                	push   $0x0
  pushl $25
80105af3:	6a 19                	push   $0x19
  jmp alltraps
80105af5:	e9 d7 fa ff ff       	jmp    801055d1 <alltraps>

80105afa <vector26>:
.globl vector26
vector26:
  pushl $0
80105afa:	6a 00                	push   $0x0
  pushl $26
80105afc:	6a 1a                	push   $0x1a
  jmp alltraps
80105afe:	e9 ce fa ff ff       	jmp    801055d1 <alltraps>

80105b03 <vector27>:
.globl vector27
vector27:
  pushl $0
80105b03:	6a 00                	push   $0x0
  pushl $27
80105b05:	6a 1b                	push   $0x1b
  jmp alltraps
80105b07:	e9 c5 fa ff ff       	jmp    801055d1 <alltraps>

80105b0c <vector28>:
.globl vector28
vector28:
  pushl $0
80105b0c:	6a 00                	push   $0x0
  pushl $28
80105b0e:	6a 1c                	push   $0x1c
  jmp alltraps
80105b10:	e9 bc fa ff ff       	jmp    801055d1 <alltraps>

80105b15 <vector29>:
.globl vector29
vector29:
  pushl $0
80105b15:	6a 00                	push   $0x0
  pushl $29
80105b17:	6a 1d                	push   $0x1d
  jmp alltraps
80105b19:	e9 b3 fa ff ff       	jmp    801055d1 <alltraps>

80105b1e <vector30>:
.globl vector30
vector30:
  pushl $0
80105b1e:	6a 00                	push   $0x0
  pushl $30
80105b20:	6a 1e                	push   $0x1e
  jmp alltraps
80105b22:	e9 aa fa ff ff       	jmp    801055d1 <alltraps>

80105b27 <vector31>:
.globl vector31
vector31:
  pushl $0
80105b27:	6a 00                	push   $0x0
  pushl $31
80105b29:	6a 1f                	push   $0x1f
  jmp alltraps
80105b2b:	e9 a1 fa ff ff       	jmp    801055d1 <alltraps>

80105b30 <vector32>:
.globl vector32
vector32:
  pushl $0
80105b30:	6a 00                	push   $0x0
  pushl $32
80105b32:	6a 20                	push   $0x20
  jmp alltraps
80105b34:	e9 98 fa ff ff       	jmp    801055d1 <alltraps>

80105b39 <vector33>:
.globl vector33
vector33:
  pushl $0
80105b39:	6a 00                	push   $0x0
  pushl $33
80105b3b:	6a 21                	push   $0x21
  jmp alltraps
80105b3d:	e9 8f fa ff ff       	jmp    801055d1 <alltraps>

80105b42 <vector34>:
.globl vector34
vector34:
  pushl $0
80105b42:	6a 00                	push   $0x0
  pushl $34
80105b44:	6a 22                	push   $0x22
  jmp alltraps
80105b46:	e9 86 fa ff ff       	jmp    801055d1 <alltraps>

80105b4b <vector35>:
.globl vector35
vector35:
  pushl $0
80105b4b:	6a 00                	push   $0x0
  pushl $35
80105b4d:	6a 23                	push   $0x23
  jmp alltraps
80105b4f:	e9 7d fa ff ff       	jmp    801055d1 <alltraps>

80105b54 <vector36>:
.globl vector36
vector36:
  pushl $0
80105b54:	6a 00                	push   $0x0
  pushl $36
80105b56:	6a 24                	push   $0x24
  jmp alltraps
80105b58:	e9 74 fa ff ff       	jmp    801055d1 <alltraps>

80105b5d <vector37>:
.globl vector37
vector37:
  pushl $0
80105b5d:	6a 00                	push   $0x0
  pushl $37
80105b5f:	6a 25                	push   $0x25
  jmp alltraps
80105b61:	e9 6b fa ff ff       	jmp    801055d1 <alltraps>

80105b66 <vector38>:
.globl vector38
vector38:
  pushl $0
80105b66:	6a 00                	push   $0x0
  pushl $38
80105b68:	6a 26                	push   $0x26
  jmp alltraps
80105b6a:	e9 62 fa ff ff       	jmp    801055d1 <alltraps>

80105b6f <vector39>:
.globl vector39
vector39:
  pushl $0
80105b6f:	6a 00                	push   $0x0
  pushl $39
80105b71:	6a 27                	push   $0x27
  jmp alltraps
80105b73:	e9 59 fa ff ff       	jmp    801055d1 <alltraps>

80105b78 <vector40>:
.globl vector40
vector40:
  pushl $0
80105b78:	6a 00                	push   $0x0
  pushl $40
80105b7a:	6a 28                	push   $0x28
  jmp alltraps
80105b7c:	e9 50 fa ff ff       	jmp    801055d1 <alltraps>

80105b81 <vector41>:
.globl vector41
vector41:
  pushl $0
80105b81:	6a 00                	push   $0x0
  pushl $41
80105b83:	6a 29                	push   $0x29
  jmp alltraps
80105b85:	e9 47 fa ff ff       	jmp    801055d1 <alltraps>

80105b8a <vector42>:
.globl vector42
vector42:
  pushl $0
80105b8a:	6a 00                	push   $0x0
  pushl $42
80105b8c:	6a 2a                	push   $0x2a
  jmp alltraps
80105b8e:	e9 3e fa ff ff       	jmp    801055d1 <alltraps>

80105b93 <vector43>:
.globl vector43
vector43:
  pushl $0
80105b93:	6a 00                	push   $0x0
  pushl $43
80105b95:	6a 2b                	push   $0x2b
  jmp alltraps
80105b97:	e9 35 fa ff ff       	jmp    801055d1 <alltraps>

80105b9c <vector44>:
.globl vector44
vector44:
  pushl $0
80105b9c:	6a 00                	push   $0x0
  pushl $44
80105b9e:	6a 2c                	push   $0x2c
  jmp alltraps
80105ba0:	e9 2c fa ff ff       	jmp    801055d1 <alltraps>

80105ba5 <vector45>:
.globl vector45
vector45:
  pushl $0
80105ba5:	6a 00                	push   $0x0
  pushl $45
80105ba7:	6a 2d                	push   $0x2d
  jmp alltraps
80105ba9:	e9 23 fa ff ff       	jmp    801055d1 <alltraps>

80105bae <vector46>:
.globl vector46
vector46:
  pushl $0
80105bae:	6a 00                	push   $0x0
  pushl $46
80105bb0:	6a 2e                	push   $0x2e
  jmp alltraps
80105bb2:	e9 1a fa ff ff       	jmp    801055d1 <alltraps>

80105bb7 <vector47>:
.globl vector47
vector47:
  pushl $0
80105bb7:	6a 00                	push   $0x0
  pushl $47
80105bb9:	6a 2f                	push   $0x2f
  jmp alltraps
80105bbb:	e9 11 fa ff ff       	jmp    801055d1 <alltraps>

80105bc0 <vector48>:
.globl vector48
vector48:
  pushl $0
80105bc0:	6a 00                	push   $0x0
  pushl $48
80105bc2:	6a 30                	push   $0x30
  jmp alltraps
80105bc4:	e9 08 fa ff ff       	jmp    801055d1 <alltraps>

80105bc9 <vector49>:
.globl vector49
vector49:
  pushl $0
80105bc9:	6a 00                	push   $0x0
  pushl $49
80105bcb:	6a 31                	push   $0x31
  jmp alltraps
80105bcd:	e9 ff f9 ff ff       	jmp    801055d1 <alltraps>

80105bd2 <vector50>:
.globl vector50
vector50:
  pushl $0
80105bd2:	6a 00                	push   $0x0
  pushl $50
80105bd4:	6a 32                	push   $0x32
  jmp alltraps
80105bd6:	e9 f6 f9 ff ff       	jmp    801055d1 <alltraps>

80105bdb <vector51>:
.globl vector51
vector51:
  pushl $0
80105bdb:	6a 00                	push   $0x0
  pushl $51
80105bdd:	6a 33                	push   $0x33
  jmp alltraps
80105bdf:	e9 ed f9 ff ff       	jmp    801055d1 <alltraps>

80105be4 <vector52>:
.globl vector52
vector52:
  pushl $0
80105be4:	6a 00                	push   $0x0
  pushl $52
80105be6:	6a 34                	push   $0x34
  jmp alltraps
80105be8:	e9 e4 f9 ff ff       	jmp    801055d1 <alltraps>

80105bed <vector53>:
.globl vector53
vector53:
  pushl $0
80105bed:	6a 00                	push   $0x0
  pushl $53
80105bef:	6a 35                	push   $0x35
  jmp alltraps
80105bf1:	e9 db f9 ff ff       	jmp    801055d1 <alltraps>

80105bf6 <vector54>:
.globl vector54
vector54:
  pushl $0
80105bf6:	6a 00                	push   $0x0
  pushl $54
80105bf8:	6a 36                	push   $0x36
  jmp alltraps
80105bfa:	e9 d2 f9 ff ff       	jmp    801055d1 <alltraps>

80105bff <vector55>:
.globl vector55
vector55:
  pushl $0
80105bff:	6a 00                	push   $0x0
  pushl $55
80105c01:	6a 37                	push   $0x37
  jmp alltraps
80105c03:	e9 c9 f9 ff ff       	jmp    801055d1 <alltraps>

80105c08 <vector56>:
.globl vector56
vector56:
  pushl $0
80105c08:	6a 00                	push   $0x0
  pushl $56
80105c0a:	6a 38                	push   $0x38
  jmp alltraps
80105c0c:	e9 c0 f9 ff ff       	jmp    801055d1 <alltraps>

80105c11 <vector57>:
.globl vector57
vector57:
  pushl $0
80105c11:	6a 00                	push   $0x0
  pushl $57
80105c13:	6a 39                	push   $0x39
  jmp alltraps
80105c15:	e9 b7 f9 ff ff       	jmp    801055d1 <alltraps>

80105c1a <vector58>:
.globl vector58
vector58:
  pushl $0
80105c1a:	6a 00                	push   $0x0
  pushl $58
80105c1c:	6a 3a                	push   $0x3a
  jmp alltraps
80105c1e:	e9 ae f9 ff ff       	jmp    801055d1 <alltraps>

80105c23 <vector59>:
.globl vector59
vector59:
  pushl $0
80105c23:	6a 00                	push   $0x0
  pushl $59
80105c25:	6a 3b                	push   $0x3b
  jmp alltraps
80105c27:	e9 a5 f9 ff ff       	jmp    801055d1 <alltraps>

80105c2c <vector60>:
.globl vector60
vector60:
  pushl $0
80105c2c:	6a 00                	push   $0x0
  pushl $60
80105c2e:	6a 3c                	push   $0x3c
  jmp alltraps
80105c30:	e9 9c f9 ff ff       	jmp    801055d1 <alltraps>

80105c35 <vector61>:
.globl vector61
vector61:
  pushl $0
80105c35:	6a 00                	push   $0x0
  pushl $61
80105c37:	6a 3d                	push   $0x3d
  jmp alltraps
80105c39:	e9 93 f9 ff ff       	jmp    801055d1 <alltraps>

80105c3e <vector62>:
.globl vector62
vector62:
  pushl $0
80105c3e:	6a 00                	push   $0x0
  pushl $62
80105c40:	6a 3e                	push   $0x3e
  jmp alltraps
80105c42:	e9 8a f9 ff ff       	jmp    801055d1 <alltraps>

80105c47 <vector63>:
.globl vector63
vector63:
  pushl $0
80105c47:	6a 00                	push   $0x0
  pushl $63
80105c49:	6a 3f                	push   $0x3f
  jmp alltraps
80105c4b:	e9 81 f9 ff ff       	jmp    801055d1 <alltraps>

80105c50 <vector64>:
.globl vector64
vector64:
  pushl $0
80105c50:	6a 00                	push   $0x0
  pushl $64
80105c52:	6a 40                	push   $0x40
  jmp alltraps
80105c54:	e9 78 f9 ff ff       	jmp    801055d1 <alltraps>

80105c59 <vector65>:
.globl vector65
vector65:
  pushl $0
80105c59:	6a 00                	push   $0x0
  pushl $65
80105c5b:	6a 41                	push   $0x41
  jmp alltraps
80105c5d:	e9 6f f9 ff ff       	jmp    801055d1 <alltraps>

80105c62 <vector66>:
.globl vector66
vector66:
  pushl $0
80105c62:	6a 00                	push   $0x0
  pushl $66
80105c64:	6a 42                	push   $0x42
  jmp alltraps
80105c66:	e9 66 f9 ff ff       	jmp    801055d1 <alltraps>

80105c6b <vector67>:
.globl vector67
vector67:
  pushl $0
80105c6b:	6a 00                	push   $0x0
  pushl $67
80105c6d:	6a 43                	push   $0x43
  jmp alltraps
80105c6f:	e9 5d f9 ff ff       	jmp    801055d1 <alltraps>

80105c74 <vector68>:
.globl vector68
vector68:
  pushl $0
80105c74:	6a 00                	push   $0x0
  pushl $68
80105c76:	6a 44                	push   $0x44
  jmp alltraps
80105c78:	e9 54 f9 ff ff       	jmp    801055d1 <alltraps>

80105c7d <vector69>:
.globl vector69
vector69:
  pushl $0
80105c7d:	6a 00                	push   $0x0
  pushl $69
80105c7f:	6a 45                	push   $0x45
  jmp alltraps
80105c81:	e9 4b f9 ff ff       	jmp    801055d1 <alltraps>

80105c86 <vector70>:
.globl vector70
vector70:
  pushl $0
80105c86:	6a 00                	push   $0x0
  pushl $70
80105c88:	6a 46                	push   $0x46
  jmp alltraps
80105c8a:	e9 42 f9 ff ff       	jmp    801055d1 <alltraps>

80105c8f <vector71>:
.globl vector71
vector71:
  pushl $0
80105c8f:	6a 00                	push   $0x0
  pushl $71
80105c91:	6a 47                	push   $0x47
  jmp alltraps
80105c93:	e9 39 f9 ff ff       	jmp    801055d1 <alltraps>

80105c98 <vector72>:
.globl vector72
vector72:
  pushl $0
80105c98:	6a 00                	push   $0x0
  pushl $72
80105c9a:	6a 48                	push   $0x48
  jmp alltraps
80105c9c:	e9 30 f9 ff ff       	jmp    801055d1 <alltraps>

80105ca1 <vector73>:
.globl vector73
vector73:
  pushl $0
80105ca1:	6a 00                	push   $0x0
  pushl $73
80105ca3:	6a 49                	push   $0x49
  jmp alltraps
80105ca5:	e9 27 f9 ff ff       	jmp    801055d1 <alltraps>

80105caa <vector74>:
.globl vector74
vector74:
  pushl $0
80105caa:	6a 00                	push   $0x0
  pushl $74
80105cac:	6a 4a                	push   $0x4a
  jmp alltraps
80105cae:	e9 1e f9 ff ff       	jmp    801055d1 <alltraps>

80105cb3 <vector75>:
.globl vector75
vector75:
  pushl $0
80105cb3:	6a 00                	push   $0x0
  pushl $75
80105cb5:	6a 4b                	push   $0x4b
  jmp alltraps
80105cb7:	e9 15 f9 ff ff       	jmp    801055d1 <alltraps>

80105cbc <vector76>:
.globl vector76
vector76:
  pushl $0
80105cbc:	6a 00                	push   $0x0
  pushl $76
80105cbe:	6a 4c                	push   $0x4c
  jmp alltraps
80105cc0:	e9 0c f9 ff ff       	jmp    801055d1 <alltraps>

80105cc5 <vector77>:
.globl vector77
vector77:
  pushl $0
80105cc5:	6a 00                	push   $0x0
  pushl $77
80105cc7:	6a 4d                	push   $0x4d
  jmp alltraps
80105cc9:	e9 03 f9 ff ff       	jmp    801055d1 <alltraps>

80105cce <vector78>:
.globl vector78
vector78:
  pushl $0
80105cce:	6a 00                	push   $0x0
  pushl $78
80105cd0:	6a 4e                	push   $0x4e
  jmp alltraps
80105cd2:	e9 fa f8 ff ff       	jmp    801055d1 <alltraps>

80105cd7 <vector79>:
.globl vector79
vector79:
  pushl $0
80105cd7:	6a 00                	push   $0x0
  pushl $79
80105cd9:	6a 4f                	push   $0x4f
  jmp alltraps
80105cdb:	e9 f1 f8 ff ff       	jmp    801055d1 <alltraps>

80105ce0 <vector80>:
.globl vector80
vector80:
  pushl $0
80105ce0:	6a 00                	push   $0x0
  pushl $80
80105ce2:	6a 50                	push   $0x50
  jmp alltraps
80105ce4:	e9 e8 f8 ff ff       	jmp    801055d1 <alltraps>

80105ce9 <vector81>:
.globl vector81
vector81:
  pushl $0
80105ce9:	6a 00                	push   $0x0
  pushl $81
80105ceb:	6a 51                	push   $0x51
  jmp alltraps
80105ced:	e9 df f8 ff ff       	jmp    801055d1 <alltraps>

80105cf2 <vector82>:
.globl vector82
vector82:
  pushl $0
80105cf2:	6a 00                	push   $0x0
  pushl $82
80105cf4:	6a 52                	push   $0x52
  jmp alltraps
80105cf6:	e9 d6 f8 ff ff       	jmp    801055d1 <alltraps>

80105cfb <vector83>:
.globl vector83
vector83:
  pushl $0
80105cfb:	6a 00                	push   $0x0
  pushl $83
80105cfd:	6a 53                	push   $0x53
  jmp alltraps
80105cff:	e9 cd f8 ff ff       	jmp    801055d1 <alltraps>

80105d04 <vector84>:
.globl vector84
vector84:
  pushl $0
80105d04:	6a 00                	push   $0x0
  pushl $84
80105d06:	6a 54                	push   $0x54
  jmp alltraps
80105d08:	e9 c4 f8 ff ff       	jmp    801055d1 <alltraps>

80105d0d <vector85>:
.globl vector85
vector85:
  pushl $0
80105d0d:	6a 00                	push   $0x0
  pushl $85
80105d0f:	6a 55                	push   $0x55
  jmp alltraps
80105d11:	e9 bb f8 ff ff       	jmp    801055d1 <alltraps>

80105d16 <vector86>:
.globl vector86
vector86:
  pushl $0
80105d16:	6a 00                	push   $0x0
  pushl $86
80105d18:	6a 56                	push   $0x56
  jmp alltraps
80105d1a:	e9 b2 f8 ff ff       	jmp    801055d1 <alltraps>

80105d1f <vector87>:
.globl vector87
vector87:
  pushl $0
80105d1f:	6a 00                	push   $0x0
  pushl $87
80105d21:	6a 57                	push   $0x57
  jmp alltraps
80105d23:	e9 a9 f8 ff ff       	jmp    801055d1 <alltraps>

80105d28 <vector88>:
.globl vector88
vector88:
  pushl $0
80105d28:	6a 00                	push   $0x0
  pushl $88
80105d2a:	6a 58                	push   $0x58
  jmp alltraps
80105d2c:	e9 a0 f8 ff ff       	jmp    801055d1 <alltraps>

80105d31 <vector89>:
.globl vector89
vector89:
  pushl $0
80105d31:	6a 00                	push   $0x0
  pushl $89
80105d33:	6a 59                	push   $0x59
  jmp alltraps
80105d35:	e9 97 f8 ff ff       	jmp    801055d1 <alltraps>

80105d3a <vector90>:
.globl vector90
vector90:
  pushl $0
80105d3a:	6a 00                	push   $0x0
  pushl $90
80105d3c:	6a 5a                	push   $0x5a
  jmp alltraps
80105d3e:	e9 8e f8 ff ff       	jmp    801055d1 <alltraps>

80105d43 <vector91>:
.globl vector91
vector91:
  pushl $0
80105d43:	6a 00                	push   $0x0
  pushl $91
80105d45:	6a 5b                	push   $0x5b
  jmp alltraps
80105d47:	e9 85 f8 ff ff       	jmp    801055d1 <alltraps>

80105d4c <vector92>:
.globl vector92
vector92:
  pushl $0
80105d4c:	6a 00                	push   $0x0
  pushl $92
80105d4e:	6a 5c                	push   $0x5c
  jmp alltraps
80105d50:	e9 7c f8 ff ff       	jmp    801055d1 <alltraps>

80105d55 <vector93>:
.globl vector93
vector93:
  pushl $0
80105d55:	6a 00                	push   $0x0
  pushl $93
80105d57:	6a 5d                	push   $0x5d
  jmp alltraps
80105d59:	e9 73 f8 ff ff       	jmp    801055d1 <alltraps>

80105d5e <vector94>:
.globl vector94
vector94:
  pushl $0
80105d5e:	6a 00                	push   $0x0
  pushl $94
80105d60:	6a 5e                	push   $0x5e
  jmp alltraps
80105d62:	e9 6a f8 ff ff       	jmp    801055d1 <alltraps>

80105d67 <vector95>:
.globl vector95
vector95:
  pushl $0
80105d67:	6a 00                	push   $0x0
  pushl $95
80105d69:	6a 5f                	push   $0x5f
  jmp alltraps
80105d6b:	e9 61 f8 ff ff       	jmp    801055d1 <alltraps>

80105d70 <vector96>:
.globl vector96
vector96:
  pushl $0
80105d70:	6a 00                	push   $0x0
  pushl $96
80105d72:	6a 60                	push   $0x60
  jmp alltraps
80105d74:	e9 58 f8 ff ff       	jmp    801055d1 <alltraps>

80105d79 <vector97>:
.globl vector97
vector97:
  pushl $0
80105d79:	6a 00                	push   $0x0
  pushl $97
80105d7b:	6a 61                	push   $0x61
  jmp alltraps
80105d7d:	e9 4f f8 ff ff       	jmp    801055d1 <alltraps>

80105d82 <vector98>:
.globl vector98
vector98:
  pushl $0
80105d82:	6a 00                	push   $0x0
  pushl $98
80105d84:	6a 62                	push   $0x62
  jmp alltraps
80105d86:	e9 46 f8 ff ff       	jmp    801055d1 <alltraps>

80105d8b <vector99>:
.globl vector99
vector99:
  pushl $0
80105d8b:	6a 00                	push   $0x0
  pushl $99
80105d8d:	6a 63                	push   $0x63
  jmp alltraps
80105d8f:	e9 3d f8 ff ff       	jmp    801055d1 <alltraps>

80105d94 <vector100>:
.globl vector100
vector100:
  pushl $0
80105d94:	6a 00                	push   $0x0
  pushl $100
80105d96:	6a 64                	push   $0x64
  jmp alltraps
80105d98:	e9 34 f8 ff ff       	jmp    801055d1 <alltraps>

80105d9d <vector101>:
.globl vector101
vector101:
  pushl $0
80105d9d:	6a 00                	push   $0x0
  pushl $101
80105d9f:	6a 65                	push   $0x65
  jmp alltraps
80105da1:	e9 2b f8 ff ff       	jmp    801055d1 <alltraps>

80105da6 <vector102>:
.globl vector102
vector102:
  pushl $0
80105da6:	6a 00                	push   $0x0
  pushl $102
80105da8:	6a 66                	push   $0x66
  jmp alltraps
80105daa:	e9 22 f8 ff ff       	jmp    801055d1 <alltraps>

80105daf <vector103>:
.globl vector103
vector103:
  pushl $0
80105daf:	6a 00                	push   $0x0
  pushl $103
80105db1:	6a 67                	push   $0x67
  jmp alltraps
80105db3:	e9 19 f8 ff ff       	jmp    801055d1 <alltraps>

80105db8 <vector104>:
.globl vector104
vector104:
  pushl $0
80105db8:	6a 00                	push   $0x0
  pushl $104
80105dba:	6a 68                	push   $0x68
  jmp alltraps
80105dbc:	e9 10 f8 ff ff       	jmp    801055d1 <alltraps>

80105dc1 <vector105>:
.globl vector105
vector105:
  pushl $0
80105dc1:	6a 00                	push   $0x0
  pushl $105
80105dc3:	6a 69                	push   $0x69
  jmp alltraps
80105dc5:	e9 07 f8 ff ff       	jmp    801055d1 <alltraps>

80105dca <vector106>:
.globl vector106
vector106:
  pushl $0
80105dca:	6a 00                	push   $0x0
  pushl $106
80105dcc:	6a 6a                	push   $0x6a
  jmp alltraps
80105dce:	e9 fe f7 ff ff       	jmp    801055d1 <alltraps>

80105dd3 <vector107>:
.globl vector107
vector107:
  pushl $0
80105dd3:	6a 00                	push   $0x0
  pushl $107
80105dd5:	6a 6b                	push   $0x6b
  jmp alltraps
80105dd7:	e9 f5 f7 ff ff       	jmp    801055d1 <alltraps>

80105ddc <vector108>:
.globl vector108
vector108:
  pushl $0
80105ddc:	6a 00                	push   $0x0
  pushl $108
80105dde:	6a 6c                	push   $0x6c
  jmp alltraps
80105de0:	e9 ec f7 ff ff       	jmp    801055d1 <alltraps>

80105de5 <vector109>:
.globl vector109
vector109:
  pushl $0
80105de5:	6a 00                	push   $0x0
  pushl $109
80105de7:	6a 6d                	push   $0x6d
  jmp alltraps
80105de9:	e9 e3 f7 ff ff       	jmp    801055d1 <alltraps>

80105dee <vector110>:
.globl vector110
vector110:
  pushl $0
80105dee:	6a 00                	push   $0x0
  pushl $110
80105df0:	6a 6e                	push   $0x6e
  jmp alltraps
80105df2:	e9 da f7 ff ff       	jmp    801055d1 <alltraps>

80105df7 <vector111>:
.globl vector111
vector111:
  pushl $0
80105df7:	6a 00                	push   $0x0
  pushl $111
80105df9:	6a 6f                	push   $0x6f
  jmp alltraps
80105dfb:	e9 d1 f7 ff ff       	jmp    801055d1 <alltraps>

80105e00 <vector112>:
.globl vector112
vector112:
  pushl $0
80105e00:	6a 00                	push   $0x0
  pushl $112
80105e02:	6a 70                	push   $0x70
  jmp alltraps
80105e04:	e9 c8 f7 ff ff       	jmp    801055d1 <alltraps>

80105e09 <vector113>:
.globl vector113
vector113:
  pushl $0
80105e09:	6a 00                	push   $0x0
  pushl $113
80105e0b:	6a 71                	push   $0x71
  jmp alltraps
80105e0d:	e9 bf f7 ff ff       	jmp    801055d1 <alltraps>

80105e12 <vector114>:
.globl vector114
vector114:
  pushl $0
80105e12:	6a 00                	push   $0x0
  pushl $114
80105e14:	6a 72                	push   $0x72
  jmp alltraps
80105e16:	e9 b6 f7 ff ff       	jmp    801055d1 <alltraps>

80105e1b <vector115>:
.globl vector115
vector115:
  pushl $0
80105e1b:	6a 00                	push   $0x0
  pushl $115
80105e1d:	6a 73                	push   $0x73
  jmp alltraps
80105e1f:	e9 ad f7 ff ff       	jmp    801055d1 <alltraps>

80105e24 <vector116>:
.globl vector116
vector116:
  pushl $0
80105e24:	6a 00                	push   $0x0
  pushl $116
80105e26:	6a 74                	push   $0x74
  jmp alltraps
80105e28:	e9 a4 f7 ff ff       	jmp    801055d1 <alltraps>

80105e2d <vector117>:
.globl vector117
vector117:
  pushl $0
80105e2d:	6a 00                	push   $0x0
  pushl $117
80105e2f:	6a 75                	push   $0x75
  jmp alltraps
80105e31:	e9 9b f7 ff ff       	jmp    801055d1 <alltraps>

80105e36 <vector118>:
.globl vector118
vector118:
  pushl $0
80105e36:	6a 00                	push   $0x0
  pushl $118
80105e38:	6a 76                	push   $0x76
  jmp alltraps
80105e3a:	e9 92 f7 ff ff       	jmp    801055d1 <alltraps>

80105e3f <vector119>:
.globl vector119
vector119:
  pushl $0
80105e3f:	6a 00                	push   $0x0
  pushl $119
80105e41:	6a 77                	push   $0x77
  jmp alltraps
80105e43:	e9 89 f7 ff ff       	jmp    801055d1 <alltraps>

80105e48 <vector120>:
.globl vector120
vector120:
  pushl $0
80105e48:	6a 00                	push   $0x0
  pushl $120
80105e4a:	6a 78                	push   $0x78
  jmp alltraps
80105e4c:	e9 80 f7 ff ff       	jmp    801055d1 <alltraps>

80105e51 <vector121>:
.globl vector121
vector121:
  pushl $0
80105e51:	6a 00                	push   $0x0
  pushl $121
80105e53:	6a 79                	push   $0x79
  jmp alltraps
80105e55:	e9 77 f7 ff ff       	jmp    801055d1 <alltraps>

80105e5a <vector122>:
.globl vector122
vector122:
  pushl $0
80105e5a:	6a 00                	push   $0x0
  pushl $122
80105e5c:	6a 7a                	push   $0x7a
  jmp alltraps
80105e5e:	e9 6e f7 ff ff       	jmp    801055d1 <alltraps>

80105e63 <vector123>:
.globl vector123
vector123:
  pushl $0
80105e63:	6a 00                	push   $0x0
  pushl $123
80105e65:	6a 7b                	push   $0x7b
  jmp alltraps
80105e67:	e9 65 f7 ff ff       	jmp    801055d1 <alltraps>

80105e6c <vector124>:
.globl vector124
vector124:
  pushl $0
80105e6c:	6a 00                	push   $0x0
  pushl $124
80105e6e:	6a 7c                	push   $0x7c
  jmp alltraps
80105e70:	e9 5c f7 ff ff       	jmp    801055d1 <alltraps>

80105e75 <vector125>:
.globl vector125
vector125:
  pushl $0
80105e75:	6a 00                	push   $0x0
  pushl $125
80105e77:	6a 7d                	push   $0x7d
  jmp alltraps
80105e79:	e9 53 f7 ff ff       	jmp    801055d1 <alltraps>

80105e7e <vector126>:
.globl vector126
vector126:
  pushl $0
80105e7e:	6a 00                	push   $0x0
  pushl $126
80105e80:	6a 7e                	push   $0x7e
  jmp alltraps
80105e82:	e9 4a f7 ff ff       	jmp    801055d1 <alltraps>

80105e87 <vector127>:
.globl vector127
vector127:
  pushl $0
80105e87:	6a 00                	push   $0x0
  pushl $127
80105e89:	6a 7f                	push   $0x7f
  jmp alltraps
80105e8b:	e9 41 f7 ff ff       	jmp    801055d1 <alltraps>

80105e90 <vector128>:
.globl vector128
vector128:
  pushl $0
80105e90:	6a 00                	push   $0x0
  pushl $128
80105e92:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80105e97:	e9 35 f7 ff ff       	jmp    801055d1 <alltraps>

80105e9c <vector129>:
.globl vector129
vector129:
  pushl $0
80105e9c:	6a 00                	push   $0x0
  pushl $129
80105e9e:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80105ea3:	e9 29 f7 ff ff       	jmp    801055d1 <alltraps>

80105ea8 <vector130>:
.globl vector130
vector130:
  pushl $0
80105ea8:	6a 00                	push   $0x0
  pushl $130
80105eaa:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80105eaf:	e9 1d f7 ff ff       	jmp    801055d1 <alltraps>

80105eb4 <vector131>:
.globl vector131
vector131:
  pushl $0
80105eb4:	6a 00                	push   $0x0
  pushl $131
80105eb6:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80105ebb:	e9 11 f7 ff ff       	jmp    801055d1 <alltraps>

80105ec0 <vector132>:
.globl vector132
vector132:
  pushl $0
80105ec0:	6a 00                	push   $0x0
  pushl $132
80105ec2:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80105ec7:	e9 05 f7 ff ff       	jmp    801055d1 <alltraps>

80105ecc <vector133>:
.globl vector133
vector133:
  pushl $0
80105ecc:	6a 00                	push   $0x0
  pushl $133
80105ece:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80105ed3:	e9 f9 f6 ff ff       	jmp    801055d1 <alltraps>

80105ed8 <vector134>:
.globl vector134
vector134:
  pushl $0
80105ed8:	6a 00                	push   $0x0
  pushl $134
80105eda:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80105edf:	e9 ed f6 ff ff       	jmp    801055d1 <alltraps>

80105ee4 <vector135>:
.globl vector135
vector135:
  pushl $0
80105ee4:	6a 00                	push   $0x0
  pushl $135
80105ee6:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80105eeb:	e9 e1 f6 ff ff       	jmp    801055d1 <alltraps>

80105ef0 <vector136>:
.globl vector136
vector136:
  pushl $0
80105ef0:	6a 00                	push   $0x0
  pushl $136
80105ef2:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80105ef7:	e9 d5 f6 ff ff       	jmp    801055d1 <alltraps>

80105efc <vector137>:
.globl vector137
vector137:
  pushl $0
80105efc:	6a 00                	push   $0x0
  pushl $137
80105efe:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80105f03:	e9 c9 f6 ff ff       	jmp    801055d1 <alltraps>

80105f08 <vector138>:
.globl vector138
vector138:
  pushl $0
80105f08:	6a 00                	push   $0x0
  pushl $138
80105f0a:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80105f0f:	e9 bd f6 ff ff       	jmp    801055d1 <alltraps>

80105f14 <vector139>:
.globl vector139
vector139:
  pushl $0
80105f14:	6a 00                	push   $0x0
  pushl $139
80105f16:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80105f1b:	e9 b1 f6 ff ff       	jmp    801055d1 <alltraps>

80105f20 <vector140>:
.globl vector140
vector140:
  pushl $0
80105f20:	6a 00                	push   $0x0
  pushl $140
80105f22:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80105f27:	e9 a5 f6 ff ff       	jmp    801055d1 <alltraps>

80105f2c <vector141>:
.globl vector141
vector141:
  pushl $0
80105f2c:	6a 00                	push   $0x0
  pushl $141
80105f2e:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80105f33:	e9 99 f6 ff ff       	jmp    801055d1 <alltraps>

80105f38 <vector142>:
.globl vector142
vector142:
  pushl $0
80105f38:	6a 00                	push   $0x0
  pushl $142
80105f3a:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80105f3f:	e9 8d f6 ff ff       	jmp    801055d1 <alltraps>

80105f44 <vector143>:
.globl vector143
vector143:
  pushl $0
80105f44:	6a 00                	push   $0x0
  pushl $143
80105f46:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80105f4b:	e9 81 f6 ff ff       	jmp    801055d1 <alltraps>

80105f50 <vector144>:
.globl vector144
vector144:
  pushl $0
80105f50:	6a 00                	push   $0x0
  pushl $144
80105f52:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80105f57:	e9 75 f6 ff ff       	jmp    801055d1 <alltraps>

80105f5c <vector145>:
.globl vector145
vector145:
  pushl $0
80105f5c:	6a 00                	push   $0x0
  pushl $145
80105f5e:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80105f63:	e9 69 f6 ff ff       	jmp    801055d1 <alltraps>

80105f68 <vector146>:
.globl vector146
vector146:
  pushl $0
80105f68:	6a 00                	push   $0x0
  pushl $146
80105f6a:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80105f6f:	e9 5d f6 ff ff       	jmp    801055d1 <alltraps>

80105f74 <vector147>:
.globl vector147
vector147:
  pushl $0
80105f74:	6a 00                	push   $0x0
  pushl $147
80105f76:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80105f7b:	e9 51 f6 ff ff       	jmp    801055d1 <alltraps>

80105f80 <vector148>:
.globl vector148
vector148:
  pushl $0
80105f80:	6a 00                	push   $0x0
  pushl $148
80105f82:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80105f87:	e9 45 f6 ff ff       	jmp    801055d1 <alltraps>

80105f8c <vector149>:
.globl vector149
vector149:
  pushl $0
80105f8c:	6a 00                	push   $0x0
  pushl $149
80105f8e:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80105f93:	e9 39 f6 ff ff       	jmp    801055d1 <alltraps>

80105f98 <vector150>:
.globl vector150
vector150:
  pushl $0
80105f98:	6a 00                	push   $0x0
  pushl $150
80105f9a:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80105f9f:	e9 2d f6 ff ff       	jmp    801055d1 <alltraps>

80105fa4 <vector151>:
.globl vector151
vector151:
  pushl $0
80105fa4:	6a 00                	push   $0x0
  pushl $151
80105fa6:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80105fab:	e9 21 f6 ff ff       	jmp    801055d1 <alltraps>

80105fb0 <vector152>:
.globl vector152
vector152:
  pushl $0
80105fb0:	6a 00                	push   $0x0
  pushl $152
80105fb2:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80105fb7:	e9 15 f6 ff ff       	jmp    801055d1 <alltraps>

80105fbc <vector153>:
.globl vector153
vector153:
  pushl $0
80105fbc:	6a 00                	push   $0x0
  pushl $153
80105fbe:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80105fc3:	e9 09 f6 ff ff       	jmp    801055d1 <alltraps>

80105fc8 <vector154>:
.globl vector154
vector154:
  pushl $0
80105fc8:	6a 00                	push   $0x0
  pushl $154
80105fca:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80105fcf:	e9 fd f5 ff ff       	jmp    801055d1 <alltraps>

80105fd4 <vector155>:
.globl vector155
vector155:
  pushl $0
80105fd4:	6a 00                	push   $0x0
  pushl $155
80105fd6:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80105fdb:	e9 f1 f5 ff ff       	jmp    801055d1 <alltraps>

80105fe0 <vector156>:
.globl vector156
vector156:
  pushl $0
80105fe0:	6a 00                	push   $0x0
  pushl $156
80105fe2:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80105fe7:	e9 e5 f5 ff ff       	jmp    801055d1 <alltraps>

80105fec <vector157>:
.globl vector157
vector157:
  pushl $0
80105fec:	6a 00                	push   $0x0
  pushl $157
80105fee:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80105ff3:	e9 d9 f5 ff ff       	jmp    801055d1 <alltraps>

80105ff8 <vector158>:
.globl vector158
vector158:
  pushl $0
80105ff8:	6a 00                	push   $0x0
  pushl $158
80105ffa:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80105fff:	e9 cd f5 ff ff       	jmp    801055d1 <alltraps>

80106004 <vector159>:
.globl vector159
vector159:
  pushl $0
80106004:	6a 00                	push   $0x0
  pushl $159
80106006:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
8010600b:	e9 c1 f5 ff ff       	jmp    801055d1 <alltraps>

80106010 <vector160>:
.globl vector160
vector160:
  pushl $0
80106010:	6a 00                	push   $0x0
  pushl $160
80106012:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106017:	e9 b5 f5 ff ff       	jmp    801055d1 <alltraps>

8010601c <vector161>:
.globl vector161
vector161:
  pushl $0
8010601c:	6a 00                	push   $0x0
  pushl $161
8010601e:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106023:	e9 a9 f5 ff ff       	jmp    801055d1 <alltraps>

80106028 <vector162>:
.globl vector162
vector162:
  pushl $0
80106028:	6a 00                	push   $0x0
  pushl $162
8010602a:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
8010602f:	e9 9d f5 ff ff       	jmp    801055d1 <alltraps>

80106034 <vector163>:
.globl vector163
vector163:
  pushl $0
80106034:	6a 00                	push   $0x0
  pushl $163
80106036:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
8010603b:	e9 91 f5 ff ff       	jmp    801055d1 <alltraps>

80106040 <vector164>:
.globl vector164
vector164:
  pushl $0
80106040:	6a 00                	push   $0x0
  pushl $164
80106042:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106047:	e9 85 f5 ff ff       	jmp    801055d1 <alltraps>

8010604c <vector165>:
.globl vector165
vector165:
  pushl $0
8010604c:	6a 00                	push   $0x0
  pushl $165
8010604e:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106053:	e9 79 f5 ff ff       	jmp    801055d1 <alltraps>

80106058 <vector166>:
.globl vector166
vector166:
  pushl $0
80106058:	6a 00                	push   $0x0
  pushl $166
8010605a:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
8010605f:	e9 6d f5 ff ff       	jmp    801055d1 <alltraps>

80106064 <vector167>:
.globl vector167
vector167:
  pushl $0
80106064:	6a 00                	push   $0x0
  pushl $167
80106066:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
8010606b:	e9 61 f5 ff ff       	jmp    801055d1 <alltraps>

80106070 <vector168>:
.globl vector168
vector168:
  pushl $0
80106070:	6a 00                	push   $0x0
  pushl $168
80106072:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106077:	e9 55 f5 ff ff       	jmp    801055d1 <alltraps>

8010607c <vector169>:
.globl vector169
vector169:
  pushl $0
8010607c:	6a 00                	push   $0x0
  pushl $169
8010607e:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106083:	e9 49 f5 ff ff       	jmp    801055d1 <alltraps>

80106088 <vector170>:
.globl vector170
vector170:
  pushl $0
80106088:	6a 00                	push   $0x0
  pushl $170
8010608a:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
8010608f:	e9 3d f5 ff ff       	jmp    801055d1 <alltraps>

80106094 <vector171>:
.globl vector171
vector171:
  pushl $0
80106094:	6a 00                	push   $0x0
  pushl $171
80106096:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
8010609b:	e9 31 f5 ff ff       	jmp    801055d1 <alltraps>

801060a0 <vector172>:
.globl vector172
vector172:
  pushl $0
801060a0:	6a 00                	push   $0x0
  pushl $172
801060a2:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801060a7:	e9 25 f5 ff ff       	jmp    801055d1 <alltraps>

801060ac <vector173>:
.globl vector173
vector173:
  pushl $0
801060ac:	6a 00                	push   $0x0
  pushl $173
801060ae:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801060b3:	e9 19 f5 ff ff       	jmp    801055d1 <alltraps>

801060b8 <vector174>:
.globl vector174
vector174:
  pushl $0
801060b8:	6a 00                	push   $0x0
  pushl $174
801060ba:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801060bf:	e9 0d f5 ff ff       	jmp    801055d1 <alltraps>

801060c4 <vector175>:
.globl vector175
vector175:
  pushl $0
801060c4:	6a 00                	push   $0x0
  pushl $175
801060c6:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801060cb:	e9 01 f5 ff ff       	jmp    801055d1 <alltraps>

801060d0 <vector176>:
.globl vector176
vector176:
  pushl $0
801060d0:	6a 00                	push   $0x0
  pushl $176
801060d2:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801060d7:	e9 f5 f4 ff ff       	jmp    801055d1 <alltraps>

801060dc <vector177>:
.globl vector177
vector177:
  pushl $0
801060dc:	6a 00                	push   $0x0
  pushl $177
801060de:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801060e3:	e9 e9 f4 ff ff       	jmp    801055d1 <alltraps>

801060e8 <vector178>:
.globl vector178
vector178:
  pushl $0
801060e8:	6a 00                	push   $0x0
  pushl $178
801060ea:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801060ef:	e9 dd f4 ff ff       	jmp    801055d1 <alltraps>

801060f4 <vector179>:
.globl vector179
vector179:
  pushl $0
801060f4:	6a 00                	push   $0x0
  pushl $179
801060f6:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801060fb:	e9 d1 f4 ff ff       	jmp    801055d1 <alltraps>

80106100 <vector180>:
.globl vector180
vector180:
  pushl $0
80106100:	6a 00                	push   $0x0
  pushl $180
80106102:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106107:	e9 c5 f4 ff ff       	jmp    801055d1 <alltraps>

8010610c <vector181>:
.globl vector181
vector181:
  pushl $0
8010610c:	6a 00                	push   $0x0
  pushl $181
8010610e:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106113:	e9 b9 f4 ff ff       	jmp    801055d1 <alltraps>

80106118 <vector182>:
.globl vector182
vector182:
  pushl $0
80106118:	6a 00                	push   $0x0
  pushl $182
8010611a:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
8010611f:	e9 ad f4 ff ff       	jmp    801055d1 <alltraps>

80106124 <vector183>:
.globl vector183
vector183:
  pushl $0
80106124:	6a 00                	push   $0x0
  pushl $183
80106126:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
8010612b:	e9 a1 f4 ff ff       	jmp    801055d1 <alltraps>

80106130 <vector184>:
.globl vector184
vector184:
  pushl $0
80106130:	6a 00                	push   $0x0
  pushl $184
80106132:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106137:	e9 95 f4 ff ff       	jmp    801055d1 <alltraps>

8010613c <vector185>:
.globl vector185
vector185:
  pushl $0
8010613c:	6a 00                	push   $0x0
  pushl $185
8010613e:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106143:	e9 89 f4 ff ff       	jmp    801055d1 <alltraps>

80106148 <vector186>:
.globl vector186
vector186:
  pushl $0
80106148:	6a 00                	push   $0x0
  pushl $186
8010614a:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
8010614f:	e9 7d f4 ff ff       	jmp    801055d1 <alltraps>

80106154 <vector187>:
.globl vector187
vector187:
  pushl $0
80106154:	6a 00                	push   $0x0
  pushl $187
80106156:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
8010615b:	e9 71 f4 ff ff       	jmp    801055d1 <alltraps>

80106160 <vector188>:
.globl vector188
vector188:
  pushl $0
80106160:	6a 00                	push   $0x0
  pushl $188
80106162:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106167:	e9 65 f4 ff ff       	jmp    801055d1 <alltraps>

8010616c <vector189>:
.globl vector189
vector189:
  pushl $0
8010616c:	6a 00                	push   $0x0
  pushl $189
8010616e:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106173:	e9 59 f4 ff ff       	jmp    801055d1 <alltraps>

80106178 <vector190>:
.globl vector190
vector190:
  pushl $0
80106178:	6a 00                	push   $0x0
  pushl $190
8010617a:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
8010617f:	e9 4d f4 ff ff       	jmp    801055d1 <alltraps>

80106184 <vector191>:
.globl vector191
vector191:
  pushl $0
80106184:	6a 00                	push   $0x0
  pushl $191
80106186:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
8010618b:	e9 41 f4 ff ff       	jmp    801055d1 <alltraps>

80106190 <vector192>:
.globl vector192
vector192:
  pushl $0
80106190:	6a 00                	push   $0x0
  pushl $192
80106192:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106197:	e9 35 f4 ff ff       	jmp    801055d1 <alltraps>

8010619c <vector193>:
.globl vector193
vector193:
  pushl $0
8010619c:	6a 00                	push   $0x0
  pushl $193
8010619e:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801061a3:	e9 29 f4 ff ff       	jmp    801055d1 <alltraps>

801061a8 <vector194>:
.globl vector194
vector194:
  pushl $0
801061a8:	6a 00                	push   $0x0
  pushl $194
801061aa:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801061af:	e9 1d f4 ff ff       	jmp    801055d1 <alltraps>

801061b4 <vector195>:
.globl vector195
vector195:
  pushl $0
801061b4:	6a 00                	push   $0x0
  pushl $195
801061b6:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801061bb:	e9 11 f4 ff ff       	jmp    801055d1 <alltraps>

801061c0 <vector196>:
.globl vector196
vector196:
  pushl $0
801061c0:	6a 00                	push   $0x0
  pushl $196
801061c2:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801061c7:	e9 05 f4 ff ff       	jmp    801055d1 <alltraps>

801061cc <vector197>:
.globl vector197
vector197:
  pushl $0
801061cc:	6a 00                	push   $0x0
  pushl $197
801061ce:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801061d3:	e9 f9 f3 ff ff       	jmp    801055d1 <alltraps>

801061d8 <vector198>:
.globl vector198
vector198:
  pushl $0
801061d8:	6a 00                	push   $0x0
  pushl $198
801061da:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801061df:	e9 ed f3 ff ff       	jmp    801055d1 <alltraps>

801061e4 <vector199>:
.globl vector199
vector199:
  pushl $0
801061e4:	6a 00                	push   $0x0
  pushl $199
801061e6:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801061eb:	e9 e1 f3 ff ff       	jmp    801055d1 <alltraps>

801061f0 <vector200>:
.globl vector200
vector200:
  pushl $0
801061f0:	6a 00                	push   $0x0
  pushl $200
801061f2:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801061f7:	e9 d5 f3 ff ff       	jmp    801055d1 <alltraps>

801061fc <vector201>:
.globl vector201
vector201:
  pushl $0
801061fc:	6a 00                	push   $0x0
  pushl $201
801061fe:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106203:	e9 c9 f3 ff ff       	jmp    801055d1 <alltraps>

80106208 <vector202>:
.globl vector202
vector202:
  pushl $0
80106208:	6a 00                	push   $0x0
  pushl $202
8010620a:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
8010620f:	e9 bd f3 ff ff       	jmp    801055d1 <alltraps>

80106214 <vector203>:
.globl vector203
vector203:
  pushl $0
80106214:	6a 00                	push   $0x0
  pushl $203
80106216:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
8010621b:	e9 b1 f3 ff ff       	jmp    801055d1 <alltraps>

80106220 <vector204>:
.globl vector204
vector204:
  pushl $0
80106220:	6a 00                	push   $0x0
  pushl $204
80106222:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106227:	e9 a5 f3 ff ff       	jmp    801055d1 <alltraps>

8010622c <vector205>:
.globl vector205
vector205:
  pushl $0
8010622c:	6a 00                	push   $0x0
  pushl $205
8010622e:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106233:	e9 99 f3 ff ff       	jmp    801055d1 <alltraps>

80106238 <vector206>:
.globl vector206
vector206:
  pushl $0
80106238:	6a 00                	push   $0x0
  pushl $206
8010623a:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
8010623f:	e9 8d f3 ff ff       	jmp    801055d1 <alltraps>

80106244 <vector207>:
.globl vector207
vector207:
  pushl $0
80106244:	6a 00                	push   $0x0
  pushl $207
80106246:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
8010624b:	e9 81 f3 ff ff       	jmp    801055d1 <alltraps>

80106250 <vector208>:
.globl vector208
vector208:
  pushl $0
80106250:	6a 00                	push   $0x0
  pushl $208
80106252:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106257:	e9 75 f3 ff ff       	jmp    801055d1 <alltraps>

8010625c <vector209>:
.globl vector209
vector209:
  pushl $0
8010625c:	6a 00                	push   $0x0
  pushl $209
8010625e:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106263:	e9 69 f3 ff ff       	jmp    801055d1 <alltraps>

80106268 <vector210>:
.globl vector210
vector210:
  pushl $0
80106268:	6a 00                	push   $0x0
  pushl $210
8010626a:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
8010626f:	e9 5d f3 ff ff       	jmp    801055d1 <alltraps>

80106274 <vector211>:
.globl vector211
vector211:
  pushl $0
80106274:	6a 00                	push   $0x0
  pushl $211
80106276:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
8010627b:	e9 51 f3 ff ff       	jmp    801055d1 <alltraps>

80106280 <vector212>:
.globl vector212
vector212:
  pushl $0
80106280:	6a 00                	push   $0x0
  pushl $212
80106282:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106287:	e9 45 f3 ff ff       	jmp    801055d1 <alltraps>

8010628c <vector213>:
.globl vector213
vector213:
  pushl $0
8010628c:	6a 00                	push   $0x0
  pushl $213
8010628e:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106293:	e9 39 f3 ff ff       	jmp    801055d1 <alltraps>

80106298 <vector214>:
.globl vector214
vector214:
  pushl $0
80106298:	6a 00                	push   $0x0
  pushl $214
8010629a:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
8010629f:	e9 2d f3 ff ff       	jmp    801055d1 <alltraps>

801062a4 <vector215>:
.globl vector215
vector215:
  pushl $0
801062a4:	6a 00                	push   $0x0
  pushl $215
801062a6:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801062ab:	e9 21 f3 ff ff       	jmp    801055d1 <alltraps>

801062b0 <vector216>:
.globl vector216
vector216:
  pushl $0
801062b0:	6a 00                	push   $0x0
  pushl $216
801062b2:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801062b7:	e9 15 f3 ff ff       	jmp    801055d1 <alltraps>

801062bc <vector217>:
.globl vector217
vector217:
  pushl $0
801062bc:	6a 00                	push   $0x0
  pushl $217
801062be:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801062c3:	e9 09 f3 ff ff       	jmp    801055d1 <alltraps>

801062c8 <vector218>:
.globl vector218
vector218:
  pushl $0
801062c8:	6a 00                	push   $0x0
  pushl $218
801062ca:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801062cf:	e9 fd f2 ff ff       	jmp    801055d1 <alltraps>

801062d4 <vector219>:
.globl vector219
vector219:
  pushl $0
801062d4:	6a 00                	push   $0x0
  pushl $219
801062d6:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801062db:	e9 f1 f2 ff ff       	jmp    801055d1 <alltraps>

801062e0 <vector220>:
.globl vector220
vector220:
  pushl $0
801062e0:	6a 00                	push   $0x0
  pushl $220
801062e2:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801062e7:	e9 e5 f2 ff ff       	jmp    801055d1 <alltraps>

801062ec <vector221>:
.globl vector221
vector221:
  pushl $0
801062ec:	6a 00                	push   $0x0
  pushl $221
801062ee:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801062f3:	e9 d9 f2 ff ff       	jmp    801055d1 <alltraps>

801062f8 <vector222>:
.globl vector222
vector222:
  pushl $0
801062f8:	6a 00                	push   $0x0
  pushl $222
801062fa:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801062ff:	e9 cd f2 ff ff       	jmp    801055d1 <alltraps>

80106304 <vector223>:
.globl vector223
vector223:
  pushl $0
80106304:	6a 00                	push   $0x0
  pushl $223
80106306:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
8010630b:	e9 c1 f2 ff ff       	jmp    801055d1 <alltraps>

80106310 <vector224>:
.globl vector224
vector224:
  pushl $0
80106310:	6a 00                	push   $0x0
  pushl $224
80106312:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106317:	e9 b5 f2 ff ff       	jmp    801055d1 <alltraps>

8010631c <vector225>:
.globl vector225
vector225:
  pushl $0
8010631c:	6a 00                	push   $0x0
  pushl $225
8010631e:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106323:	e9 a9 f2 ff ff       	jmp    801055d1 <alltraps>

80106328 <vector226>:
.globl vector226
vector226:
  pushl $0
80106328:	6a 00                	push   $0x0
  pushl $226
8010632a:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
8010632f:	e9 9d f2 ff ff       	jmp    801055d1 <alltraps>

80106334 <vector227>:
.globl vector227
vector227:
  pushl $0
80106334:	6a 00                	push   $0x0
  pushl $227
80106336:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
8010633b:	e9 91 f2 ff ff       	jmp    801055d1 <alltraps>

80106340 <vector228>:
.globl vector228
vector228:
  pushl $0
80106340:	6a 00                	push   $0x0
  pushl $228
80106342:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106347:	e9 85 f2 ff ff       	jmp    801055d1 <alltraps>

8010634c <vector229>:
.globl vector229
vector229:
  pushl $0
8010634c:	6a 00                	push   $0x0
  pushl $229
8010634e:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106353:	e9 79 f2 ff ff       	jmp    801055d1 <alltraps>

80106358 <vector230>:
.globl vector230
vector230:
  pushl $0
80106358:	6a 00                	push   $0x0
  pushl $230
8010635a:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
8010635f:	e9 6d f2 ff ff       	jmp    801055d1 <alltraps>

80106364 <vector231>:
.globl vector231
vector231:
  pushl $0
80106364:	6a 00                	push   $0x0
  pushl $231
80106366:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
8010636b:	e9 61 f2 ff ff       	jmp    801055d1 <alltraps>

80106370 <vector232>:
.globl vector232
vector232:
  pushl $0
80106370:	6a 00                	push   $0x0
  pushl $232
80106372:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106377:	e9 55 f2 ff ff       	jmp    801055d1 <alltraps>

8010637c <vector233>:
.globl vector233
vector233:
  pushl $0
8010637c:	6a 00                	push   $0x0
  pushl $233
8010637e:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106383:	e9 49 f2 ff ff       	jmp    801055d1 <alltraps>

80106388 <vector234>:
.globl vector234
vector234:
  pushl $0
80106388:	6a 00                	push   $0x0
  pushl $234
8010638a:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
8010638f:	e9 3d f2 ff ff       	jmp    801055d1 <alltraps>

80106394 <vector235>:
.globl vector235
vector235:
  pushl $0
80106394:	6a 00                	push   $0x0
  pushl $235
80106396:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
8010639b:	e9 31 f2 ff ff       	jmp    801055d1 <alltraps>

801063a0 <vector236>:
.globl vector236
vector236:
  pushl $0
801063a0:	6a 00                	push   $0x0
  pushl $236
801063a2:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801063a7:	e9 25 f2 ff ff       	jmp    801055d1 <alltraps>

801063ac <vector237>:
.globl vector237
vector237:
  pushl $0
801063ac:	6a 00                	push   $0x0
  pushl $237
801063ae:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801063b3:	e9 19 f2 ff ff       	jmp    801055d1 <alltraps>

801063b8 <vector238>:
.globl vector238
vector238:
  pushl $0
801063b8:	6a 00                	push   $0x0
  pushl $238
801063ba:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801063bf:	e9 0d f2 ff ff       	jmp    801055d1 <alltraps>

801063c4 <vector239>:
.globl vector239
vector239:
  pushl $0
801063c4:	6a 00                	push   $0x0
  pushl $239
801063c6:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801063cb:	e9 01 f2 ff ff       	jmp    801055d1 <alltraps>

801063d0 <vector240>:
.globl vector240
vector240:
  pushl $0
801063d0:	6a 00                	push   $0x0
  pushl $240
801063d2:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801063d7:	e9 f5 f1 ff ff       	jmp    801055d1 <alltraps>

801063dc <vector241>:
.globl vector241
vector241:
  pushl $0
801063dc:	6a 00                	push   $0x0
  pushl $241
801063de:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801063e3:	e9 e9 f1 ff ff       	jmp    801055d1 <alltraps>

801063e8 <vector242>:
.globl vector242
vector242:
  pushl $0
801063e8:	6a 00                	push   $0x0
  pushl $242
801063ea:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801063ef:	e9 dd f1 ff ff       	jmp    801055d1 <alltraps>

801063f4 <vector243>:
.globl vector243
vector243:
  pushl $0
801063f4:	6a 00                	push   $0x0
  pushl $243
801063f6:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801063fb:	e9 d1 f1 ff ff       	jmp    801055d1 <alltraps>

80106400 <vector244>:
.globl vector244
vector244:
  pushl $0
80106400:	6a 00                	push   $0x0
  pushl $244
80106402:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106407:	e9 c5 f1 ff ff       	jmp    801055d1 <alltraps>

8010640c <vector245>:
.globl vector245
vector245:
  pushl $0
8010640c:	6a 00                	push   $0x0
  pushl $245
8010640e:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106413:	e9 b9 f1 ff ff       	jmp    801055d1 <alltraps>

80106418 <vector246>:
.globl vector246
vector246:
  pushl $0
80106418:	6a 00                	push   $0x0
  pushl $246
8010641a:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
8010641f:	e9 ad f1 ff ff       	jmp    801055d1 <alltraps>

80106424 <vector247>:
.globl vector247
vector247:
  pushl $0
80106424:	6a 00                	push   $0x0
  pushl $247
80106426:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
8010642b:	e9 a1 f1 ff ff       	jmp    801055d1 <alltraps>

80106430 <vector248>:
.globl vector248
vector248:
  pushl $0
80106430:	6a 00                	push   $0x0
  pushl $248
80106432:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106437:	e9 95 f1 ff ff       	jmp    801055d1 <alltraps>

8010643c <vector249>:
.globl vector249
vector249:
  pushl $0
8010643c:	6a 00                	push   $0x0
  pushl $249
8010643e:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106443:	e9 89 f1 ff ff       	jmp    801055d1 <alltraps>

80106448 <vector250>:
.globl vector250
vector250:
  pushl $0
80106448:	6a 00                	push   $0x0
  pushl $250
8010644a:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
8010644f:	e9 7d f1 ff ff       	jmp    801055d1 <alltraps>

80106454 <vector251>:
.globl vector251
vector251:
  pushl $0
80106454:	6a 00                	push   $0x0
  pushl $251
80106456:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
8010645b:	e9 71 f1 ff ff       	jmp    801055d1 <alltraps>

80106460 <vector252>:
.globl vector252
vector252:
  pushl $0
80106460:	6a 00                	push   $0x0
  pushl $252
80106462:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106467:	e9 65 f1 ff ff       	jmp    801055d1 <alltraps>

8010646c <vector253>:
.globl vector253
vector253:
  pushl $0
8010646c:	6a 00                	push   $0x0
  pushl $253
8010646e:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106473:	e9 59 f1 ff ff       	jmp    801055d1 <alltraps>

80106478 <vector254>:
.globl vector254
vector254:
  pushl $0
80106478:	6a 00                	push   $0x0
  pushl $254
8010647a:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
8010647f:	e9 4d f1 ff ff       	jmp    801055d1 <alltraps>

80106484 <vector255>:
.globl vector255
vector255:
  pushl $0
80106484:	6a 00                	push   $0x0
  pushl $255
80106486:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
8010648b:	e9 41 f1 ff ff       	jmp    801055d1 <alltraps>

80106490 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106490:	55                   	push   %ebp
80106491:	89 e5                	mov    %esp,%ebp
80106493:	57                   	push   %edi
80106494:	56                   	push   %esi
80106495:	53                   	push   %ebx
80106496:	83 ec 0c             	sub    $0xc,%esp
80106499:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
8010649b:	c1 ea 16             	shr    $0x16,%edx
8010649e:	8d 3c 90             	lea    (%eax,%edx,4),%edi
  if(*pde & PTE_P){
801064a1:	8b 1f                	mov    (%edi),%ebx
801064a3:	f6 c3 01             	test   $0x1,%bl
801064a6:	74 0e                	je     801064b6 <walkpgdir+0x26>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801064a8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801064ae:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
801064b4:	eb 32                	jmp    801064e8 <walkpgdir+0x58>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
801064b6:	b8 00 00 00 00       	mov    $0x0,%eax

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801064bb:	85 c9                	test   %ecx,%ecx
801064bd:	74 3c                	je     801064fb <walkpgdir+0x6b>
801064bf:	e8 99 bc ff ff       	call   8010215d <kalloc>
801064c4:	89 c3                	mov    %eax,%ebx
801064c6:	85 c0                	test   %eax,%eax
801064c8:	74 2c                	je     801064f6 <walkpgdir+0x66>
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
801064ca:	83 ec 04             	sub    $0x4,%esp
801064cd:	68 00 10 00 00       	push   $0x1000
801064d2:	6a 00                	push   $0x0
801064d4:	50                   	push   %eax
801064d5:	e8 9e dc ff ff       	call   80104178 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801064da:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801064e0:	83 c8 07             	or     $0x7,%eax
801064e3:	89 07                	mov    %eax,(%edi)
801064e5:	83 c4 10             	add    $0x10,%esp
  }
  return &pgtab[PTX(va)];
801064e8:	c1 ee 0a             	shr    $0xa,%esi
801064eb:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
801064f1:	8d 04 33             	lea    (%ebx,%esi,1),%eax
801064f4:	eb 05                	jmp    801064fb <walkpgdir+0x6b>
  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
801064f6:	b8 00 00 00 00       	mov    $0x0,%eax
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
801064fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801064fe:	5b                   	pop    %ebx
801064ff:	5e                   	pop    %esi
80106500:	5f                   	pop    %edi
80106501:	5d                   	pop    %ebp
80106502:	c3                   	ret    

80106503 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106503:	55                   	push   %ebp
80106504:	89 e5                	mov    %esp,%ebp
80106506:	57                   	push   %edi
80106507:	56                   	push   %esi
80106508:	53                   	push   %ebx
80106509:	83 ec 1c             	sub    $0x1c,%esp
8010650c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
8010650f:	89 d0                	mov    %edx,%eax
80106511:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106516:	89 c3                	mov    %eax,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106518:	8d 54 0a ff          	lea    -0x1(%edx,%ecx,1),%edx
8010651c:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106522:	89 55 e0             	mov    %edx,-0x20(%ebp)
80106525:	8b 7d 08             	mov    0x8(%ebp),%edi
80106528:	29 c7                	sub    %eax,%edi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
8010652a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010652d:	83 c8 01             	or     $0x1,%eax
80106530:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106533:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106536:	b9 01 00 00 00       	mov    $0x1,%ecx
8010653b:	89 da                	mov    %ebx,%edx
8010653d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106540:	e8 4b ff ff ff       	call   80106490 <walkpgdir>
80106545:	85 c0                	test   %eax,%eax
80106547:	74 24                	je     8010656d <mappages+0x6a>
      return -1;
    if(*pte & PTE_P)
80106549:	f6 00 01             	testb  $0x1,(%eax)
8010654c:	74 0d                	je     8010655b <mappages+0x58>
      panic("remap");
8010654e:	83 ec 0c             	sub    $0xc,%esp
80106551:	68 e0 75 10 80       	push   $0x801075e0
80106556:	e8 f2 9d ff ff       	call   8010034d <panic>
    *pte = pa | perm | PTE_P;
8010655b:	0b 75 dc             	or     -0x24(%ebp),%esi
8010655e:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106560:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
80106563:	74 0f                	je     80106574 <mappages+0x71>
      break;
    a += PGSIZE;
80106565:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    pa += PGSIZE;
  }
8010656b:	eb c6                	jmp    80106533 <mappages+0x30>

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
8010656d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106572:	eb 05                	jmp    80106579 <mappages+0x76>
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80106574:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106579:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010657c:	5b                   	pop    %ebx
8010657d:	5e                   	pop    %esi
8010657e:	5f                   	pop    %edi
8010657f:	5d                   	pop    %ebp
80106580:	c3                   	ret    

80106581 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80106581:	55                   	push   %ebp
80106582:	89 e5                	mov    %esp,%ebp
80106584:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80106587:	e8 f3 cd ff ff       	call   8010337f <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010658c:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106592:	66 c7 80 18 29 11 80 	movw   $0xffff,-0x7feed6e8(%eax)
80106599:	ff ff 
8010659b:	66 c7 80 1a 29 11 80 	movw   $0x0,-0x7feed6e6(%eax)
801065a2:	00 00 
801065a4:	c6 80 1c 29 11 80 00 	movb   $0x0,-0x7feed6e4(%eax)
801065ab:	c6 80 1d 29 11 80 9a 	movb   $0x9a,-0x7feed6e3(%eax)
801065b2:	c6 80 1e 29 11 80 cf 	movb   $0xcf,-0x7feed6e2(%eax)
801065b9:	c6 80 1f 29 11 80 00 	movb   $0x0,-0x7feed6e1(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801065c0:	66 c7 80 20 29 11 80 	movw   $0xffff,-0x7feed6e0(%eax)
801065c7:	ff ff 
801065c9:	66 c7 80 22 29 11 80 	movw   $0x0,-0x7feed6de(%eax)
801065d0:	00 00 
801065d2:	c6 80 24 29 11 80 00 	movb   $0x0,-0x7feed6dc(%eax)
801065d9:	c6 80 25 29 11 80 92 	movb   $0x92,-0x7feed6db(%eax)
801065e0:	c6 80 26 29 11 80 cf 	movb   $0xcf,-0x7feed6da(%eax)
801065e7:	c6 80 27 29 11 80 00 	movb   $0x0,-0x7feed6d9(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801065ee:	66 c7 80 28 29 11 80 	movw   $0xffff,-0x7feed6d8(%eax)
801065f5:	ff ff 
801065f7:	66 c7 80 2a 29 11 80 	movw   $0x0,-0x7feed6d6(%eax)
801065fe:	00 00 
80106600:	c6 80 2c 29 11 80 00 	movb   $0x0,-0x7feed6d4(%eax)
80106607:	c6 80 2d 29 11 80 fa 	movb   $0xfa,-0x7feed6d3(%eax)
8010660e:	c6 80 2e 29 11 80 cf 	movb   $0xcf,-0x7feed6d2(%eax)
80106615:	c6 80 2f 29 11 80 00 	movb   $0x0,-0x7feed6d1(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010661c:	66 c7 80 30 29 11 80 	movw   $0xffff,-0x7feed6d0(%eax)
80106623:	ff ff 
80106625:	66 c7 80 32 29 11 80 	movw   $0x0,-0x7feed6ce(%eax)
8010662c:	00 00 
8010662e:	c6 80 34 29 11 80 00 	movb   $0x0,-0x7feed6cc(%eax)
80106635:	c6 80 35 29 11 80 f2 	movb   $0xf2,-0x7feed6cb(%eax)
8010663c:	c6 80 36 29 11 80 cf 	movb   $0xcf,-0x7feed6ca(%eax)
80106643:	c6 80 37 29 11 80 00 	movb   $0x0,-0x7feed6c9(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
8010664a:	05 10 29 11 80       	add    $0x80112910,%eax
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
8010664f:	66 c7 45 f2 2f 00    	movw   $0x2f,-0xe(%ebp)
  pd[1] = (uint)p;
80106655:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106659:	c1 e8 10             	shr    $0x10,%eax
8010665c:	66 89 45 f6          	mov    %ax,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80106660:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106663:	0f 01 10             	lgdtl  (%eax)
}
80106666:	c9                   	leave  
80106667:	c3                   	ret    

80106668 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80106668:	55                   	push   %ebp
80106669:	89 e5                	mov    %esp,%ebp
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010666b:	a1 c4 5d 11 80       	mov    0x80115dc4,%eax
80106670:	05 00 00 00 80       	add    $0x80000000,%eax
80106675:	0f 22 d8             	mov    %eax,%cr3
  lcr3(V2P(kpgdir));   // switch to the kernel page table
}
80106678:	5d                   	pop    %ebp
80106679:	c3                   	ret    

8010667a <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
8010667a:	55                   	push   %ebp
8010667b:	89 e5                	mov    %esp,%ebp
8010667d:	57                   	push   %edi
8010667e:	56                   	push   %esi
8010667f:	53                   	push   %ebx
80106680:	83 ec 1c             	sub    $0x1c,%esp
80106683:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106686:	85 f6                	test   %esi,%esi
80106688:	75 0d                	jne    80106697 <switchuvm+0x1d>
    panic("switchuvm: no process");
8010668a:	83 ec 0c             	sub    $0xc,%esp
8010668d:	68 e6 75 10 80       	push   $0x801075e6
80106692:	e8 b6 9c ff ff       	call   8010034d <panic>
  if(p->kstack == 0)
80106697:	83 7e 08 00          	cmpl   $0x0,0x8(%esi)
8010669b:	75 0d                	jne    801066aa <switchuvm+0x30>
    panic("switchuvm: no kstack");
8010669d:	83 ec 0c             	sub    $0xc,%esp
801066a0:	68 fc 75 10 80       	push   $0x801075fc
801066a5:	e8 a3 9c ff ff       	call   8010034d <panic>
  if(p->pgdir == 0)
801066aa:	83 7e 04 00          	cmpl   $0x0,0x4(%esi)
801066ae:	75 0d                	jne    801066bd <switchuvm+0x43>
    panic("switchuvm: no pgdir");
801066b0:	83 ec 0c             	sub    $0xc,%esp
801066b3:	68 11 76 10 80       	push   $0x80107611
801066b8:	e8 90 9c ff ff       	call   8010034d <panic>

  pushcli();
801066bd:	e8 6f d9 ff ff       	call   80104031 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801066c2:	e8 3d cc ff ff       	call   80103304 <mycpu>
801066c7:	89 c3                	mov    %eax,%ebx
801066c9:	e8 36 cc ff ff       	call   80103304 <mycpu>
801066ce:	89 c7                	mov    %eax,%edi
801066d0:	e8 2f cc ff ff       	call   80103304 <mycpu>
801066d5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801066d8:	e8 27 cc ff ff       	call   80103304 <mycpu>
801066dd:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
801066e4:	67 00 
801066e6:	83 c7 08             	add    $0x8,%edi
801066e9:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
801066f0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801066f3:	83 c2 08             	add    $0x8,%edx
801066f6:	c1 ea 10             	shr    $0x10,%edx
801066f9:	88 93 9c 00 00 00    	mov    %dl,0x9c(%ebx)
801066ff:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
80106706:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
8010670d:	83 c0 08             	add    $0x8,%eax
80106710:	c1 e8 18             	shr    $0x18,%eax
80106713:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
80106719:	e8 e6 cb ff ff       	call   80103304 <mycpu>
8010671e:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106725:	e8 da cb ff ff       	call   80103304 <mycpu>
8010672a:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106730:	e8 cf cb ff ff       	call   80103304 <mycpu>
80106735:	8b 4e 08             	mov    0x8(%esi),%ecx
80106738:	8d 91 00 10 00 00    	lea    0x1000(%ecx),%edx
8010673e:	89 50 0c             	mov    %edx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106741:	e8 be cb ff ff       	call   80103304 <mycpu>
80106746:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
8010674c:	b8 28 00 00 00       	mov    $0x28,%eax
80106751:	0f 00 d8             	ltr    %ax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106754:	8b 46 04             	mov    0x4(%esi),%eax
80106757:	05 00 00 00 80       	add    $0x80000000,%eax
8010675c:	0f 22 d8             	mov    %eax,%cr3
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
8010675f:	e8 6f d9 ff ff       	call   801040d3 <popcli>
}
80106764:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106767:	5b                   	pop    %ebx
80106768:	5e                   	pop    %esi
80106769:	5f                   	pop    %edi
8010676a:	5d                   	pop    %ebp
8010676b:	c3                   	ret    

8010676c <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
8010676c:	55                   	push   %ebp
8010676d:	89 e5                	mov    %esp,%ebp
8010676f:	56                   	push   %esi
80106770:	53                   	push   %ebx
80106771:	8b 75 10             	mov    0x10(%ebp),%esi
  char *mem;

  if(sz >= PGSIZE)
80106774:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010677a:	76 0d                	jbe    80106789 <inituvm+0x1d>
    panic("inituvm: more than a page");
8010677c:	83 ec 0c             	sub    $0xc,%esp
8010677f:	68 25 76 10 80       	push   $0x80107625
80106784:	e8 c4 9b ff ff       	call   8010034d <panic>
  mem = kalloc();
80106789:	e8 cf b9 ff ff       	call   8010215d <kalloc>
8010678e:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106790:	83 ec 04             	sub    $0x4,%esp
80106793:	68 00 10 00 00       	push   $0x1000
80106798:	6a 00                	push   $0x0
8010679a:	50                   	push   %eax
8010679b:	e8 d8 d9 ff ff       	call   80104178 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801067a0:	83 c4 08             	add    $0x8,%esp
801067a3:	6a 06                	push   $0x6
801067a5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801067ab:	50                   	push   %eax
801067ac:	b9 00 10 00 00       	mov    $0x1000,%ecx
801067b1:	ba 00 00 00 00       	mov    $0x0,%edx
801067b6:	8b 45 08             	mov    0x8(%ebp),%eax
801067b9:	e8 45 fd ff ff       	call   80106503 <mappages>
  memmove(mem, init, sz);
801067be:	83 c4 0c             	add    $0xc,%esp
801067c1:	56                   	push   %esi
801067c2:	ff 75 0c             	pushl  0xc(%ebp)
801067c5:	53                   	push   %ebx
801067c6:	e8 47 da ff ff       	call   80104212 <memmove>
}
801067cb:	83 c4 10             	add    $0x10,%esp
801067ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
801067d1:	5b                   	pop    %ebx
801067d2:	5e                   	pop    %esi
801067d3:	5d                   	pop    %ebp
801067d4:	c3                   	ret    

801067d5 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
801067d5:	55                   	push   %ebp
801067d6:	89 e5                	mov    %esp,%ebp
801067d8:	57                   	push   %edi
801067d9:	56                   	push   %esi
801067da:	53                   	push   %ebx
801067db:	83 ec 0c             	sub    $0xc,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
801067de:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
801067e5:	75 17                	jne    801067fe <loaduvm+0x29>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
801067e7:	8b 75 18             	mov    0x18(%ebp),%esi
801067ea:	bb 00 00 00 00       	mov    $0x0,%ebx
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
801067ef:	b8 00 00 00 00       	mov    $0x0,%eax
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
801067f4:	85 f6                	test   %esi,%esi
801067f6:	0f 84 80 00 00 00    	je     8010687c <loaduvm+0xa7>
801067fc:	eb 0d                	jmp    8010680b <loaduvm+0x36>
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
801067fe:	83 ec 0c             	sub    $0xc,%esp
80106801:	68 e0 76 10 80       	push   $0x801076e0
80106806:	e8 42 9b ff ff       	call   8010034d <panic>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
8010680b:	89 da                	mov    %ebx,%edx
8010680d:	03 55 0c             	add    0xc(%ebp),%edx
80106810:	b9 00 00 00 00       	mov    $0x0,%ecx
80106815:	8b 45 08             	mov    0x8(%ebp),%eax
80106818:	e8 73 fc ff ff       	call   80106490 <walkpgdir>
8010681d:	85 c0                	test   %eax,%eax
8010681f:	75 0d                	jne    8010682e <loaduvm+0x59>
      panic("loaduvm: address should exist");
80106821:	83 ec 0c             	sub    $0xc,%esp
80106824:	68 3f 76 10 80       	push   $0x8010763f
80106829:	e8 1f 9b ff ff       	call   8010034d <panic>
    pa = PTE_ADDR(*pte);
8010682e:	8b 00                	mov    (%eax),%eax
80106830:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
      n = sz - i;
80106835:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010683b:	bf 00 10 00 00       	mov    $0x1000,%edi
80106840:	0f 46 fe             	cmovbe %esi,%edi
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106843:	57                   	push   %edi
80106844:	89 da                	mov    %ebx,%edx
80106846:	03 55 14             	add    0x14(%ebp),%edx
80106849:	52                   	push   %edx
8010684a:	05 00 00 00 80       	add    $0x80000000,%eax
8010684f:	50                   	push   %eax
80106850:	ff 75 10             	pushl  0x10(%ebp)
80106853:	e8 30 af ff ff       	call   80101788 <readi>
80106858:	83 c4 10             	add    $0x10,%esp
8010685b:	39 c7                	cmp    %eax,%edi
8010685d:	75 18                	jne    80106877 <loaduvm+0xa2>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
8010685f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106865:	81 ee 00 10 00 00    	sub    $0x1000,%esi
8010686b:	39 5d 18             	cmp    %ebx,0x18(%ebp)
8010686e:	77 9b                	ja     8010680b <loaduvm+0x36>
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80106870:	b8 00 00 00 00       	mov    $0x0,%eax
80106875:	eb 05                	jmp    8010687c <loaduvm+0xa7>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
80106877:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
8010687c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010687f:	5b                   	pop    %ebx
80106880:	5e                   	pop    %esi
80106881:	5f                   	pop    %edi
80106882:	5d                   	pop    %ebp
80106883:	c3                   	ret    

80106884 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106884:	55                   	push   %ebp
80106885:	89 e5                	mov    %esp,%ebp
80106887:	57                   	push   %edi
80106888:	56                   	push   %esi
80106889:	53                   	push   %ebx
8010688a:	83 ec 0c             	sub    $0xc,%esp
8010688d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;
80106890:	89 f8                	mov    %edi,%eax
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106892:	39 7d 10             	cmp    %edi,0x10(%ebp)
80106895:	73 74                	jae    8010690b <deallocuvm+0x87>
    return oldsz;

  a = PGROUNDUP(newsz);
80106897:	8b 45 10             	mov    0x10(%ebp),%eax
8010689a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801068a0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
801068a6:	39 df                	cmp    %ebx,%edi
801068a8:	76 5e                	jbe    80106908 <deallocuvm+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
801068aa:	b9 00 00 00 00       	mov    $0x0,%ecx
801068af:	89 da                	mov    %ebx,%edx
801068b1:	8b 45 08             	mov    0x8(%ebp),%eax
801068b4:	e8 d7 fb ff ff       	call   80106490 <walkpgdir>
801068b9:	89 c6                	mov    %eax,%esi
    if(!pte)
801068bb:	85 c0                	test   %eax,%eax
801068bd:	75 0e                	jne    801068cd <deallocuvm+0x49>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801068bf:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
801068c5:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
801068cb:	eb 31                	jmp    801068fe <deallocuvm+0x7a>
    else if((*pte & PTE_P) != 0){
801068cd:	8b 00                	mov    (%eax),%eax
801068cf:	a8 01                	test   $0x1,%al
801068d1:	74 2b                	je     801068fe <deallocuvm+0x7a>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
801068d3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801068d8:	75 0d                	jne    801068e7 <deallocuvm+0x63>
        panic("kfree");
801068da:	83 ec 0c             	sub    $0xc,%esp
801068dd:	68 46 6f 10 80       	push   $0x80106f46
801068e2:	e8 66 9a ff ff       	call   8010034d <panic>
      char *v = P2V(pa);
      kfree(v);
801068e7:	83 ec 0c             	sub    $0xc,%esp
801068ea:	05 00 00 00 80       	add    $0x80000000,%eax
801068ef:	50                   	push   %eax
801068f0:	e8 47 b7 ff ff       	call   8010203c <kfree>
      *pte = 0;
801068f5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801068fb:	83 c4 10             	add    $0x10,%esp

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801068fe:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106904:	39 df                	cmp    %ebx,%edi
80106906:	77 a2                	ja     801068aa <deallocuvm+0x26>
      char *v = P2V(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
80106908:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010690b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010690e:	5b                   	pop    %ebx
8010690f:	5e                   	pop    %esi
80106910:	5f                   	pop    %edi
80106911:	5d                   	pop    %ebp
80106912:	c3                   	ret    

80106913 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106913:	55                   	push   %ebp
80106914:	89 e5                	mov    %esp,%ebp
80106916:	57                   	push   %edi
80106917:	56                   	push   %esi
80106918:	53                   	push   %ebx
80106919:	83 ec 0c             	sub    $0xc,%esp
8010691c:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
8010691f:	85 ff                	test   %edi,%edi
80106921:	0f 88 c6 00 00 00    	js     801069ed <allocuvm+0xda>
    return 0;
  if(newsz < oldsz)
    return oldsz;
80106927:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
8010692a:	3b 7d 0c             	cmp    0xc(%ebp),%edi
8010692d:	0f 82 c3 00 00 00    	jb     801069f6 <allocuvm+0xe3>
    return oldsz;

  a = PGROUNDUP(oldsz);
80106933:	8b 45 0c             	mov    0xc(%ebp),%eax
80106936:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
8010693c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106942:	39 df                	cmp    %ebx,%edi
80106944:	0f 86 aa 00 00 00    	jbe    801069f4 <allocuvm+0xe1>
    mem = kalloc();
8010694a:	e8 0e b8 ff ff       	call   8010215d <kalloc>
8010694f:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106951:	85 c0                	test   %eax,%eax
80106953:	75 26                	jne    8010697b <allocuvm+0x68>
      cprintf("allocuvm out of memory\n");
80106955:	83 ec 0c             	sub    $0xc,%esp
80106958:	68 5d 76 10 80       	push   $0x8010765d
8010695d:	e8 87 9c ff ff       	call   801005e9 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80106962:	83 c4 0c             	add    $0xc,%esp
80106965:	ff 75 0c             	pushl  0xc(%ebp)
80106968:	57                   	push   %edi
80106969:	ff 75 08             	pushl  0x8(%ebp)
8010696c:	e8 13 ff ff ff       	call   80106884 <deallocuvm>
      return 0;
80106971:	83 c4 10             	add    $0x10,%esp
80106974:	b8 00 00 00 00       	mov    $0x0,%eax
80106979:	eb 7b                	jmp    801069f6 <allocuvm+0xe3>
    }
    memset(mem, 0, PGSIZE);
8010697b:	83 ec 04             	sub    $0x4,%esp
8010697e:	68 00 10 00 00       	push   $0x1000
80106983:	6a 00                	push   $0x0
80106985:	50                   	push   %eax
80106986:	e8 ed d7 ff ff       	call   80104178 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
8010698b:	83 c4 08             	add    $0x8,%esp
8010698e:	6a 06                	push   $0x6
80106990:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106996:	50                   	push   %eax
80106997:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010699c:	89 da                	mov    %ebx,%edx
8010699e:	8b 45 08             	mov    0x8(%ebp),%eax
801069a1:	e8 5d fb ff ff       	call   80106503 <mappages>
801069a6:	83 c4 10             	add    $0x10,%esp
801069a9:	85 c0                	test   %eax,%eax
801069ab:	79 2e                	jns    801069db <allocuvm+0xc8>
      cprintf("allocuvm out of memory (2)\n");
801069ad:	83 ec 0c             	sub    $0xc,%esp
801069b0:	68 75 76 10 80       	push   $0x80107675
801069b5:	e8 2f 9c ff ff       	call   801005e9 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
801069ba:	83 c4 0c             	add    $0xc,%esp
801069bd:	ff 75 0c             	pushl  0xc(%ebp)
801069c0:	57                   	push   %edi
801069c1:	ff 75 08             	pushl  0x8(%ebp)
801069c4:	e8 bb fe ff ff       	call   80106884 <deallocuvm>
      kfree(mem);
801069c9:	89 34 24             	mov    %esi,(%esp)
801069cc:	e8 6b b6 ff ff       	call   8010203c <kfree>
      return 0;
801069d1:	83 c4 10             	add    $0x10,%esp
801069d4:	b8 00 00 00 00       	mov    $0x0,%eax
801069d9:	eb 1b                	jmp    801069f6 <allocuvm+0xe3>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
801069db:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801069e1:	39 df                	cmp    %ebx,%edi
801069e3:	0f 87 61 ff ff ff    	ja     8010694a <allocuvm+0x37>
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
    }
  }
  return newsz;
801069e9:	89 f8                	mov    %edi,%eax
801069eb:	eb 09                	jmp    801069f6 <allocuvm+0xe3>
{
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
    return 0;
801069ed:	b8 00 00 00 00       	mov    $0x0,%eax
801069f2:	eb 02                	jmp    801069f6 <allocuvm+0xe3>
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
    }
  }
  return newsz;
801069f4:	89 f8                	mov    %edi,%eax
}
801069f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801069f9:	5b                   	pop    %ebx
801069fa:	5e                   	pop    %esi
801069fb:	5f                   	pop    %edi
801069fc:	5d                   	pop    %ebp
801069fd:	c3                   	ret    

801069fe <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801069fe:	55                   	push   %ebp
801069ff:	89 e5                	mov    %esp,%ebp
80106a01:	57                   	push   %edi
80106a02:	56                   	push   %esi
80106a03:	53                   	push   %ebx
80106a04:	83 ec 0c             	sub    $0xc,%esp
80106a07:	8b 7d 08             	mov    0x8(%ebp),%edi
  uint i;

  if(pgdir == 0)
80106a0a:	85 ff                	test   %edi,%edi
80106a0c:	75 0d                	jne    80106a1b <freevm+0x1d>
    panic("freevm: no pgdir");
80106a0e:	83 ec 0c             	sub    $0xc,%esp
80106a11:	68 91 76 10 80       	push   $0x80107691
80106a16:	e8 32 99 ff ff       	call   8010034d <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80106a1b:	83 ec 04             	sub    $0x4,%esp
80106a1e:	6a 00                	push   $0x0
80106a20:	68 00 00 00 80       	push   $0x80000000
80106a25:	57                   	push   %edi
80106a26:	e8 59 fe ff ff       	call   80106884 <deallocuvm>
80106a2b:	89 fb                	mov    %edi,%ebx
80106a2d:	8d b7 00 10 00 00    	lea    0x1000(%edi),%esi
80106a33:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
    if(pgdir[i] & PTE_P){
80106a36:	8b 03                	mov    (%ebx),%eax
80106a38:	a8 01                	test   $0x1,%al
80106a3a:	74 16                	je     80106a52 <freevm+0x54>
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
80106a3c:	83 ec 0c             	sub    $0xc,%esp
80106a3f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106a44:	05 00 00 00 80       	add    $0x80000000,%eax
80106a49:	50                   	push   %eax
80106a4a:	e8 ed b5 ff ff       	call   8010203c <kfree>
80106a4f:	83 c4 10             	add    $0x10,%esp
80106a52:	83 c3 04             	add    $0x4,%ebx
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106a55:	39 f3                	cmp    %esi,%ebx
80106a57:	75 dd                	jne    80106a36 <freevm+0x38>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106a59:	83 ec 0c             	sub    $0xc,%esp
80106a5c:	57                   	push   %edi
80106a5d:	e8 da b5 ff ff       	call   8010203c <kfree>
}
80106a62:	83 c4 10             	add    $0x10,%esp
80106a65:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a68:	5b                   	pop    %ebx
80106a69:	5e                   	pop    %esi
80106a6a:	5f                   	pop    %edi
80106a6b:	5d                   	pop    %ebp
80106a6c:	c3                   	ret    

80106a6d <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80106a6d:	55                   	push   %ebp
80106a6e:	89 e5                	mov    %esp,%ebp
80106a70:	56                   	push   %esi
80106a71:	53                   	push   %ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80106a72:	e8 e6 b6 ff ff       	call   8010215d <kalloc>
80106a77:	85 c0                	test   %eax,%eax
80106a79:	74 5b                	je     80106ad6 <setupkvm+0x69>
80106a7b:	89 c6                	mov    %eax,%esi
    return 0;
  memset(pgdir, 0, PGSIZE);
80106a7d:	83 ec 04             	sub    $0x4,%esp
80106a80:	68 00 10 00 00       	push   $0x1000
80106a85:	6a 00                	push   $0x0
80106a87:	50                   	push   %eax
80106a88:	e8 eb d6 ff ff       	call   80104178 <memset>
80106a8d:	83 c4 10             	add    $0x10,%esp
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106a90:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106a95:	8b 43 04             	mov    0x4(%ebx),%eax
80106a98:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106a9b:	29 c1                	sub    %eax,%ecx
80106a9d:	83 ec 08             	sub    $0x8,%esp
80106aa0:	ff 73 0c             	pushl  0xc(%ebx)
80106aa3:	50                   	push   %eax
80106aa4:	8b 13                	mov    (%ebx),%edx
80106aa6:	89 f0                	mov    %esi,%eax
80106aa8:	e8 56 fa ff ff       	call   80106503 <mappages>
80106aad:	83 c4 10             	add    $0x10,%esp
80106ab0:	85 c0                	test   %eax,%eax
80106ab2:	79 13                	jns    80106ac7 <setupkvm+0x5a>
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
80106ab4:	83 ec 0c             	sub    $0xc,%esp
80106ab7:	56                   	push   %esi
80106ab8:	e8 41 ff ff ff       	call   801069fe <freevm>
      return 0;
80106abd:	83 c4 10             	add    $0x10,%esp
80106ac0:	b8 00 00 00 00       	mov    $0x0,%eax
80106ac5:	eb 14                	jmp    80106adb <setupkvm+0x6e>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106ac7:	83 c3 10             	add    $0x10,%ebx
80106aca:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106ad0:	75 c3                	jne    80106a95 <setupkvm+0x28>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
    }
  return pgdir;
80106ad2:	89 f0                	mov    %esi,%eax
80106ad4:	eb 05                	jmp    80106adb <setupkvm+0x6e>
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
80106ad6:	b8 00 00 00 00       	mov    $0x0,%eax
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
    }
  return pgdir;
}
80106adb:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106ade:	5b                   	pop    %ebx
80106adf:	5e                   	pop    %esi
80106ae0:	5d                   	pop    %ebp
80106ae1:	c3                   	ret    

80106ae2 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80106ae2:	55                   	push   %ebp
80106ae3:	89 e5                	mov    %esp,%ebp
80106ae5:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106ae8:	e8 80 ff ff ff       	call   80106a6d <setupkvm>
80106aed:	a3 c4 5d 11 80       	mov    %eax,0x80115dc4
  switchkvm();
80106af2:	e8 71 fb ff ff       	call   80106668 <switchkvm>
}
80106af7:	c9                   	leave  
80106af8:	c3                   	ret    

80106af9 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106af9:	55                   	push   %ebp
80106afa:	89 e5                	mov    %esp,%ebp
80106afc:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106aff:	b9 00 00 00 00       	mov    $0x0,%ecx
80106b04:	8b 55 0c             	mov    0xc(%ebp),%edx
80106b07:	8b 45 08             	mov    0x8(%ebp),%eax
80106b0a:	e8 81 f9 ff ff       	call   80106490 <walkpgdir>
  if(pte == 0)
80106b0f:	85 c0                	test   %eax,%eax
80106b11:	75 0d                	jne    80106b20 <clearpteu+0x27>
    panic("clearpteu");
80106b13:	83 ec 0c             	sub    $0xc,%esp
80106b16:	68 a2 76 10 80       	push   $0x801076a2
80106b1b:	e8 2d 98 ff ff       	call   8010034d <panic>
  *pte &= ~PTE_U;
80106b20:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106b23:	c9                   	leave  
80106b24:	c3                   	ret    

80106b25 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106b25:	55                   	push   %ebp
80106b26:	89 e5                	mov    %esp,%ebp
80106b28:	57                   	push   %edi
80106b29:	56                   	push   %esi
80106b2a:	53                   	push   %ebx
80106b2b:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106b2e:	e8 3a ff ff ff       	call   80106a6d <setupkvm>
80106b33:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106b36:	85 c0                	test   %eax,%eax
80106b38:	0f 84 c2 00 00 00    	je     80106c00 <copyuvm+0xdb>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106b3e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80106b42:	0f 84 bf 00 00 00    	je     80106c07 <copyuvm+0xe2>
80106b48:	bf 00 00 00 00       	mov    $0x0,%edi
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106b4d:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80106b50:	b9 00 00 00 00       	mov    $0x0,%ecx
80106b55:	89 fa                	mov    %edi,%edx
80106b57:	8b 45 08             	mov    0x8(%ebp),%eax
80106b5a:	e8 31 f9 ff ff       	call   80106490 <walkpgdir>
80106b5f:	85 c0                	test   %eax,%eax
80106b61:	75 0d                	jne    80106b70 <copyuvm+0x4b>
      panic("copyuvm: pte should exist");
80106b63:	83 ec 0c             	sub    $0xc,%esp
80106b66:	68 ac 76 10 80       	push   $0x801076ac
80106b6b:	e8 dd 97 ff ff       	call   8010034d <panic>
    if(!(*pte & PTE_P))
80106b70:	8b 00                	mov    (%eax),%eax
80106b72:	a8 01                	test   $0x1,%al
80106b74:	75 0d                	jne    80106b83 <copyuvm+0x5e>
      panic("copyuvm: page not present");
80106b76:	83 ec 0c             	sub    $0xc,%esp
80106b79:	68 c6 76 10 80       	push   $0x801076c6
80106b7e:	e8 ca 97 ff ff       	call   8010034d <panic>
    pa = PTE_ADDR(*pte);
80106b83:	89 c6                	mov    %eax,%esi
80106b85:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    flags = PTE_FLAGS(*pte);
80106b8b:	25 ff 0f 00 00       	and    $0xfff,%eax
80106b90:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if((mem = kalloc()) == 0)
80106b93:	e8 c5 b5 ff ff       	call   8010215d <kalloc>
80106b98:	89 c3                	mov    %eax,%ebx
80106b9a:	85 c0                	test   %eax,%eax
80106b9c:	74 4d                	je     80106beb <copyuvm+0xc6>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106b9e:	83 ec 04             	sub    $0x4,%esp
80106ba1:	68 00 10 00 00       	push   $0x1000
80106ba6:	81 c6 00 00 00 80    	add    $0x80000000,%esi
80106bac:	56                   	push   %esi
80106bad:	50                   	push   %eax
80106bae:	e8 5f d6 ff ff       	call   80104212 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80106bb3:	83 c4 08             	add    $0x8,%esp
80106bb6:	ff 75 e0             	pushl  -0x20(%ebp)
80106bb9:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80106bbf:	53                   	push   %ebx
80106bc0:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106bc5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106bc8:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106bcb:	e8 33 f9 ff ff       	call   80106503 <mappages>
80106bd0:	83 c4 10             	add    $0x10,%esp
80106bd3:	85 c0                	test   %eax,%eax
80106bd5:	78 14                	js     80106beb <copyuvm+0xc6>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106bd7:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106bdd:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80106be0:	0f 87 67 ff ff ff    	ja     80106b4d <copyuvm+0x28>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
      goto bad;
  }
  return d;
80106be6:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106be9:	eb 1f                	jmp    80106c0a <copyuvm+0xe5>

bad:
  freevm(d);
80106beb:	83 ec 0c             	sub    $0xc,%esp
80106bee:	ff 75 dc             	pushl  -0x24(%ebp)
80106bf1:	e8 08 fe ff ff       	call   801069fe <freevm>
  return 0;
80106bf6:	83 c4 10             	add    $0x10,%esp
80106bf9:	b8 00 00 00 00       	mov    $0x0,%eax
80106bfe:	eb 0a                	jmp    80106c0a <copyuvm+0xe5>
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
80106c00:	b8 00 00 00 00       	mov    $0x0,%eax
80106c05:	eb 03                	jmp    80106c0a <copyuvm+0xe5>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
      goto bad;
  }
  return d;
80106c07:	8b 45 dc             	mov    -0x24(%ebp),%eax

bad:
  freevm(d);
  return 0;
}
80106c0a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c0d:	5b                   	pop    %ebx
80106c0e:	5e                   	pop    %esi
80106c0f:	5f                   	pop    %edi
80106c10:	5d                   	pop    %ebp
80106c11:	c3                   	ret    

80106c12 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106c12:	55                   	push   %ebp
80106c13:	89 e5                	mov    %esp,%ebp
80106c15:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106c18:	b9 00 00 00 00       	mov    $0x0,%ecx
80106c1d:	8b 55 0c             	mov    0xc(%ebp),%edx
80106c20:	8b 45 08             	mov    0x8(%ebp),%eax
80106c23:	e8 68 f8 ff ff       	call   80106490 <walkpgdir>
  if((*pte & PTE_P) == 0)
80106c28:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
80106c2a:	89 c2                	mov    %eax,%edx
80106c2c:	83 e2 05             	and    $0x5,%edx
80106c2f:	83 fa 05             	cmp    $0x5,%edx
80106c32:	75 0c                	jne    80106c40 <uva2ka+0x2e>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80106c34:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106c39:	05 00 00 00 80       	add    $0x80000000,%eax
80106c3e:	eb 05                	jmp    80106c45 <uva2ka+0x33>

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
80106c40:	b8 00 00 00 00       	mov    $0x0,%eax
  return (char*)P2V(PTE_ADDR(*pte));
}
80106c45:	c9                   	leave  
80106c46:	c3                   	ret    

80106c47 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106c47:	55                   	push   %ebp
80106c48:	89 e5                	mov    %esp,%ebp
80106c4a:	57                   	push   %edi
80106c4b:	56                   	push   %esi
80106c4c:	53                   	push   %ebx
80106c4d:	83 ec 0c             	sub    $0xc,%esp
80106c50:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106c53:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80106c57:	74 55                	je     80106cae <copyout+0x67>
    va0 = (uint)PGROUNDDOWN(va);
80106c59:	89 df                	mov    %ebx,%edi
80106c5b:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80106c61:	83 ec 08             	sub    $0x8,%esp
80106c64:	57                   	push   %edi
80106c65:	ff 75 08             	pushl  0x8(%ebp)
80106c68:	e8 a5 ff ff ff       	call   80106c12 <uva2ka>
    if(pa0 == 0)
80106c6d:	83 c4 10             	add    $0x10,%esp
80106c70:	85 c0                	test   %eax,%eax
80106c72:	74 41                	je     80106cb5 <copyout+0x6e>
      return -1;
    n = PGSIZE - (va - va0);
80106c74:	89 fe                	mov    %edi,%esi
80106c76:	29 de                	sub    %ebx,%esi
80106c78:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106c7e:	3b 75 14             	cmp    0x14(%ebp),%esi
80106c81:	0f 47 75 14          	cmova  0x14(%ebp),%esi
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106c85:	83 ec 04             	sub    $0x4,%esp
80106c88:	56                   	push   %esi
80106c89:	ff 75 10             	pushl  0x10(%ebp)
80106c8c:	29 fb                	sub    %edi,%ebx
80106c8e:	01 d8                	add    %ebx,%eax
80106c90:	50                   	push   %eax
80106c91:	e8 7c d5 ff ff       	call   80104212 <memmove>
    len -= n;
    buf += n;
80106c96:	01 75 10             	add    %esi,0x10(%ebp)
    va = va0 + PGSIZE;
80106c99:	8d 9f 00 10 00 00    	lea    0x1000(%edi),%ebx
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106c9f:	83 c4 10             	add    $0x10,%esp
80106ca2:	29 75 14             	sub    %esi,0x14(%ebp)
80106ca5:	75 b2                	jne    80106c59 <copyout+0x12>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80106ca7:	b8 00 00 00 00       	mov    $0x0,%eax
80106cac:	eb 0c                	jmp    80106cba <copyout+0x73>
80106cae:	b8 00 00 00 00       	mov    $0x0,%eax
80106cb3:	eb 05                	jmp    80106cba <copyout+0x73>
  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
80106cb5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80106cba:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106cbd:	5b                   	pop    %ebx
80106cbe:	5e                   	pop    %esi
80106cbf:	5f                   	pop    %edi
80106cc0:	5d                   	pop    %ebp
80106cc1:	c3                   	ret    
