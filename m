From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/5] aacraid: Check scsi_bios_ptabe return code
Date: Wed, 30 Nov 2005 19:14:00 +0000
Message-ID: <20051130191400.GD19001@infradead.org>
References: <1133375802.2288.25.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:15042 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751537AbVK3TOB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Nov 2005 14:14:01 -0500
Content-Disposition: inline
In-Reply-To: <1133375802.2288.25.camel@markh1.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

On Wed, Nov 30, 2005 at 10:36:42AM -0800, Mark Haverkamp wrote:
> Received from Mark Salyzyn.
> 
> scsi_bios_ptable return value is not being checked in aac_biosparm.

should probably go into 2.6.15 after the usual trivial codingstyle fix..

>  	buf = scsi_bios_ptable(bdev);
> +	if(buf == NULL)
> +		return 0;

	if (!buf)
		return 0;

