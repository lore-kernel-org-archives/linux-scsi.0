From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] add extra inquiry byte 56 data to struct scsi_device
Date: Sat, 21 Aug 2004 00:57:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040821045719.GA31752@havoc.gtf.org>
References: <1093053368.3318.569.camel@mulgrave> <4126BFCC.2000702@pobox.com> <20040820213857.4014b981.rddunlap@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([216.162.42.101]:43431 "EHLO havoc.gtf.org")
	by vger.kernel.org with ESMTP id S268846AbUHUE6O (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 Aug 2004 00:58:14 -0400
Content-Disposition: inline
In-Reply-To: <20040820213857.4014b981.rddunlap@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rddunlap@osdl.org>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

On Fri, Aug 20, 2004 at 09:38:57PM -0700, Randy.Dunlap wrote:
> On Fri, 20 Aug 2004 23:21:48 -0400 Jeff Garzik wrote:
> 
> | James Bottomley wrote:
> | > +	if (sdev->inquiry_len > 56) {
> | > +		if (inq_result[56] & 0x04)
> | > +			sdev->ppr = 1;
> | > +		if ((inq_result[56] & 0x0c) == 0x04)
> | > +			sdev->dt_only = 1;
> | > +		if (inq_result[56] & 0x01)
> | > +			sdev->ius = 1;
> | > +		if (inq_result[56] & 0x02)
> | > +			sdev->qas = 1;
> | > +	}
> | 
> | 
> | Do you forsee ever adding more feature bits like this?
> | 
> | It seems to me that a more maintainable approach is to cache relevant 
> | INQUIRY data in a buffer, and then create accessor macros for 
> | programmers' use.
> | 
> | That way you don't have to keep adding members (really, mnemonics) to a 
> 
> Mnemonics would be names, not numbers.

Nod.  I was referring to the names being added to the struct.

	Jeff



