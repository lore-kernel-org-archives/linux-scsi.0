From: jd <jpd_hp_linux_scsi@yahoo.com>
Subject: Scatter Gather question : 2.6.test4 . page to vaddr
Date: Mon, 22 Sep 2003 13:15:40 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030922201540.68358.qmail@web60210.mail.yahoo.com>
Reply-To: dead_emaill@nospam.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web60210.mail.yahoo.com ([216.109.118.105]:14008 "HELO
	web60210.mail.yahoo.com") by vger.kernel.org with SMTP
	id S263320AbTIVUQT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Sep 2003 16:16:19 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>


Hi,

I see that 2.6 scatterlist.h has eliminated the "address" element
and uses page struct only, and that  pci_map_sg() is used to 
populate the dma_address field. I'm not really planning on
using DMA .

How can I convert the page * entry 
pointed to by  SCpnt->request_buffer   back to a vaddr ? 
I don't see a page-to-vaddr() . function ?
Thanks for any insight.

__________________________________
Do you Yahoo!?
Yahoo! SiteBuilder - Free, easy-to-use web site design software
http://sitebuilder.yahoo.com
