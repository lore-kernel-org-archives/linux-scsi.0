From: Rik van Riel <riel@conectiva.com.br>
Subject: Re: [PATCH] aic7xxx bouncing over 4G
Date: Sat, 28 Dec 2002 11:33:02 -0200 (BRST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.50L.0212281131580.26879-100000@imladris.surriel.com>
References: <200212210012.gBL0Cng21338@eng2.beaverton.ibm.com>
 <176730000.1040430221@aslan.btc.adaptec.com> <3E03BB0D.5070605@rackable.com>
 <Pine.LNX.4.50L.0212280331110.30646-100000@freak.distro.conectiva>
 <20021228091608.GA13814@louise.pinerecords.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021228091608.GA13814@louise.pinerecords.com>
List-Id: linux-scsi@vger.kernel.org
To: Tomas Szepe <szepe@pinerecords.com>
Cc: Marcelo Tosatti <marcelo@conectiva.com.br>, Samuel Flory <sflory@rackable.com>, "Justin T. Gibbs" <gibbs@scsiguy.com>, Janet Morgan <janetmor@us.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>

On Sat, 28 Dec 2002, Tomas Szepe wrote:

> Marcelo, you've been overlooking these updates for a bit too long now
> for your "let's throw them at -ac" to sound fair.  IMHO of course.  Also
> remember those are both production drivers tested thoroughly in FreeBSD,

Are we talking about the old or the new aic7xxx driver ?

If it's the new driver, it's breaking on WAY too many
machines and I have no idea why it got ever merged...

I have yet to see a machine where the new aic7xxx driver
works. I'm sure they exist, but it doesn't work on any
of the machines I have access to.

regards,

Rik
-- 
Bravely reimplemented by the knights who say "NIH".
http://www.surriel.com/		http://guru.conectiva.com/
Current spamtrap:  <a href=mailto:"october@surriel.com">october@surriel.com</a>
