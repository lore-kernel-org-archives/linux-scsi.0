From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] convert eata to pass pointers around
Date: Wed, 3 Nov 2004 13:59:58 +0100
Message-ID: <20041103125957.GA18084@lst.de>
References: <20041102143351.GA32020@lst.de> <20041102145418.GA24690@parcelfarce.linux.theplanet.co.uk> <20041102150757.GA32497@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:6879 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261587AbUKCNAB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Nov 2004 08:00:01 -0500
Content-Disposition: inline
In-Reply-To: <20041102150757.GA32497@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Christoph Hellwig <hch@lst.de>, jejb@steeleye.com, linux-scsi@vger.kernel.org

On Tue, Nov 02, 2004 at 02:54:18PM +0000, Matthew Wilcox wrote:
> Did you mean to un-static 'sh'?  This seems like an awfully vague
> name to make kernel-global ...

Here's a patch to put it back:

--- drivers/scsi/eata.c~pointers~	2004-11-03 12:49:58.095299872 +0100
+++ drivers/scsi/eata.c	2004-11-03 12:50:10.332439544 +0100
@@ -836,7 +836,7 @@
 	struct mssp sp;		/* Local copy of sp buffer */
 };
 
-struct Scsi_Host *sh[MAX_BOARDS];
+static struct Scsi_Host *sh[MAX_BOARDS];
 static const char *driver_name = "EATA";
 static char sha[MAX_BOARDS];
 static spinlock_t driver_lock = SPIN_LOCK_UNLOCKED;
