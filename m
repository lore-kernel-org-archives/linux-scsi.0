From: Andries.Brouwer@cwi.nl
Subject: Re: [example PATCH - not for applying] exclude certain commands
Date: Thu, 24 Apr 2003 20:59:45 +0200 (MEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <UTC200304241859.h3OIxjh16776.aeb@smtp.cwi.nl>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.cwi.nl ([192.16.191.8]:48043 "EHLO hera.cwi.nl")
	by vger.kernel.org with ESMTP id S263811AbTDXSux (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Apr 2003 14:50:53 -0400
List-Id: linux-scsi@vger.kernel.org
To: Andries.Brouwer@cwi.nl, mdharm-scsi@one-eyed-alien.net
Cc: James.Bottomley@steeleye.com, afafc@rnl.ist.utl.pt, alan@lxorguk.ukuu.org.uk, greg@kroah.com, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, mike@hingston.demon.co.uk, stelian@popies.net, torvalds@transmeta.com

    From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>

    > Well, before we create a new infrastructure it is a good idea
    > to make sure that it is needed. James mentioned three cases
    > in Bugzilla and it looks like these are fixed by a small correction
    > to the MODE_SENSE to MODE_SENSE_10 translation.
    >
    > You mention lots of devices that don't support MODE_SENSE at all.
    > Do you have Bugzilla or l-k / l-s / l-u refs?

    Unfortunately, my data comes from (a) working with this junk for several
    years, and (b) non-public conversations with hardware vendors.

Yes. So what you are saying is that you have no supporting evidence
for the need of a filtering layer.

    Yeah, I know that's a lousy answer.  But try to realize that I've been
    dealing with a long, slow, and painful discovery process of what the
    'popular OS' uses.

Yes, I do not blame you at all. Nevertheless, we must only do
things when we really understand why. If a filter is really
necessary we'll find people with problems that are cured only
that way. Today we do not know any such people, it seems.

Andries
