From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] aic7xxx bouncing over 4G
Date: Sat, 28 Dec 2002 09:50:27 +0000
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20021228095027.A29971@infradead.org>
References: <200212210012.gBL0Cng21338@eng2.beaverton.ibm.com> <176730000.1040430221@aslan.btc.adaptec.com> <3E03BB0D.5070605@rackable.com> <Pine.LNX.4.50L.0212280331110.30646-100000@freak.distro.conectiva>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.50L.0212280331110.30646-100000@freak.distro.conectiva>; from marcelo@conectiva.com.br on Sat, Dec 28, 2002 at 03:32:44AM -0200
To: Marcelo Tosatti <marcelo@conectiva.com.br>
Cc: Samuel Flory <sflory@rackable.com>, "Justin T. Gibbs" <gibbs@scsiguy.com>, Janet Morgan <janetmor@us.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
List-Id: linux-scsi@vger.kernel.org

On Sat, Dec 28, 2002 at 03:32:44AM -0200, Marcelo Tosatti wrote:
> >     I've been using both drivers for some time with no issues.  Or maybe
> > you'd prefer Alan put it in his tree 1st?
> 
> Ho, hum, I prefer getting it tested in -ac for a while first.

Doesn't make much sense for aic79xx which is a new driver (= not changing
existing code at all) and already shipped by the commercial distros for ages..
