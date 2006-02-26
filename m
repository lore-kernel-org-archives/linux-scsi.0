From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] silence gcc warning about possibly uninitialized use
	of variable in scsi_scan
Date: Sun, 26 Feb 2006 12:59:37 -0600
Message-ID: <1140980377.3692.9.camel@mulgrave.il.steeleye.com>
References: <200602261639.15657.jesper.juhl@gmail.com>
	 <1140978084.3692.6.camel@mulgrave.il.steeleye.com>
	 <9a8748490602261023j46eb39f2peaa080d737fee5e1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:7917 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751314AbWBZS7j (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 26 Feb 2006 13:59:39 -0500
In-Reply-To: <9a8748490602261023j46eb39f2peaa080d737fee5e1@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: linux-kernel@vger.kernel.org, Eric Youngdale <ericy@cais.com>, Eric Youngdale <eric@andante.org>, linux-scsi@vger.kernel.org

On Sun, 2006-02-26 at 19:23 +0100, Jesper Juhl wrote:
> > gcc version 4.0.3 20051201 (prerelease) (Debian 4.0.2-5)
> >
> > Doesn't give this warning.  And, since the loop has fixed parameters,
> > gcc should see not only that it's always executed, but that it could be
> > unrolled.
> >
> > Which version is causing the problem?
> >
> 2.6.16-rc4-mm2 build with gcc 3.4.5

I also tried with

gcc version 3.3.5 (Debian 1:3.3.5-13)

which likewise fails to give this warning, so I really think this is a
bug in your particular version of gcc.

James


> and I agree that gcc really should be noticing, but in fact it
> doesn't. It's no big deal, I just thought we might want to shut gcc up
> and give people one less warning to worry about.
> 
> --
> Jesper Juhl <jesper.juhl@gmail.com>
> Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
> Plain text mails only, please      http://www.expita.com/nomime.html
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

