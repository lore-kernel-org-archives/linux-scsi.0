From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Emulex] Ready for next round...
Date: Wed, 16 Jun 2004 09:20:17 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040616082017.GB8683@infradead.org>
References: <3356669BBE90C448AD4645C843E2BF28034F94D5@xbl.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.146.154.40] ([213.146.154.40]:14230 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S266215AbUFPIUS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Jun 2004 04:20:18 -0400
Content-Disposition: inline
In-Reply-To: <3356669BBE90C448AD4645C843E2BF28034F94D5@xbl.ma.emulex.com>
List-Id: linux-scsi@vger.kernel.org
To: "Smart, James" <James.Smart@Emulex.Com>
Cc: Linux SCSI Reflector <linux-scsi@vger.kernel.org>

On Tue, Jun 15, 2004 at 01:32:56PM -0400, Smart, James wrote:
> Comments:
> --------------
> [From 5/9] Re: lpfc_msg* stuff is not acceptable.
> We've inlined the print strings and filter values. Should be acceptable now.

Still quite horrible.  Please use dev_printk ala qlogic:

#define qla_printk(level, ha, format, arg...) \
        dev_printk(level , &((ha)->pdev->dev) , format , ## arg)


