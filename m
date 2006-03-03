From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: [PATCH] make some sas class properties optional
Date: Fri, 3 Mar 2006 09:26:41 -0700
Message-ID: <F331B95B72AFFB4B87467BE1C8E9CF5F3277EC@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:2192 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S932185AbWCCQ0u convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Mar 2006 11:26:50 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Friday, March 03, 2006 4:42 AM, Christoph Hellwig wrote: 

> On Thu, Mar 02, 2006 at 04:01:31PM -0600, James Bottomley wrote:
> > aic94xx doesn't have a use for the bay or enclosure identifiers.
> > Also, I think it's not going to need a get_linkerrors(), so wire up
> > all of these exported properties as conditional on the underlying
> > function support.
> 
> Making these optional is okay.
> 
> the expander identifier is part of the SMP REPORT_GENERAL 
> reply, so aic94xx
> should be able to support it easily.  Similarly I'm pretty 
> sure it supports
> link error statistics aswell.
> 

Optional, humm.... ??

These are defined here:

Enclosure Logical ID is SAS 1.1 spec, as SMP REPORT_GENERAL (opcode =
0x40, fuction = 0x0)
The slot/bay indentifier should be in SES-II spec.
Link Statistics is in SAS 1.1 spec, as SMP REPORT_PHY_ERROR_LOG (opcode
= 0x40, fuction = 0x11)
Link Reset and Hard Reset is in SAS 1.1 spec, as in SMP PHY_CONTROL
(opcode = 0x40, function = 0x91)

Eric Moore
