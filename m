From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH 4/4] sd: misc checkpatch.pl fixes
Date: Wed, 29 Apr 2009 22:46:12 +0200
Message-ID: <200904292246.12746.bzolnier@gmail.com>
References: <200904292209.33446.bzolnier@gmail.com> <1241036726.3369.63.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f163.google.com ([209.85.218.163]:44888 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759935AbZD2UtW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Apr 2009 16:49:22 -0400
Received: by bwz7 with SMTP id 7so1423964bwz.37
        for <linux-scsi@vger.kernel.org>; Wed, 29 Apr 2009 13:49:18 -0700 (PDT)
In-Reply-To: <1241036726.3369.63.camel@mulgrave.int.hansenpartnership.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org

On Wednesday 29 April 2009 22:25:26 James Bottomley wrote:
> On Wed, 2009-04-29 at 22:09 +0200, Bartlomiej Zolnierkiewicz wrote:
> > Fix
> > 
> > 	ERROR: trailing whitespace
> > 	ERROR: code indent should use tabs where possible
> > 	WARNING: line over 80 characters
> > 	WARNING: braces {} are not necessary for single statement blocks
> > 	ERROR: switch and case should be at the same indent
> > 	ERROR: space required before the open parenthesis '('
> > 
> > issues detected by checkpatch.pl.
> > 
> > While at it:
> > - remove superfluous 'ret' local variable in sd_compat_ioctl()
> 
> I'd really rather not encourage pure whitespace fixing patches in
> SCSI ... we already know there's a lot of non conforming problems from a
> crufty code base ... at one patch per file it would take about 500
> patches and several thousand lines of review.

Well, we could at least fix the core code -- which means a lot less than
500 files...  However I see your point and I have no problem with keeping
the patch locally until it is more useful or you change your mind.

Thanks,
Bart
