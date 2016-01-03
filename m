From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH v4 69/78] ncr5380: Fix whitespace in comments using
 regexp
Date: Sun, 03 Jan 2016 13:46:22 -0800
Message-ID: <1451857582.4334.61.camel@perches.com>
References: <20160103050501.042035135@telegraphics.com.au>
	 <20160103050520.752909053@telegraphics.com.au>
	 <1451807668.4334.38.camel@perches.com>
	 <20160103141051.2d46c245@lxorguk.ukuu.org.uk>
	 <1451845248.4334.41.camel@perches.com>
	 <20160103212938.2df359ad@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtprelay0250.hostedemail.com ([216.40.44.250]:58765 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751385AbcACVqZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Jan 2016 16:46:25 -0500
In-Reply-To: <20160103212938.2df359ad@lxorguk.ukuu.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Finn Thain <fthain@telegraphics.com.au>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>

(using an email address for James that shouldn't bounce)

On Sun, 2016-01-03 at 21:29 +0000, One Thousand Gnomes wrote:
> > > I would beg to differ. As a tool for understanding the
> > > differences as you
> > > step through the versions it's invaluable.
> > 
> > This removes intentional formatting that
> > makes reading comments easier.
> 
> And this matters at the end of the patch series because ?

It removes intentional formatting that makes
reading comments easier.

And diff -w still works just fine.
