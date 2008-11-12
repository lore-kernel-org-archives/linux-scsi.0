From: Anil kumar <anils_r@yahoo.com>
Subject: dma_pool_alloc restrict < 4GB address
Date: Wed, 12 Nov 2008 14:14:24 -0800 (PST)
Message-ID: <231988.14599.qm@web32401.mail.mud.yahoo.com>
Reply-To: anils_r@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754879AbYKLWOf@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,

Is there anyway to restrict the returned bus address(dma address) from dma_poll_alloc to < 4GB ?
The function returns a dma address(of type dma_addr_t). Is there anyway I can ensure to restrict it to < 4B address.
I guess we can do that in pci_alloc_consistent as by default it returns 32bit address. 

with regards,
  Anil


      
