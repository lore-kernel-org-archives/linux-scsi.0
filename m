From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 4/4] sd: misc checkpatch.pl fixes
Date: Wed, 29 Apr 2009 15:25:26 -0500
Message-ID: <1241036726.3369.63.camel@mulgrave.int.hansenpartnership.com>
References: <200904292209.33446.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:60997 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753077AbZD2UZ2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Apr 2009 16:25:28 -0400
In-Reply-To: <200904292209.33446.bzolnier@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-scsi@vger.kernel.org

On Wed, 2009-04-29 at 22:09 +0200, Bartlomiej Zolnierkiewicz wrote:
> Fix
> 
> 	ERROR: trailing whitespace
> 	ERROR: code indent should use tabs where possible
> 	WARNING: line over 80 characters
> 	WARNING: braces {} are not necessary for single statement blocks
> 	ERROR: switch and case should be at the same indent
> 	ERROR: space required before the open parenthesis '('
> 
> issues detected by checkpatch.pl.
> 
> While at it:
> - remove superfluous 'ret' local variable in sd_compat_ioctl()

I'd really rather not encourage pure whitespace fixing patches in
SCSI ... we already know there's a lot of non conforming problems from a
crufty code base ... at one patch per file it would take about 500
patches and several thousand lines of review.

James


