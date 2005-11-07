From: Anil kumar <anils_r@yahoo.com>
Subject: bus_to_virt equivalent
Date: Mon, 7 Nov 2005 15:52:47 -0800 (PST)
Message-ID: <20051107235247.67981.qmail@web32402.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web32402.mail.mud.yahoo.com ([68.142.207.195]:37240 "HELO
	web32402.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S1030198AbVKGXwu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Nov 2005 18:52:50 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Hi,

I am trying to port bus_to_virt and virt_to_bus to the
DMA-mapping scheme.
I found a way to move virt_to_bus() as follows:
page = virt_to_page(cmd->request_buffer);
offset = (unsigned long)address & ~PAGE_MASK;
dma_addr_t addr = pci_map_page(dev, page, offset,
size,direction);

But now I want to get virtual address for dma_addr_t.

Any help is greatly appreciated.

with regards,
  Anil


		
__________________________________ 
Yahoo! FareChase: Search multiple travel sites in one click.
http://farechase.yahoo.com
