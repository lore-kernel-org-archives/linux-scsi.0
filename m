From: "David S. Miller" <davem@redhat.com>
Subject: Re: unchecked_isa_dma on sparcv9
Date: Tue, 29 Apr 2003 00:15:11 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030429.001511.23033900.davem@redhat.com>
References: <20030429101925.A20537@lst.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pizda.ninka.net ([216.101.162.242]:21172 "EHLO pizda.ninka.net")
	by vger.kernel.org with ESMTP id S261210AbTD2IJG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Apr 2003 04:09:06 -0400
In-Reply-To: <20030429101925.A20537@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: hch@lst.de
Cc: linux-scsi@vger.kernel.org

   From: Christoph Hellwig <hch@lst.de>
   Date: Tue, 29 Apr 2003 10:19:25 +0200

   drivers/scsi/pluto.c contains the following code:
   
   #ifdef __sparc_v9__
   			host->unchecked_isa_dma = 1;
   #endif
   
   The only thing host->unchecked_isa_dma = 1 does is to add a __GFP_DMA
   flag to certain memory allocations, but IIRC __GFP_DMA is a noop on
   sparcv9.  So what is this supposed to do?

It's bogus, delete it.
