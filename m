From: "David S. Miller" <davem@redhat.com>
Subject: Re: Aic7xxx 6.2.28 and Aic79xx 1.3.0 Released
Date: 23 Jan 2003 19:55:46 -0800
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <1043380546.16483.6.camel@rth.ninka.net>
References: <87730000.1043275833@aslan.btc.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <87730000.1043275833@aslan.btc.adaptec.com>
To: "Justin T. Gibbs" <gibbs@btc.adaptec.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@transmeta.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Marcelo Tosatti <marcelo@conectiva.com.br>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2003-01-22 at 14:50, Justin T. Gibbs wrote:
> GNU patch relative to 2.5.59:
>  http://people.FreeBSD.org/~gibbs/linux/SRC/aic79xx-linux-2.5.59-20030122-gnupatch.gz

Justin, I haven't checked, but have you deleted my change
again to include asm/io.h in aix7xxx_osm.h?

You keep doing this, I wish you'd stop :-)

More seriously, you really need to look at the build etc.
fixes people put into your driver in 2.5.x, it is rude to
keep deleting such changes over and over again.
