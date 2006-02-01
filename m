From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] - fusion - several patchs from two weeks ago
Date: Wed, 1 Feb 2006 10:35:49 +0000
Message-ID: <20060201103549.GA7637@infradead.org>
References: <F331B95B72AFFB4B87467BE1C8E9CF5F2215E0@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:41877 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1160995AbWBAKfy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Feb 2006 05:35:54 -0500
Content-Disposition: inline
In-Reply-To: <F331B95B72AFFB4B87467BE1C8E9CF5F2215E0@NAMAIL2.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

On Tue, Jan 31, 2006 at 11:20:22AM -0700, Moore, Eric wrote:
> James:
> 
> Apparently in scsi-rc-fixes-2.6.diff:
> 
> You have picked up fusion patches from Jan 16, and
> patches from Jan 25, however patch's posted in between
> on Jan 17th were overlooked.  These are very important bug fix's.
> Can you merge these into your tree?   I have attached a updated
> patch that is rebased to work with your your lastest
> scsi-rc-fixes.  Please apply.
> 
> Missing patches are:
> 
> [PATCH 1/3] fusion - unloading the driver results in panic - fix:
> http://marc.theaimsgroup.com/?l=linux-scsi&m=113754284707413&w=2

this should go in for 2.6.16 still.  maybe without the gratious
s/mpt_sp_log_info/mpt_spi_log_info/g

> [PATCH 2/3] fusion - unloading the driver - only set asyn narrow for
> configured devices
> http://marc.theaimsgroup.com/?l=linux-scsi&m=113754284725421&w=2

is this critical enough for 2.6.16?  otherwise the generic DV code should
take care of it.

> [PATCH 3/3] fusion - sanity check
> http://marc.theaimsgroup.com/?l=linux-scsi&m=113754284702520&w=2

looks good, but probably not critical for 2.6.16 (?)

> [2.6 patch] drivers/message/fusion/mptfc.c: make 2 functions static
> http://marc.theaimsgroup.com/?t=113763271300004&r=1&w=2

Obviously fine, but not critical.
