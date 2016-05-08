From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH] megaraid: add scsi_cmnd NULL check before use
Date: Sun, 8 May 2016 22:22:25 +1000 (AEST)
Message-ID: <alpine.LNX.2.00.1605082216090.19865@nippy.intranet>
References: <1462668011.32105.7.camel@petros-ultrathin>  <alpine.LNX.2.00.1605081235490.19865@nippy.intranet> <1462709320.2840.15.camel@petros-ultrathin>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:34927 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbcEHMXT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 8 May 2016 08:23:19 -0400
In-Reply-To: <1462709320.2840.15.camel@petros-ultrathin>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Petros Koutoupis <petros@petroskoutoupis.com>
Cc: kashyap.desai@avagotech.com, sumit.saxena@avagotech.com, uday.lingala@avagotech.com, megaraidlinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>


On Sun, 8 May 2016, Petros Koutoupis wrote:

> > 
> > That contains a tautology.
> > 
> 
> How so?

if (x)
	/* ... */
else if (!x && (whatever))
	/* ... */

-- 
