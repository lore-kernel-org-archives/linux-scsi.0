From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [PATCH] make some sas class properties optional
Date: Fri, 03 Mar 2006 10:38:01 -0600
Message-ID: <1141403881.5397.1.camel@mulgrave.il.steeleye.com>
References: <F331B95B72AFFB4B87467BE1C8E9CF5F3277EC@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:9428 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932288AbWCCQiH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Mar 2006 11:38:07 -0500
In-Reply-To: <F331B95B72AFFB4B87467BE1C8E9CF5F3277EC@NAMAIL2.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Fri, 2006-03-03 at 09:26 -0700, Moore, Eric wrote:
> Optional, humm.... ??

Optional as in the *driver* need not provide the callback.

> These are defined here:
> 
> Enclosure Logical ID is SAS 1.1 spec, as SMP REPORT_GENERAL (opcode =
> 0x40, fuction = 0x0)
> The slot/bay indentifier should be in SES-II spec.
> Link Statistics is in SAS 1.1 spec, as SMP REPORT_PHY_ERROR_LOG (opcode
> = 0x40, fuction = 0x11)
> Link Reset and Hard Reset is in SAS 1.1 spec, as in SMP PHY_CONTROL
> (opcode = 0x40, function = 0x91)

As you can see, for a driver that provides an SMP tap, like aic94xx then
these parameters can be got by the transport class sending the SMP
queries ... the driver doesn't need to know about it.

James


