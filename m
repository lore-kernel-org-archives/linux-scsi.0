From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] make scsi_wait_scan always modular
Date: Sun, 11 Mar 2007 22:17:17 +0100 (CET)
Message-ID: <Pine.LNX.4.60.0703112210510.5942@poirot.grange>
References: <1173640604.3420.21.camel@mulgrave.il.steeleye.com>
 <Pine.LNX.4.60.0703112141580.5942@poirot.grange>
 <1173647177.3420.24.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:57281 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932501AbXCKVRP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 11 Mar 2007 17:17:15 -0400
In-Reply-To: <1173647177.3420.24.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Sun, 11 Mar 2007, James Bottomley wrote:

> On Sun, 2007-03-11 at 21:56 +0100, Guennadi Liakhovetski wrote:
> > Which means, with this change you cannot build a kernel without module 
> > support but with scsi_wait_scan, which was possible before. Don't know if 
> > anybody would ever want to do this though...
> 
> I'll do something about that if you can tell me how one might use
> scsi_wait_scan without module support in the kernel ...

I won't:-) Just from the comment at the top of the patch I didn't get the 
impression that this indeed was its intended result. Building statically 
with scsi_wait_scan would mean that you might allow async scan, but then 
some time at late_initcall() time you want a sync point. Could this ever 
be desired? If not, just ignore my comment.

Thanks
Guennadi
---
Guennadi Liakhovetski
