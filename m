From: Jan-Simon =?ISO-8859-1?Q?M=F6ller?= <dl9pf@gmx.de>
Subject: Re: [PATCH] [TRIVIAL] Remove braces in drivers/scsi/in2000.h to fix build for clang. No functional change otherwise.
Date: Wed, 21 Aug 2013 09:26:14 +0200
Message-ID: <2050670.KsM0dPm3or@aragorn.auenland.lan>
References: <1377033546-19475-1-git-send-email-dl9pf@gmx.de> <20130821065018.GB9043@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:64246 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752232Ab3HUH13 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Aug 2013 03:27:29 -0400
Received: from aragorn.auenland.lan ([95.90.185.134]) by mail.gmx.com
 (mrgmx003) with ESMTPSA (Nemesis) id 0LztHH-1W875w3PJD-0151Gn for
 <linux-scsi@vger.kernel.org>; Wed, 21 Aug 2013 09:27:28 +0200
In-Reply-To: <20130821065018.GB9043@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: PaX Team <pageexec@freemail.hu>, Behan Webster <behanw@converseincode.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

> > 
> > Description:
> >   Clang chokes on the notation "insw (%%dx)" but works for "insw %%dx"
> >   (outsw likewise); GNU as accepts both forms.
> > 
> > Signed-off-by: Jan-Simon M??ller <dl9pf@gmx.de>
> 
> I think the right fix is to simply kill the FAST_READ_IO/FAST_WRITE_IO
> defines and their associated inline assembly entirely.

No objection ;) .
