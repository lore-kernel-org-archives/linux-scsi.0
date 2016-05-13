From: Petros Koutoupis <petros@petroskoutoupis.com>
Subject: Re: [PATCH] megaraid: add scsi_cmnd NULL check before use
Date: Fri, 13 May 2016 18:34:14 -0500
Message-ID: <1463182454.4343.3.camel@petros-ultrathin>
References: <1462668011.32105.7.camel@petros-ultrathin>
	 <alpine.LNX.2.00.1605081235490.19865@nippy.intranet>
	 <20160509080551.GH29510@mwanda>
	 <3aced88f2434c8dd0a8aa4fd902445a9@mail.gmail.com>
	 <1462829338.1873.4.camel@petroskoutoupis.com>
	 <166e07c6f96724c0d1f972f2a65d0a65@mail.gmail.com>
	 <1463017791.5827.4.camel@petros-ultrathin> <20160512062948.GG19274@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.perfora.net ([74.208.4.196]:57633 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752892AbcEMXeX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 May 2016 19:34:23 -0400
In-Reply-To: <20160512062948.GG19274@mwanda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Sumit Saxena <sumit.saxena@broadcom.com>, Finn Thain <fthain@telegraphics.com.au>, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com, uday.lingala@avagotech.com, megaraidlinux.pdl@avagotech.com, linux-scsi@vger.kernel.org

On Thu, 2016-05-12 at 09:35 +0300, Dan Carpenter wrote:
> On Wed, May 11, 2016 at 08:49:51PM -0500, Petros Koutoupis wrote:
> > Sumit,
> > 
> > I will resubmit the patch with all the recommendations. Thank you. In case
> > you are interested, I have a crash file showcasing the error. I can always
> > provide this outside of this mailing thread.
> > 
> 
> Please send it to the thread.
> 
> To be honest, I totally can't understand this thread.  Sumit says it is
> impossible and you are saying that you have seen it happen in real life.
> Are you using out of tree code or something?  What are you doing that is
> unexpected?
> 
> I don't see the point of adding a WARN_ON().  NULL derefs normally
> generate a pretty clear stack trace already (unless they are caused by
> memory corruption).  Why are we not just fixing the bugs instead of
> warning and then crashing.
> 
> Also when I'm doing static analysis people always tell me that "that bug
> is impossible, trust me." and instead of trusting people I really wish
> they would just show me the relevant code that prevents it from
> happening.
> 
> regards,
> dan carpenter
> 
All,

You will find the tarball containing the crash and kernel images here:
https://drive.google.com/open?id=0B771xrWtHcpWWFI3Yl93WFBfT28

Note that it is a 7GB file.

--
Petros

