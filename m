From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/4] aic7xxx/aic79xx: call scsi_set_device()
Date: Sun, 29 May 2005 09:30:52 +0100
Message-ID: <20050529083052.GA19811@infradead.org>
References: <20050529074029.GA25962@havoc.gtf.org> <20050529082422.GA19685@infradead.org> <42997CF9.8000609@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:54168 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261284AbVE2Iax (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 May 2005 04:30:53 -0400
Content-Disposition: inline
In-Reply-To: <42997CF9.8000609@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi@vger.kernel.org

On Sun, May 29, 2005 at 04:27:37AM -0400, Jeff Garzik wrote:
> Christoph Hellwig wrote:
> >scsi_add_host connects the host to the device tree.  scsi_set_device
> >is obsolete and should go away ASAP.
> 
> Ahhh, indeed it does.
> 
> It sounds like I should remove scsi_set_device(), and all calls to it.

We keep it for the few drivers that still use pci_find_device/pci_get_device
loops.  And yes, usage of those APIs should go away aswell..

