From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Bug 4940 Repeatable Kernel Panic on Adaptec 2015S I20 device on bootup
Date: Mon, 8 Aug 2005 15:16:18 +0100
Message-ID: <20050808141618.GA24682@infradead.org>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189F01684222@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:31920 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932072AbVHHOQV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Aug 2005 10:16:21 -0400
Content-Disposition: inline
In-Reply-To: <547AF3BD0F3F0B4CBDC379BAC7E4189F01684222@otce2k03.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>, Markus.Lidel@shadowconnect.com, Andrew Morton <akpm@osdl.org>, alan@redhat.com

On Mon, Aug 08, 2005 at 10:06:11AM -0400, Salyzyn, Mark wrote:
> Suitable for both 2.4 and 2.6 version of the driver. Applies to
> scsi-misc-2.6 git tree.
> 
> Prevent driver from loading if another driver (i2o) has already claimed
> the resources associated with the card. Discussion associated with this
> bug can be referenced at http://bugzilla.kernel.org/show_bug.cgi?id=4940
> where it was agreed to use pci_request_regions in both the dpt_i2o and
> the i2o driver to prevent both drivers loading on the same adapter(s).

Please either update the driver to use the pci_driver model or even
better remove it completely and let everyone use the i2o drivers now
that they have full 64bit dma and managment support.

