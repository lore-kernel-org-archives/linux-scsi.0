Return-Path: <SRS0=Vgdy=EE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1BC9C5DF9D
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 15:37:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7648720838
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 15:37:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Gr/L6fE9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728216AbgJ2Phb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Oct 2020 11:37:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728066AbgJ2PhL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Oct 2020 11:37:11 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECB4EC0613CF;
        Thu, 29 Oct 2020 08:37:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=MvLb3ZHAX1bI15yt8bfogduw/pWmk/6qau0zrngOeK8=; b=Gr/L6fE9B8gF/DXT2zZNGVTilE
        QJTpujrhoqqzI8MGbanZN7zwA0Xejq+1KA5wYZyTJAROeseiTzpoE4soetPYOwWPQken+AqE3iKWw
        DuD6OAnj3/9CoiGIiss5dDAs+Akyx8AicoOWGp5F2eTAFuZQ8k1FTDcN2lAktO8rHNcCDOxUtA8L7
        sIOFT9CXfV0NC/LlXm3uAIFBG96JNDOi3LURL3m61pUDzI2fnj/za1L4IEiUFXLLOmx2w6ktLp9UE
        BpXt5pAxHqO2rn5uHulA7NIarw/rOEocj/P7W0486awDegxku7miBB/UUmogkKqXNEC530umuCd/O
        XFnYtksg==;
Received: from 089144193201.atnat0002.highway.a1.net ([89.144.193.201] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kY9z3-0007rp-5N; Thu, 29 Oct 2020 15:37:03 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Denis Efremov <efremov@linux.com>,
        "David S. Miller" <davem@davemloft.net>,
        Song Liu <song@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Finn Thain <fthain@telegraphics.com.au>,
        Michael Schmitz <schmitzmic@gmail.com>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 16/18] z2ram: reindent
Date:   Thu, 29 Oct 2020 15:58:39 +0100
Message-Id: <20201029145841.144173-17-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201029145841.144173-1-hch@lst.de>
References: <20201029145841.144173-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

reindent the driver using Lident as the code style was far away from
normal Linux code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/block/z2ram.c | 493 ++++++++++++++++++++----------------------
 1 file changed, 236 insertions(+), 257 deletions(-)

diff --git a/drivers/block/z2ram.c b/drivers/block/z2ram.c
index 0e734802ee7cc6..eafecc9a72b38d 100644
--- a/drivers/block/z2ram.c
+++ b/drivers/block/z2ram.c
@@ -42,7 +42,6 @@
 
 #include <linux/zorro.h>
 
-
 #define Z2MINOR_COMBINED      (0)
 #define Z2MINOR_Z2ONLY        (1)
 #define Z2MINOR_CHIPONLY      (2)
@@ -50,17 +49,17 @@
 #define Z2MINOR_MEMLIST2      (5)
 #define Z2MINOR_MEMLIST3      (6)
 #define Z2MINOR_MEMLIST4      (7)
-#define Z2MINOR_COUNT         (8) /* Move this down when adding a new minor */
+#define Z2MINOR_COUNT         (8)	/* Move this down when adding a new minor */
 
 #define Z2RAM_CHUNK1024       ( Z2RAM_CHUNKSIZE >> 10 )
 
 static DEFINE_MUTEX(z2ram_mutex);
-static u_long *z2ram_map    = NULL;
-static u_long z2ram_size    = 0;
-static int z2_count         = 0;
-static int chip_count       = 0;
-static int list_count       = 0;
-static int current_device   = -1;
+static u_long *z2ram_map = NULL;
+static u_long z2ram_size = 0;
+static int z2_count = 0;
+static int chip_count = 0;
+static int list_count = 0;
+static int current_device = -1;
 
 static DEFINE_SPINLOCK(z2ram_lock);
 
@@ -71,7 +70,7 @@ static blk_status_t z2_queue_rq(struct blk_mq_hw_ctx *hctx,
 {
 	struct request *req = bd->rq;
 	unsigned long start = blk_rq_pos(req) << 9;
-	unsigned long len  = blk_rq_cur_bytes(req);
+	unsigned long len = blk_rq_cur_bytes(req);
 
 	blk_mq_start_request(req);
 
@@ -92,7 +91,7 @@ static blk_status_t z2_queue_rq(struct blk_mq_hw_ctx *hctx,
 
 		if (len < size)
 			size = len;
-		addr += z2ram_map[ start >> Z2RAM_CHUNKSHIFT ];
+		addr += z2ram_map[start >> Z2RAM_CHUNKSHIFT];
 		if (rq_data_dir(req) == READ)
 			memcpy(buffer, (char *)addr, size);
 		else
@@ -106,228 +105,214 @@ static blk_status_t z2_queue_rq(struct blk_mq_hw_ctx *hctx,
 	return BLK_STS_OK;
 }
 
-static void
-get_z2ram( void )
+static void get_z2ram(void)
 {
-    int i;
-
-    for ( i = 0; i < Z2RAM_SIZE / Z2RAM_CHUNKSIZE; i++ )
-    {
-	if ( test_bit( i, zorro_unused_z2ram ) )
-	{
-	    z2_count++;
-	    z2ram_map[z2ram_size++] = (unsigned long)ZTWO_VADDR(Z2RAM_START) +
-				      (i << Z2RAM_CHUNKSHIFT);
-	    clear_bit( i, zorro_unused_z2ram );
+	int i;
+
+	for (i = 0; i < Z2RAM_SIZE / Z2RAM_CHUNKSIZE; i++) {
+		if (test_bit(i, zorro_unused_z2ram)) {
+			z2_count++;
+			z2ram_map[z2ram_size++] =
+			    (unsigned long)ZTWO_VADDR(Z2RAM_START) +
+			    (i << Z2RAM_CHUNKSHIFT);
+			clear_bit(i, zorro_unused_z2ram);
+		}
 	}
-    }
 
-    return;
+	return;
 }
 
-static void
-get_chipram( void )
+static void get_chipram(void)
 {
 
-    while ( amiga_chip_avail() > ( Z2RAM_CHUNKSIZE * 4 ) )
-    {
-	chip_count++;
-	z2ram_map[ z2ram_size ] =
-	    (u_long)amiga_chip_alloc( Z2RAM_CHUNKSIZE, "z2ram" );
+	while (amiga_chip_avail() > (Z2RAM_CHUNKSIZE * 4)) {
+		chip_count++;
+		z2ram_map[z2ram_size] =
+		    (u_long) amiga_chip_alloc(Z2RAM_CHUNKSIZE, "z2ram");
 
-	if ( z2ram_map[ z2ram_size ] == 0 )
-	{
-	    break;
+		if (z2ram_map[z2ram_size] == 0) {
+			break;
+		}
+
+		z2ram_size++;
 	}
 
-	z2ram_size++;
-    }
-	
-    return;
+	return;
 }
 
 static int z2_open(struct block_device *bdev, fmode_t mode)
 {
-    int device;
-    int max_z2_map = ( Z2RAM_SIZE / Z2RAM_CHUNKSIZE ) *
-	sizeof( z2ram_map[0] );
-    int max_chip_map = ( amiga_chip_size / Z2RAM_CHUNKSIZE ) *
-	sizeof( z2ram_map[0] );
-    int rc = -ENOMEM;
-
-    device = MINOR(bdev->bd_dev);
-
-    mutex_lock(&z2ram_mutex);
-    if ( current_device != -1 && current_device != device )
-    {
-	rc = -EBUSY;
-	goto err_out;
-    }
-
-    if ( current_device == -1 )
-    {
-	z2_count   = 0;
-	chip_count = 0;
-	list_count = 0;
-	z2ram_size = 0;
-
-	/* Use a specific list entry. */
-	if (device >= Z2MINOR_MEMLIST1 && device <= Z2MINOR_MEMLIST4) {
-		int index = device - Z2MINOR_MEMLIST1 + 1;
-		unsigned long size, paddr, vaddr;
-
-		if (index >= m68k_realnum_memory) {
-			printk( KERN_ERR DEVICE_NAME
-				": no such entry in z2ram_map\n" );
-		        goto err_out;
-		}
-
-		paddr = m68k_memory[index].addr;
-		size = m68k_memory[index].size & ~(Z2RAM_CHUNKSIZE-1);
-
-#ifdef __powerpc__
-		/* FIXME: ioremap doesn't build correct memory tables. */
-		{
-			vfree(vmalloc (size));
-		}
+	int device;
+	int max_z2_map = (Z2RAM_SIZE / Z2RAM_CHUNKSIZE) * sizeof(z2ram_map[0]);
+	int max_chip_map = (amiga_chip_size / Z2RAM_CHUNKSIZE) *
+	    sizeof(z2ram_map[0]);
+	int rc = -ENOMEM;
 
-		vaddr = (unsigned long)ioremap_wt(paddr, size);
+	device = MINOR(bdev->bd_dev);
 
-#else
-		vaddr = (unsigned long)z_remap_nocache_nonser(paddr, size);
-#endif
-		z2ram_map = 
-			kmalloc_array(size / Z2RAM_CHUNKSIZE,
-                                      sizeof(z2ram_map[0]),
-                                      GFP_KERNEL);
-		if ( z2ram_map == NULL )
-		{
-		    printk( KERN_ERR DEVICE_NAME
-			": cannot get mem for z2ram_map\n" );
-		    goto err_out;
-		}
+	mutex_lock(&z2ram_mutex);
+	if (current_device != -1 && current_device != device) {
+		rc = -EBUSY;
+		goto err_out;
+	}
 
-		while (size) {
-			z2ram_map[ z2ram_size++ ] = vaddr;
-			size -= Z2RAM_CHUNKSIZE;
-			vaddr += Z2RAM_CHUNKSIZE;
-			list_count++;
-		}
+	if (current_device == -1) {
+		z2_count = 0;
+		chip_count = 0;
+		list_count = 0;
+		z2ram_size = 0;
 
-		if ( z2ram_size != 0 )
-		    printk( KERN_INFO DEVICE_NAME
-			": using %iK List Entry %d Memory\n",
-			list_count * Z2RAM_CHUNK1024, index );
-	} else
-
-	switch ( device )
-	{
-	    case Z2MINOR_COMBINED:
-
-		z2ram_map = kmalloc( max_z2_map + max_chip_map, GFP_KERNEL );
-		if ( z2ram_map == NULL )
-		{
-		    printk( KERN_ERR DEVICE_NAME
-			": cannot get mem for z2ram_map\n" );
-		    goto err_out;
-		}
+		/* Use a specific list entry. */
+		if (device >= Z2MINOR_MEMLIST1 && device <= Z2MINOR_MEMLIST4) {
+			int index = device - Z2MINOR_MEMLIST1 + 1;
+			unsigned long size, paddr, vaddr;
 
-		get_z2ram();
-		get_chipram();
-
-		if ( z2ram_size != 0 )
-		    printk( KERN_INFO DEVICE_NAME 
-			": using %iK Zorro II RAM and %iK Chip RAM (Total %dK)\n",
-			z2_count * Z2RAM_CHUNK1024,
-			chip_count * Z2RAM_CHUNK1024,
-			( z2_count + chip_count ) * Z2RAM_CHUNK1024 );
-
-	    break;
-
-    	    case Z2MINOR_Z2ONLY:
-		z2ram_map = kmalloc( max_z2_map, GFP_KERNEL );
-		if ( z2ram_map == NULL )
-		{
-		    printk( KERN_ERR DEVICE_NAME
-			": cannot get mem for z2ram_map\n" );
-		    goto err_out;
-		}
+			if (index >= m68k_realnum_memory) {
+				printk(KERN_ERR DEVICE_NAME
+				       ": no such entry in z2ram_map\n");
+				goto err_out;
+			}
 
-		get_z2ram();
+			paddr = m68k_memory[index].addr;
+			size = m68k_memory[index].size & ~(Z2RAM_CHUNKSIZE - 1);
 
-		if ( z2ram_size != 0 )
-		    printk( KERN_INFO DEVICE_NAME 
-			": using %iK of Zorro II RAM\n",
-			z2_count * Z2RAM_CHUNK1024 );
+#ifdef __powerpc__
+			/* FIXME: ioremap doesn't build correct memory tables. */
+			{
+				vfree(vmalloc(size));
+			}
 
-	    break;
+			vaddr = (unsigned long)ioremap_wt(paddr, size);
 
-	    case Z2MINOR_CHIPONLY:
-		z2ram_map = kmalloc( max_chip_map, GFP_KERNEL );
-		if ( z2ram_map == NULL )
-		{
-		    printk( KERN_ERR DEVICE_NAME
-			": cannot get mem for z2ram_map\n" );
-		    goto err_out;
+#else
+			vaddr =
+			    (unsigned long)z_remap_nocache_nonser(paddr, size);
+#endif
+			z2ram_map =
+			    kmalloc_array(size / Z2RAM_CHUNKSIZE,
+					  sizeof(z2ram_map[0]), GFP_KERNEL);
+			if (z2ram_map == NULL) {
+				printk(KERN_ERR DEVICE_NAME
+				       ": cannot get mem for z2ram_map\n");
+				goto err_out;
+			}
+
+			while (size) {
+				z2ram_map[z2ram_size++] = vaddr;
+				size -= Z2RAM_CHUNKSIZE;
+				vaddr += Z2RAM_CHUNKSIZE;
+				list_count++;
+			}
+
+			if (z2ram_size != 0)
+				printk(KERN_INFO DEVICE_NAME
+				       ": using %iK List Entry %d Memory\n",
+				       list_count * Z2RAM_CHUNK1024, index);
+		} else
+			switch (device) {
+			case Z2MINOR_COMBINED:
+
+				z2ram_map =
+				    kmalloc(max_z2_map + max_chip_map,
+					    GFP_KERNEL);
+				if (z2ram_map == NULL) {
+					printk(KERN_ERR DEVICE_NAME
+					       ": cannot get mem for z2ram_map\n");
+					goto err_out;
+				}
+
+				get_z2ram();
+				get_chipram();
+
+				if (z2ram_size != 0)
+					printk(KERN_INFO DEVICE_NAME
+					       ": using %iK Zorro II RAM and %iK Chip RAM (Total %dK)\n",
+					       z2_count * Z2RAM_CHUNK1024,
+					       chip_count * Z2RAM_CHUNK1024,
+					       (z2_count +
+						chip_count) * Z2RAM_CHUNK1024);
+
+				break;
+
+			case Z2MINOR_Z2ONLY:
+				z2ram_map = kmalloc(max_z2_map, GFP_KERNEL);
+				if (z2ram_map == NULL) {
+					printk(KERN_ERR DEVICE_NAME
+					       ": cannot get mem for z2ram_map\n");
+					goto err_out;
+				}
+
+				get_z2ram();
+
+				if (z2ram_size != 0)
+					printk(KERN_INFO DEVICE_NAME
+					       ": using %iK of Zorro II RAM\n",
+					       z2_count * Z2RAM_CHUNK1024);
+
+				break;
+
+			case Z2MINOR_CHIPONLY:
+				z2ram_map = kmalloc(max_chip_map, GFP_KERNEL);
+				if (z2ram_map == NULL) {
+					printk(KERN_ERR DEVICE_NAME
+					       ": cannot get mem for z2ram_map\n");
+					goto err_out;
+				}
+
+				get_chipram();
+
+				if (z2ram_size != 0)
+					printk(KERN_INFO DEVICE_NAME
+					       ": using %iK Chip RAM\n",
+					       chip_count * Z2RAM_CHUNK1024);
+
+				break;
+
+			default:
+				rc = -ENODEV;
+				goto err_out;
+
+				break;
+			}
+
+		if (z2ram_size == 0) {
+			printk(KERN_NOTICE DEVICE_NAME
+			       ": no unused ZII/Chip RAM found\n");
+			goto err_out_kfree;
 		}
 
-		get_chipram();
-
-		if ( z2ram_size != 0 )
-		    printk( KERN_INFO DEVICE_NAME 
-			": using %iK Chip RAM\n",
-			chip_count * Z2RAM_CHUNK1024 );
-		    
-	    break;
-
-	    default:
-		rc = -ENODEV;
-		goto err_out;
-	
-	    break;
+		current_device = device;
+		z2ram_size <<= Z2RAM_CHUNKSHIFT;
+		set_capacity(z2ram_gendisk, z2ram_size >> 9);
 	}
 
-	if ( z2ram_size == 0 )
-	{
-	    printk( KERN_NOTICE DEVICE_NAME
-		": no unused ZII/Chip RAM found\n" );
-	    goto err_out_kfree;
-	}
-
-	current_device = device;
-	z2ram_size <<= Z2RAM_CHUNKSHIFT;
-	set_capacity(z2ram_gendisk, z2ram_size >> 9);
-    }
-
-    mutex_unlock(&z2ram_mutex);
-    return 0;
+	mutex_unlock(&z2ram_mutex);
+	return 0;
 
 err_out_kfree:
-    kfree(z2ram_map);
+	kfree(z2ram_map);
 err_out:
-    mutex_unlock(&z2ram_mutex);
-    return rc;
+	mutex_unlock(&z2ram_mutex);
+	return rc;
 }
 
-static void
-z2_release(struct gendisk *disk, fmode_t mode)
+static void z2_release(struct gendisk *disk, fmode_t mode)
 {
-    mutex_lock(&z2ram_mutex);
-    if ( current_device == -1 ) {
-    	mutex_unlock(&z2ram_mutex);
-    	return;
-    }
-    mutex_unlock(&z2ram_mutex);
-    /*
-     * FIXME: unmap memory
-     */
+	mutex_lock(&z2ram_mutex);
+	if (current_device == -1) {
+		mutex_unlock(&z2ram_mutex);
+		return;
+	}
+	mutex_unlock(&z2ram_mutex);
+	/*
+	 * FIXME: unmap memory
+	 */
 }
 
-static const struct block_device_operations z2_fops =
-{
-	.owner		= THIS_MODULE,
-	.open		= z2_open,
-	.release	= z2_release,
+static const struct block_device_operations z2_fops = {
+	.owner = THIS_MODULE,
+	.open = z2_open,
+	.release = z2_release,
 };
 
 static struct kobject *z2_find(dev_t dev, int *part, void *data)
@@ -340,89 +325,83 @@ static struct request_queue *z2_queue;
 static struct blk_mq_tag_set tag_set;
 
 static const struct blk_mq_ops z2_mq_ops = {
-	.queue_rq	= z2_queue_rq,
+	.queue_rq = z2_queue_rq,
 };
 
-static int __init 
-z2_init(void)
+static int __init z2_init(void)
 {
-    int ret;
+	int ret;
 
-    if (!MACH_IS_AMIGA)
-	return -ENODEV;
+	if (!MACH_IS_AMIGA)
+		return -ENODEV;
 
-    ret = -EBUSY;
-    if (register_blkdev(Z2RAM_MAJOR, DEVICE_NAME))
-	goto err;
+	ret = -EBUSY;
+	if (register_blkdev(Z2RAM_MAJOR, DEVICE_NAME))
+		goto err;
 
-    ret = -ENOMEM;
-    z2ram_gendisk = alloc_disk(1);
-    if (!z2ram_gendisk)
-	goto out_disk;
+	ret = -ENOMEM;
+	z2ram_gendisk = alloc_disk(1);
+	if (!z2ram_gendisk)
+		goto out_disk;
 
-    z2_queue = blk_mq_init_sq_queue(&tag_set, &z2_mq_ops, 16,
+	z2_queue = blk_mq_init_sq_queue(&tag_set, &z2_mq_ops, 16,
 					BLK_MQ_F_SHOULD_MERGE);
-    if (IS_ERR(z2_queue)) {
-	ret = PTR_ERR(z2_queue);
-	z2_queue = NULL;
-	goto out_queue;
-    }
+	if (IS_ERR(z2_queue)) {
+		ret = PTR_ERR(z2_queue);
+		z2_queue = NULL;
+		goto out_queue;
+	}
 
-    z2ram_gendisk->major = Z2RAM_MAJOR;
-    z2ram_gendisk->first_minor = 0;
-    z2ram_gendisk->fops = &z2_fops;
-    sprintf(z2ram_gendisk->disk_name, "z2ram");
+	z2ram_gendisk->major = Z2RAM_MAJOR;
+	z2ram_gendisk->first_minor = 0;
+	z2ram_gendisk->fops = &z2_fops;
+	sprintf(z2ram_gendisk->disk_name, "z2ram");
 
-    z2ram_gendisk->queue = z2_queue;
-    add_disk(z2ram_gendisk);
-    blk_register_region(MKDEV(Z2RAM_MAJOR, 0), Z2MINOR_COUNT, THIS_MODULE,
-				z2_find, NULL, NULL);
+	z2ram_gendisk->queue = z2_queue;
+	add_disk(z2ram_gendisk);
+	blk_register_region(MKDEV(Z2RAM_MAJOR, 0), Z2MINOR_COUNT, THIS_MODULE,
+			    z2_find, NULL, NULL);
 
-    return 0;
+	return 0;
 
 out_queue:
-    put_disk(z2ram_gendisk);
+	put_disk(z2ram_gendisk);
 out_disk:
-    unregister_blkdev(Z2RAM_MAJOR, DEVICE_NAME);
+	unregister_blkdev(Z2RAM_MAJOR, DEVICE_NAME);
 err:
-    return ret;
+	return ret;
 }
 
 static void __exit z2_exit(void)
 {
-    int i, j;
-    blk_unregister_region(MKDEV(Z2RAM_MAJOR, 0), Z2MINOR_COUNT);
-    unregister_blkdev(Z2RAM_MAJOR, DEVICE_NAME);
-    del_gendisk(z2ram_gendisk);
-    put_disk(z2ram_gendisk);
-    blk_cleanup_queue(z2_queue);
-    blk_mq_free_tag_set(&tag_set);
-
-    if ( current_device != -1 )
-    {
-	i = 0;
-
-	for ( j = 0 ; j < z2_count; j++ )
-	{
-	    set_bit( i++, zorro_unused_z2ram ); 
-	}
+	int i, j;
+	blk_unregister_region(MKDEV(Z2RAM_MAJOR, 0), Z2MINOR_COUNT);
+	unregister_blkdev(Z2RAM_MAJOR, DEVICE_NAME);
+	del_gendisk(z2ram_gendisk);
+	put_disk(z2ram_gendisk);
+	blk_cleanup_queue(z2_queue);
+	blk_mq_free_tag_set(&tag_set);
+
+	if (current_device != -1) {
+		i = 0;
+
+		for (j = 0; j < z2_count; j++) {
+			set_bit(i++, zorro_unused_z2ram);
+		}
 
-	for ( j = 0 ; j < chip_count; j++ )
-	{
-	    if ( z2ram_map[ i ] )
-	    {
-		amiga_chip_free( (void *) z2ram_map[ i++ ] );
-	    }
-	}
+		for (j = 0; j < chip_count; j++) {
+			if (z2ram_map[i]) {
+				amiga_chip_free((void *)z2ram_map[i++]);
+			}
+		}
 
-	if ( z2ram_map != NULL )
-	{
-	    kfree( z2ram_map );
+		if (z2ram_map != NULL) {
+			kfree(z2ram_map);
+		}
 	}
-    }
 
-    return;
-} 
+	return;
+}
 
 module_init(z2_init);
 module_exit(z2_exit);
-- 
2.28.0

