From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: [PATCH] mptfusion - fc transport attributes - REVISED
Date: Fri, 13 Jan 2006 14:00:40 -0700
Message-ID: <F331B95B72AFFB4B87467BE1C8E9CF5F1AA6D6@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:5795 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1422956AbWAMVAn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2006 16:00:43 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: "Shirron, Stephen" <Stephen.Shirron@lsil.com>, "Hickerson, Roger" <Roger.Hickerson@lsil.com>, Jeremy Higdon <jeremy@sgi.com>, Gary Hagensen <gwh@sgi.com>

I had steped out for lunch, and just got back.
I'm in the process of patching, testing this.

Thankyou,
Eric

> -----Original Message-----
> From: Michael Reed [mailto:mdr@sgi.com] 
> Sent: Friday, January 13, 2006 1:32 PM
> To: linux-scsi
> Cc: Christoph Hellwig; Moore, Eric; Shirron, Stephen; 
> Hickerson, Roger; Jeremy Higdon; Gary Hagensen; James 
> Bottomley; James.Smart@Emulex.Com
> Subject: Re: [PATCH] mptfusion - fc transport attributes - REVISED
> 
> OK.  I've re-based the code to work with scsi-misc and Christoph's
> recent patches.  I've tested it on my ia64 test mule and it appears to
> function as did the previous patch.
> 
> Perhaps the target will now stand still for a while?  :)
> 
> Attached is version 1f of the patch.  Previous versions should
> be disregarded.
> 
> Mike
> 
> Signed-off-by: Michael Reed <mdr@sgi.com>
> 
