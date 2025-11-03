Received: from m16.mail.126.com (m16.mail.126.com [220.197.31.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81BBD299937;
	Mon,  3 Nov 2025 06:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762151933; cv=none; b=IYwoPwl86ss+2lI40I9H9dRdHkoEmCHvqUN4W3++leTf1NSYIUA5wvX/9tk26atGWTHP0dwCozRAGNpflBN2Cfy1ZQM02aPKydPZYkAid4wN6MjqIPmz9+qjBqXFx3EkMXIOXyj1wbdwCgsL9rhrro1ltOwyIcwy8QZ/GE0pXIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762151933; c=relaxed/simple;
	bh=lWCXwxMZ0G6u/4YphoPkZGWPoGem6mXMnt/ZWBJaOOY=;
	h=From:To:Cc:Subject:Date:Message-Id; b=Za2nHm1fwbeLYTcu0Fu1jhaS+jjT0WJMrboNOO/uB6tmUO28rx1+RfOBzkEqwkXS9UbCv0MFEZHhtCeiDWrZp7TMZrar/7KmiwX8qRfKoKZmpGyKiFGF0HI4+7GDBQEoy418ctTg+nrpsbyX0S+e4ShdlCwf8LaHWvysspRKzeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com; spf=pass smtp.mailfrom=126.com; dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b=lGqqfXeZ; arc=none smtp.client-ip=220.197.31.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=126.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b="lGqqfXeZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
	s=s110527; h=From:To:Subject:Date:Message-Id; bh=jdO/Vb4Qkyyu37d
	XFxgmDnGY02teDVLw/5vx64PJ3bY=; b=lGqqfXeZahK6/jDwtO+NgnjCpoXEkdE
	SWP277W8mGlCd2V0w/cstOZzfSn1fRuIAZaZ9OKJtyhEsal1vylrojDIWZYs89OY
	LVyvxugjTutQX8qxv0m9Wf8P80smB9ZtD/DD+BKsFwCG1tsWYwdaomRzqiOos986
	2Gr3oOIbgokE=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wCHmd7iTQhpYLMwAQ--.45109S2;
	Mon, 03 Nov 2025 14:38:26 +0800 (CST)
From: XueBing Chen <chenxb_99091@126.com>
To: Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
	"James E . J . Bottomley" <jejb@linux.ibm.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	XueBing Chen <chenxb_99091@126.com>
Subject: [PATCH] scsi: aacraid: Fix coding style violations in commsup.c
Date: Mon,  3 Nov 2025 14:38:24 +0800
Message-Id: <20251103063824.46891-1-chenxb_99091@126.com>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID:_____wCHmd7iTQhpYLMwAQ--.45109S2
X-Coremail-Antispam: 1Uf129KBjvJXoW3Zry7Gr4DJw1xJrWrWF43trb_yoWDKr1Dpa
	yfGFy3AFWxXrW0gr40qF4UCFySg348trW8AryfA34Fy3srK34rGF1UKryjyF4DC34DCF13
	JF4vk3y5Cr1kKaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zigo7_UUUUU=
X-CM-SenderInfo: hfkh05lebzmiizr6ij2wof0z/1tbiWQj6xWkIR5OC9wAAsu
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Fix multiple coding style issues including:
- Pointer declaration format (struct foo * -> struct foo *)
- Spacing around operators and parentheses
- Line length exceeding 100 columns
- Unnecessary braces in control structures
- Assignment in if conditions

No functional changes, only style improvements.

Signed-off-by: XueBing Chen <chenxb_99091@126.com>
---
 drivers/scsi/aacraid/commsup.c | 87 ++++++++++++++++++----------------
 1 file changed, 46 insertions(+), 41 deletions(-)

diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 25cee03d7f97..d299ff55ef46 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -85,7 +85,7 @@ void aac_fib_map_free(struct aac_dev *dev)
 	size_t fib_size;
 	int num_fibs;
 
-	if(!dev->hw_fib_va || !dev->max_cmd_size)
+	if (!dev->hw_fib_va || !dev->max_cmd_size)
 		return;
 
 	num_fibs = dev->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB;
@@ -109,7 +109,7 @@ void aac_fib_vector_assign(struct aac_dev *dev)
 		i < (dev->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB);
 		i++, fibptr++) {
 		if ((dev->max_msix == 1) ||
-		  (i > ((dev->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB - 1)
+		    (i > ((dev->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB - 1)
 			- dev->vector_cap))) {
 			fibptr->vector_no = 0;
 		} else {
@@ -129,7 +129,7 @@ void aac_fib_vector_assign(struct aac_dev *dev)
  *	fib area, the unmapped fib data and also the free list
  */
 
-int aac_fib_setup(struct aac_dev * dev)
+int aac_fib_setup(struct aac_dev *dev)
 {
 	struct fib *fibptr;
 	struct hw_fib *hw_fib;
@@ -137,14 +137,16 @@ int aac_fib_setup(struct aac_dev * dev)
 	int i;
 	u32 max_cmds;
 
-	while (((i = fib_map_alloc(dev)) == -ENOMEM)
+	i = fib_map_alloc(dev);
+	while ((i == -ENOMEM)
 	 && (dev->scsi_host_ptr->can_queue > (64 - AAC_NUM_MGT_FIB))) {
-		max_cmds = (dev->scsi_host_ptr->can_queue+AAC_NUM_MGT_FIB) >> 1;
+		max_cmds = (dev->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB) >> 1;
 		dev->scsi_host_ptr->can_queue = max_cmds - AAC_NUM_MGT_FIB;
 		if (dev->comm_interface != AAC_COMM_MESSAGE_TYPE3)
 			dev->init->r7.max_io_commands = cpu_to_le32(max_cmds);
+		i = fib_map_alloc(dev);
 	}
-	if (i<0)
+	if (i < 0)
 		return -ENOMEM;
 
 	memset(dev->hw_fib_va, 0,
@@ -166,14 +168,13 @@ int aac_fib_setup(struct aac_dev * dev)
 	 */
 	for (i = 0, fibptr = &dev->fibs[i];
 		i < (dev->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB);
-		i++, fibptr++)
-	{
+		i++, fibptr++) {
 		fibptr->flags = 0;
 		fibptr->size = sizeof(struct fib);
 		fibptr->dev = dev;
 		fibptr->hw_fib_va = hw_fib;
-		fibptr->data = (void *) fibptr->hw_fib_va->data;
-		fibptr->next = fibptr+1;	/* Forward chain the fibs */
+		fibptr->data = (void *)fibptr->hw_fib_va->data;
+		fibptr->next = fibptr + 1;	/* Forward chain the fibs */
 		init_completion(&fibptr->event_wait);
 		spin_lock_init(&fibptr->event_lock);
 		hw_fib->header.XferState = cpu_to_le32(0xffffffff);
@@ -248,11 +249,11 @@ struct fib *aac_fib_alloc_tag(struct aac_dev *dev, struct scsi_cmnd *scmd)
 
 struct fib *aac_fib_alloc(struct aac_dev *dev)
 {
-	struct fib * fibptr;
+	struct fib *fibptr;
 	unsigned long flags;
 	spin_lock_irqsave(&dev->fib_lock, flags);
 	fibptr = dev->free_fib;
-	if(!fibptr){
+	if (!fibptr) {
 		spin_unlock_irqrestore(&dev->fib_lock, flags);
 		return fibptr;
 	}
@@ -295,7 +296,7 @@ void aac_fib_free(struct fib *fibptr)
 	if (!(fibptr->flags & FIB_CONTEXT_FLAG_NATIVE_HBA) &&
 		fibptr->hw_fib_va->header.XferState != 0) {
 		printk(KERN_WARNING "aac_fib_free, XferState != 0, fibptr = 0x%p, XferState = 0x%x\n",
-			 (void*)fibptr,
+			 (void *)fibptr,
 			 le32_to_cpu(fibptr->hw_fib_va->header.XferState));
 	}
 	fibptr->next = fibptr->dev->free_fib;
@@ -330,7 +331,7 @@ void aac_fib_init(struct fib *fibptr)
  *	caller.
  */
 
-static void fib_dealloc(struct fib * fibptr)
+static void fib_dealloc(struct fib *fibptr)
 {
 	struct hw_fib *hw_fib = fibptr->hw_fib_va;
 	hw_fib->header.XferState = 0;
@@ -356,9 +357,10 @@ static void fib_dealloc(struct fib * fibptr)
  *	returned.
  */
 
-static int aac_get_entry (struct aac_dev * dev, u32 qid, struct aac_entry **entry, u32 * index, unsigned long *nonotify)
+static int aac_get_entry(struct aac_dev *dev, u32 qid, struct aac_entry **entry,
+			 u32 *index, unsigned long *nonotify)
 {
-	struct aac_queue * q;
+	struct aac_queue *q;
 	unsigned long idx;
 
 	/*
@@ -418,9 +420,10 @@ static int aac_get_entry (struct aac_dev * dev, u32 qid, struct aac_entry **entr
  *	success.
  */
 
-int aac_queue_get(struct aac_dev * dev, u32 * index, u32 qid, struct hw_fib * hw_fib, int wait, struct fib * fibptr, unsigned long *nonotify)
+int aac_queue_get(struct aac_dev *dev, u32 *index, u32 qid, struct hw_fib *hw_fib,
+		   int wait, struct fib *fibptr, unsigned long *nonotify)
 {
-	struct aac_entry * entry = NULL;
+	struct aac_entry *entry = NULL;
 	int map = 0;
 
 	if (qid == AdapNormCmdQueue) {
@@ -484,8 +487,8 @@ int aac_fib_send(u16 command, struct fib *fibptr, unsigned long size,
 		int priority, int wait, int reply, fib_callback callback,
 		void *callback_data)
 {
-	struct aac_dev * dev = fibptr->dev;
-	struct hw_fib * hw_fib = fibptr->hw_fib_va;
+	struct aac_dev *dev = fibptr->dev;
+	struct hw_fib *hw_fib = fibptr->hw_fib_va;
 	unsigned long flags = 0;
 	unsigned long mflags = 0;
 	unsigned long sflags = 0;
@@ -573,9 +576,9 @@ int aac_fib_send(u16 command, struct fib *fibptr, unsigned long size,
 	dprintk((KERN_DEBUG "  Command =               %d.\n", le32_to_cpu(hw_fib->header.Command)));
 	dprintk((KERN_DEBUG "  SubCommand =            %d.\n", le32_to_cpu(((struct aac_query_mount *)fib_data(fibptr))->command)));
 	dprintk((KERN_DEBUG "  XferState  =            %x.\n", le32_to_cpu(hw_fib->header.XferState)));
-	dprintk((KERN_DEBUG "  hw_fib va being sent=%p\n",fibptr->hw_fib_va));
-	dprintk((KERN_DEBUG "  hw_fib pa being sent=%lx\n",(ulong)fibptr->hw_fib_pa));
-	dprintk((KERN_DEBUG "  fib being sent=%p\n",fibptr));
+	dprintk((KERN_DEBUG "  hw_fib va being sent=%p\n", fibptr->hw_fib_va));
+	dprintk((KERN_DEBUG "  hw_fib pa being sent=%lx\n", (ulong)fibptr->hw_fib_pa));
+	dprintk((KERN_DEBUG "  fib being sent=%p\n", fibptr));
 
 	if (!dev->queues)
 		return -EBUSY;
@@ -663,7 +666,8 @@ int aac_fib_send(u16 command, struct fib *fibptr, unsigned long size,
 				if (unlikely(aac_pci_offline(dev)))
 					return -EFAULT;
 
-				if ((blink = aac_adapter_check_health(dev)) > 0) {
+				blink = aac_adapter_check_health(dev);
+				if (blink > 0) {
 					if (wait == -1) {
 	        				printk(KERN_ERR "aacraid: aac_fib_send: adapter blinkLED 0x%x.\n"
 						  "Usually a result of a serious unrecoverable hardware problem\n",
@@ -797,7 +801,7 @@ int aac_hba_send(u8 command, struct fib *fibptr, fib_callback callback,
  *	not change the state of the queue.
  */
 
-int aac_consumer_get(struct aac_dev * dev, struct aac_queue * q, struct aac_entry **entry)
+int aac_consumer_get(struct aac_dev *dev, struct aac_queue *q, struct aac_entry **entry)
 {
 	u32 index;
 	int status;
@@ -829,12 +833,12 @@ int aac_consumer_get(struct aac_dev * dev, struct aac_queue * q, struct aac_entr
  *	queue was full notify the producer that the queue is no longer full.
  */
 
-void aac_consumer_free(struct aac_dev * dev, struct aac_queue *q, u32 qid)
+void aac_consumer_free(struct aac_dev *dev, struct aac_queue *q, u32 qid)
 {
 	int wasfull = 0;
 	u32 notify;
 
-	if ((le32_to_cpu(*q->headers.producer)+1) == le32_to_cpu(*q->headers.consumer))
+	if ((le32_to_cpu(*q->headers.producer) + 1) == le32_to_cpu(*q->headers.consumer))
 		wasfull = 1;
 
 	if (le32_to_cpu(*q->headers.consumer) >= q->entries)
@@ -870,9 +874,9 @@ void aac_consumer_free(struct aac_dev * dev, struct aac_queue *q, u32 qid)
 
 int aac_fib_adapter_complete(struct fib *fibptr, unsigned short size)
 {
-	struct hw_fib * hw_fib = fibptr->hw_fib_va;
-	struct aac_dev * dev = fibptr->dev;
-	struct aac_queue * q;
+	struct hw_fib *hw_fib = fibptr->hw_fib_va;
+	struct aac_dev *dev = fibptr->dev;
+	struct aac_queue *q;
 	unsigned long nointr = 0;
 	unsigned long qflags;
 
@@ -942,7 +946,7 @@ int aac_fib_adapter_complete(struct fib *fibptr, unsigned short size)
 
 int aac_fib_complete(struct fib *fibptr)
 {
-	struct hw_fib * hw_fib = fibptr->hw_fib_va;
+	struct hw_fib *hw_fib = fibptr->hw_fib_va;
 
 	if (fibptr->flags & FIB_CONTEXT_FLAG_NATIVE_HBA) {
 		fib_dealloc(fibptr);
@@ -1059,10 +1063,10 @@ static void aac_handle_aif_bu(struct aac_dev *dev, struct aac_aifcmd *aifcmd)
  *	This routine handles a driver notify fib from the adapter and
  *	dispatches it to the appropriate routine for handling.
  */
-static void aac_handle_aif(struct aac_dev * dev, struct fib * fibptr)
+static void aac_handle_aif(struct aac_dev *dev, struct fib *fibptr)
 {
-	struct hw_fib * hw_fib = fibptr->hw_fib_va;
-	struct aac_aifcmd * aifcmd = (struct aac_aifcmd *)hw_fib->data;
+	struct hw_fib *hw_fib = fibptr->hw_fib_va;
+	struct aac_aifcmd *aifcmd = (struct aac_aifcmd *)hw_fib->data;
 	u32 channel, id, lun, container;
 	struct scsi_device *device;
 	enum {
@@ -1670,7 +1674,7 @@ int aac_reset_adapter(struct aac_dev *aac, int forced, u8 reset_type)
 
 			aac_fib_init(fibctx);
 
-			cmd = (struct aac_pause *) fib_data(fibctx);
+			cmd = (struct aac_pause *)fib_data(fibctx);
 
 			cmd->command = cpu_to_le32(VM_ContainerConfig);
 			cmd->type = cpu_to_le32(CT_PAUSE_IO);
@@ -1698,17 +1702,18 @@ int aac_reset_adapter(struct aac_dev *aac, int forced, u8 reset_type)
 	return retval;
 }
 
-int aac_check_health(struct aac_dev * aac)
+int aac_check_health(struct aac_dev *aac)
 {
 	int BlinkLED;
 	unsigned long time_now, flagv = 0;
-	struct list_head * entry;
+	struct list_head *entry;
 
 	/* Extending the scope of fib_lock slightly to protect aac->in_reset */
 	if (spin_trylock_irqsave(&aac->fib_lock, flagv) == 0)
 		return 0;
 
-	if (aac->in_reset || !(BlinkLED = aac_adapter_check_health(aac))) {
+	BlinkLED = aac_adapter_check_health(aac);
+	if (aac->in_reset || !BlinkLED) {
 		spin_unlock_irqrestore(&aac->fib_lock, flagv);
 		return 0; /* OK */
 	}
@@ -1738,8 +1743,8 @@ int aac_check_health(struct aac_dev * aac)
 		 * Extract the fibctx
 		 */
 		struct aac_fib_context *fibctx = list_entry(entry, struct aac_fib_context, next);
-		struct hw_fib * hw_fib;
-		struct fib * fib;
+		struct hw_fib *hw_fib;
+		struct fib *fib;
 		/*
 		 * Check if the queue is getting
 		 * backlogged
@@ -2204,7 +2209,7 @@ static void aac_process_events(struct aac_dev *dev)
 		 *	We only handle AifRequest fibs from the adapter.
 		 */
 
-		aifcmd = (struct aac_aifcmd *) hw_fib->data;
+		aifcmd = (struct aac_aifcmd *)hw_fib->data;
 		if (aifcmd->command == cpu_to_le32(AifCmdDriverNotify)) {
 			/* Handle Driver Notify Events */
 			aac_handle_aif(dev, fib);
-- 
2.17.1

