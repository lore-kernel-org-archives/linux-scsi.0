From: Rik van Riel <riel@conectiva.com.br>
Subject: Re: [PATCH] aic7xxx bouncing over 4G
Date: Sat, 28 Dec 2002 17:19:23 -0200 (BRST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.50L.0212281718110.26879-100000@imladris.surriel.com>
References: <200212210012.gBL0Cng21338@eng2.beaverton.ibm.com>
 <176730000.1040430221@aslan.btc.adaptec.com> <3E03BB0D.5070605@rackable.com>
 <Pine.LNX.4.50L.0212280331110.30646-100000@freak.distro.conectiva>
 <20021228091608.GA13814@louise.pinerecords.com>
 <Pine.LNX.4.50L.0212281131580.26879-100000@imladris.surriel.com>
 <705128112.1041102818@aslan.scsiguy.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <705128112.1041102818@aslan.scsiguy.com>
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: Tomas Szepe <szepe@pinerecords.com>, Marcelo Tosatti <marcelo@conectiva.com.br>, Samuel Flory <sflory@rackable.com>, Janet Morgan <janetmor@us.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>

On Sat, 28 Dec 2002, Justin T. Gibbs wrote:

> Unfortunately, the versions of the aic7xxx driver that are in the main
> trees (both nearly a year out of date) don't have this test and, like the
> "old" driver, they default to memory mapped I/O.  One of the reasons I've
> been pushing so hard for this new driver to go into the tree is that 90%
> of the complaints about the new driver would go away if it were updated
> to a sane revision.

Ohhhh, that would certainly explain.  Where could I get a patch
to update a recent 2.4 kernel to your latest aic7xxx driver ?

I'll happily test it on the machines where I have access...

regards,

Rik
-- 
Bravely reimplemented by the knights who say "NIH".
http://www.surriel.com/		http://guru.conectiva.com/
Current spamtrap:  <a href=mailto:"october@surriel.com">october@surriel.com</a>
