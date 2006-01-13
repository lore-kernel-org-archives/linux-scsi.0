From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2.6.15] I2O: move pci_request_regions() just behind pci_enable_device()
Date: Fri, 13 Jan 2006 18:08:59 +0000
Message-ID: <20060113180859.GF20718@infradead.org>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189F0207C3C4@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:16529 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1422774AbWAMSJE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2006 13:09:04 -0500
Content-Disposition: inline
In-Reply-To: <547AF3BD0F3F0B4CBDC379BAC7E4189F0207C3C4@otce2k03.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: Ryoji Kamei <kamei@miraclelinux.com>, linux-scsi <linux-scsi@vger.kernel.org>, Markus Lidel <Markus.Lidel@shadowconnect.com>, akpm@osdl.org

On Thu, Jan 12, 2006 at 08:31:57AM -0500, Salyzyn, Mark wrote:
> The problem in dpt_i2o could be the pci config space accesses it
> triggers as it loads, dangerous to do if there is any I/O activity going
> on in the other driver (probable if a boot driver I guess).
> 
> I approve this patch to dpt_i2o.c, and am applying it to the Adaptec
> branch of the driver.
> 
> Thanks for the investigation Ryoji.

looks good.

