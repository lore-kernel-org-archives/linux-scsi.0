From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] hwmon: Driver for SCSI/ATA temperature sensors
Date: Mon, 14 Sep 2009 17:00:20 +0200
Message-ID: <20090914150020.GA23500@atrey.karlin.mff.cuni.cz>
References: <20090913040104.ab1d0b69.const@mimas.ru> <1252850453.23599.13.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59792 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754362AbZINPAS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Sep 2009 11:00:18 -0400
Content-Disposition: inline
In-Reply-To: <1252850453.23599.13.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Constantin Baranov <const@mimas.ru>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Hi!

> Finally, this:
> 
> > +               if (attr[2] == 194) {
> > +                       *temp = attr[7] * 1000;
> > +                       err = 0;
> > +                       break;
> 
> Smart attribute 194 is highly vendor specific ... for instance my new
> SATA drive doesn't implement it (it does implement 190 instead).
> 
> So really, given the complexity of just obtaining the data and the
> problem of matching which data to obtain to which device you have, why
> not just use smartctl from userspace for monitoring?  you could even
> just plug into smartd, it seems to have most of the necessary heuristics
> built in already.


Well, having unified kernel<->user interface for temperature sensors
makes sense.

I'm not sure if benefits outweight costs here (I tend to think they
do), but...
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
