From: Sir Ace <chandleg@wizardsworks.org>
Subject: Maybe a patch?
Date: Tue, 21 Jan 2003 16:08:16 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0301211606060.27122-100000@wizardsworks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wizardsworks.org (IDENT:1000@localhost [127.0.0.1])
	by wizardsworks.wizardsworks.org (8.12.4/8.12.4) with ESMTP id h0M08HnO027170
	for <linux-scsi@vger.kernel.org>; Tue, 21 Jan 2003 16:08:17 -0800
Received: from localhost (chandleg@localhost)
	by wizardsworks.org (8.12.4/8.12.4/Submit) with ESMTP id h0M08G3C027167
	for <linux-scsi@vger.kernel.org>; Tue, 21 Jan 2003 16:08:17 -0800
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


I saw in /usr/src/linux/drivers/net/tg3.c
That the following was added...  I have no idea why..
Like I said I am not a developer nor do I know a lot about this part of
the kernel.  But it now compiles:

Added to /usr/src/linux/drivers/scsi/scsi_merge.c

#ifndef PCI_DMA_BUS_IS_PHYS
#define PCI_DMA_BUS_IS_PHYS 1
#endif


