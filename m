From: Chris Pearson <chris-linux-scsi@twock.com>
Subject: Re: /dev/megadev0 missing with 2.6.26 kernel megaraid_mm
Date: Sun, 17 May 2009 20:27:16 +0100
Message-ID: <20090517192716.GB9759@lamity.org>
References: <20090517172833.GA9759@lamity.org> <1242587981.11755.11.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lamity.org ([212.13.197.69]:45527 "HELO lamity.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754764AbZEQT1U (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 17 May 2009 15:27:20 -0400
Content-Disposition: inline
In-Reply-To: <1242587981.11755.11.camel@mulgrave.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org

On Sun, May 17, 2009 at 02:19:41PM -0500, James Bottomley wrote:
> >From 2.6.25 onwards, megaraid_mm (the new megaraid driver) doesn't
> define its own block device like 2.4 did, but instead uses the misc
> devices.  So, if you cat /proc/misc and megadev0 doesn't show up, it's a
> kernel problem.  If it does, it's a debian udev problem.

Ahh, I see.  It does indeed show up there so I'll raise it in a more
appropriate place.  Thanks for the help.

Cheers,
Chris
