From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/4] aic7xxx/aic79xx: call scsi_set_device()
Date: Sun, 29 May 2005 09:24:22 +0100
Message-ID: <20050529082422.GA19685@infradead.org>
References: <20050529074029.GA25962@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:49560 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261279AbVE2IYY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 May 2005 04:24:24 -0400
Content-Disposition: inline
In-Reply-To: <20050529074029.GA25962@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi@vger.kernel.org

On Sun, May 29, 2005 at 03:40:29AM -0400, Jeff Garzik wrote:
> 
> 
> [note:  just for review...  do not apply, will be submitted later via git]
> 
> author Jeff Garzik <jgarzik@pobox.com> Sun, 29 May 2005 06:47:07 -0400
> committer Jeff Garzik <jgarzik@pobox.com> Sun, 29 May 2005 06:47:07 -0400
> 
> [SCSI] aic7xxx/aic79xx: call scsi_set_device()
> 
> The 2.4.x version correctly called scsi_set_pci_device(), but the
> author missed the corresponding 2.6.x scsi_set_device() change.

scsi_add_host connects the host to the device tree.  scsi_set_device
is obsolete and should go away ASAP.

