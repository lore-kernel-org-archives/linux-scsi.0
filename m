From: Mark Mokryn <markm@il.marvell.com>
Subject: Highmem SCSI driver
Date: Thu, 06 Nov 2003 18:05:03 +0200
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <3FAA712F.2030409@il.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

We are trying to test 64-bit PCI DMA for a SCSI driver on a Xeon box, 
RH9 2.4.20-8 bigmem kernel, 6GB RAM.
The machine shows 6GB in top, we set highmem_io in the driver, PCI DMA 
mask covers 64-bit range, etc.

Of course we're trying to make sure that the system does not create 
bounce buffers unnecessarily. On a 64-bit box (AMD64) everything works 
as expected. On the Xeon, no matter what we try, we never see I/Os 
mapped above 4GB.

Any ideas on how we can drive I/Os mapped above 4GB down to our driver?

Thanks,
-Mark
