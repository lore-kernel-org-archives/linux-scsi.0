From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [ANNOUNCE] MPT Fusion driver 3.01.09 update
Date: Mon, 21 Jun 2004 19:12:30 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040621181230.GA22288@infradead.org>
References: <0E3FA95632D6D047BA649F95DAB60E5704925031@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.146.154.40] ([213.146.154.40]:46055 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S266365AbUFUSMh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Jun 2004 14:12:37 -0400
Content-Disposition: inline
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E5704925031@exa-atlanta>
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Emoore@lsil.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@steeleye.com

On Mon, Jun 21, 2004 at 12:16:08PM -0400, Moore, Eric Dean wrote:
> All,
> 
> We are pleased to announce the MPT Fusion release candidate for lk 2.6
> 
> This driver incorporates the patches from Christoph Hellwig, Jeremy Higdon,
> and Masao Fukuchi.
> 
> Changelog of this release:
>  - merged code from lk 2.4 MPT Fusion driver(from versions 2.05.13 to
> 2.05.16)

I don't think we need to keep around linux_compat.h in the 2.6 tree, just
remove it completely in 2.6 and keep it around in 2.4.

> 
> * Patch from Masao Fukuchi
>  - Remove limit on number of support hosts 

Doesn't the new ioc_list also obsolete the old MptAdapters list?  Also
as arjan said please use list_for_each_entry.

