From: Matthew Jacob <mjacob@feral.com>
Subject: Re: Why not CAM?
Date: Sun, 27 Oct 2002 08:05:32 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.BSF.4.21.0210270801380.15449-100000@beppo>
References: <87smyrgaxt.fsf@zoo.weinigel.se>
Reply-To: mjacob@feral.com
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <87smyrgaxt.fsf@zoo.weinigel.se>
List-Id: linux-scsi@vger.kernel.org
To: Christer Weinigel <wingel@acolyte.hack.org>
Cc: linux-scsi@vger.kernel.org


> Hi,
> 
> I've wanted to ask this for a long time: Why not switch to SCSI CAM
> when you are redoing the Linux SCSI layer anyways? 
> 
> This is not intended to start a flamewar of any kind, I don't know
> very much about CAM except that it is some kind of standard and
> FreeBSD uses it and they seem to be mostly happy with it.  So I'm just
> curious if any of the SCSI hackers think that CAM would be worthwhile
> and if not, why?  Too heavyweight?  Too ugly?  Won't fit well with the
> new BIO design in the 2.5 kernel?

CAM (Common Access Method) is an ANSI standard. I fought against it
bitterly back in the last '80s, but in retrospect, it's a fine if
slightly somewhat overcomplicated model.

There are two extant widespread implementations: FreeBSD and Tru64
(formerly known as Digital Unix).

It has a lot to recommend it, but its success of failure in Linux would
probably be due to whomever has the time (and/or employer's backing) to
do a fairly complete implementation and present it for review.

Like a lot of standards, the devil is in the details.

-matt


