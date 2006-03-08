From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: [RFC] first cut at infrastructure for handlingdifferentdevicetypes in the sas class
Date: Wed, 8 Mar 2006 11:49:49 -0700
Message-ID: <F331B95B72AFFB4B87467BE1C8E9CF5F34C2DC@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:18861 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S932337AbWCHSts convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Mar 2006 13:49:48 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Tuesday, March 07, 2006 8:59 AM, James Bottomley wrote: 

> > As long as these changes are not breaking the driver....
> 

Your changes did break the driver, :(  
I just sent separate email containing the oops.


> Discovery is the process of enumerating connected devices.  The
> transport layer will have to issue SMPs to do it, since 
> that's the only
> defined way.  However, I don't envisage making discovery 
> mandatory; it's
> going to be in the adjunct class or library, so mptsas can 
> just make the
> topology appear based on the SMP discovery done by the firmware.

Good to hear that; e.g. that its not going to be mandatory.

> 
> Christoph's working on the needs of mptsas, but it looks like most of
> the necessary information can be obtained from the firmware pages
> (except really the stuff we get from SMP_REPORT_MANUFACTURER_INFO,
> which, I think, even mptsas can stand).
> 

We can probably still consider having SMP passthru portal for
such info.  However it use should be limited.

