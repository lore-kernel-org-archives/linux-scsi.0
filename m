From: Kern Sibbald <kern@sibbald.com>
Subject: Re: Linux tape drivers
Date: Wed, 4 Apr 2007 21:21:08 +0200
Message-ID: <200704042121.09399.kern@sibbald.com>
References: <200704031508.37222.kern@sibbald.com> <200704041626.15298.kern@sibbald.com> <20070404115536.fd752555.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from matou.sibbald.com ([194.158.240.20]:25612 "EHLO
	matou.sibbald.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934064AbXDDTVZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Apr 2007 15:21:25 -0400
In-Reply-To: <20070404115536.fd752555.akpm@linux-foundation.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Willem Riede <wrlk@riede.org>, Kai Makisara <Kai.Makisara@kolumbus.fi>, linux-scsi@vger.kernel.org

On Wednesday 04 April 2007 20:55, Andrew Morton wrote:
> On Wed, 4 Apr 2007 16:26:14 +0200 Kern Sibbald <kern@sibbald.com> wrote:
> 
> >  I'm all in favor of deprecating ide-tape if ide-scsi is a viable 
alternative, 
> 
> ow.  ide-scsi is in very bad shape and nobody is maintaining it or fixing
> bugs in it or anything.  The only reason we retain ide-scsi at all is, err,
> because some tape drives need it.
> 
> If we have no alternative to using ide-scsi, and if the tape controllers in
> question are not some terribly obscure things which nobody would seriously
> use then we have a bit of a problem.  I don't know of anyone who we can
> turn to to get anything done in ide-scsi.
> 
>

That's quite clear, thanks.  I'll update our documentation to say that 
ide-scsi doesn't work with Bacula, is not actively supported and may be 
removed from the kernel.

What non-SCSI drivers do you feel are or should be well supported?
libata as Kai indicates?

Once I am sure, I'll point Bacula users to those drivers.  
