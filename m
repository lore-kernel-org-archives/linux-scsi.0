From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] current scsi-misc-2.5 scsi_lib.c needs init.h
Date: Thu, 05 Dec 2002 16:26:45 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200212052226.gB5MQjf05474@localhost.localdomain>
References: <patmans@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id OAA16840
	for <linux-scsi@vger.kernel.org>; Thu, 5 Dec 2002 14:26:49 -0800
In-Reply-To: Message from Patrick Mansfield <patmans@us.ibm.com>
   of "Thu, 05 Dec 2002 14:16:33 PST." <20021205141633.A10103@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: JEJ Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

patmans@us.ibm.com said:
> he current scsi-misc-2.5 scsi_lib.c needs to include init.h to get the
> __init and __exit defined. 

not for me here.  init.h seems to be pulled in via a long chain:

                 from include/linux/profile.h:8,
                 from include/asm/hw_irq.h:16,
                 from include/linux/irq.h:69,
                 from include/asm/hardirq.h:6,
                 from include/linux/interrupt.h:9,
                 from include/asm/highmem.h:24,
                 from include/linux/highmem.h:12,
                 from include/linux/bio.h:24,
                 from drivers/scsi/scsi_lib.c:10:

James


