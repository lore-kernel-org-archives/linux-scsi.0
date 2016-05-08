From: Petros Koutoupis <petros@petroskoutoupis.com>
Subject: Re: [PATCH] megaraid: add scsi_cmnd NULL check before use
Date: Sun, 08 May 2016 11:34:07 -0500
Message-ID: <1462725247.6614.3.camel@petros-ultrathin>
References: <1462668011.32105.7.camel@petros-ultrathin>
	  <alpine.LNX.2.00.1605081235490.19865@nippy.intranet>
	 <1462709320.2840.15.camel@petros-ultrathin>
	 <alpine.LNX.2.00.1605082216090.19865@nippy.intranet>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.perfora.net ([74.208.4.194]:54057 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750841AbcEHQeQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 8 May 2016 12:34:16 -0400
In-Reply-To: <alpine.LNX.2.00.1605082216090.19865@nippy.intranet>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: kashyap.desai@avagotech.com, sumit.saxena@avagotech.com, uday.lingala@avagotech.com, megaraidlinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>

On Sun, 2016-05-08 at 22:22 +1000, Finn Thain wrote:
> On Sun, 8 May 2016, Petros Koutoupis wrote:
> 
> > > 
> > > That contains a tautology.
> > > 
> > 
> > How so?
> 
> if (x)
> 	/* ... */
> else if (!x && (whatever))
> 	/* ... */
> 
> -- 

Thank you but I know the logic of what I wrote. A tautology
will yield the same results no matter what the interpretation.
That is not a tautology. The two conditionals in my case check
different states and serve different purposes.


