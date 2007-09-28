From: Eduardo Pereira Habkost <ehabkost@redhat.com>
Subject: Re: [PATCH] 3w-9xxx: use PCI resource length correctly
Date: Fri, 28 Sep 2007 12:15:31 -0300
Message-ID: <20070928151531.GH4668@blackpad.ctb.virtua.com.br>
References: <20070928144556.GG4668@blackpad.ctb.virtua.com.br> <46FD14BA.7010508@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:41585 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751359AbXI1PPz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Sep 2007 11:15:55 -0400
Content-Disposition: inline
In-Reply-To: <46FD14BA.7010508@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linuxraid@amcc.com, linux-scsi@vger.kernel.org

On Fri, Sep 28, 2007 at 10:50:34AM -0400, Jeff Garzik wrote:
> > 
> > 	/* Save base address */
> >-	tw_dev->base_addr = ioremap(mem_addr, PAGE_SIZE);
> >+	tw_dev->base_addr = ioremap(mem_addr, mem_len);
> 
> Have you verified that the hardware resource is always a reasonable size?

I have seen it on only one machine, where it was 256 bytes.

Were there cases of hardware with broken resource information, before? I
didn't expect this to happen.

If it happens, wouldn't it break pci_request_regions(), anyway?

-- 
Eduardo
