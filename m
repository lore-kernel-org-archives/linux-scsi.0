From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] tmscsim: implement change_queue_depth
Date: Tue, 28 Dec 2004 01:29:09 +0100 (CET)
Message-ID: <Pine.LNX.4.60.0412272003340.3560@poirot.grange>
References: <Pine.LNX.4.60.0412221305140.2636@poirot.grange>
 <1103826862.5290.39.camel@mulgrave>  <Pine.LNX.4.60.0412240126400.27610@poirot.grange>
  <1104076166.5268.22.camel@mulgrave>  <Pine.LNX.4.60.0412262034030.3808@poirot.grange>
 <1104172298.7447.10.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:9109 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S262008AbUL1A3r (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Dec 2004 19:29:47 -0500
In-Reply-To: <1104172298.7447.10.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 27 Dec 2004, James Bottomley wrote:

> On Sun, 2004-12-26 at 22:49 +0100, Guennadi Liakhovetski wrote:
> > Ok. Would it make sense / be accepted to change this sitation by either 1) 
> > adding a new function __scsi_adjust_queue_depth() which would pass the 
> > return code of the block-layer, or 2) modifying the existing function to 
> > return an error? 1) has disadvantages, that it's a) confusing, b) even 
> 
> To be honest, unless you can find a driver that cares about this
> failure, I don't think so.

No, I don't know any either. I thought more about a user, doing something 
like
$ echo "4" > /sys/.../queue_depth
$ echo $?
0
$ cat /sys/.../queue_depth
3
and wondering why... But, I feel I am abusing your time already with this 
minor issue, so, if you (and everybody else) think, that this possible 
confusion is unimportant, I'll shut up now:-)

Thanks
Guennadi
---
Guennadi Liakhovetski

