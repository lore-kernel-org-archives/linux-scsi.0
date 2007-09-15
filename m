From: Paul Rolland <rol@as2917.net>
Subject: Re: sata & scsi suggestion for make menuconfig
Date: Sat, 15 Sep 2007 08:04:48 +0000
Message-ID: <20070915080448.37457dcf@tux.DEF.witbe.net>
References: <20070907124800.GP16806@vanheusden.com>
	<p73fy1p9m57.fsf@bingen.suse.de>
	<1189371621.3526.28.camel@localhost.localdomain>
	<20070909210329.GE25798@one.firstfloor.org>
	<46E46190.6080607@garzik.org>
	<20070912224655.GC3563@stusta.de>
	<46EAA08F.30703@s5r6.in-berlin.de>
	<20070914151522.GL3563@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754677AbXIOIGP@vger.kernel.org>
In-Reply-To: <20070914151522.GL3563@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Adrian Bunk <bunk@kernel.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Jeff Garzik <jeff@garzik.org>, Andi Kleen <andi@firstfloor.org>, James Bottomley <James.Bottomley@SteelEye.com>, Folkert van Heusden <folkert@vanheusden.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rol@witbe.net
List-Id: linux-scsi@vger.kernel.org

Hello,

On Fri, 14 Sep 2007 17:15:22 +0200
Adrian Bunk <bunk@kernel.org> wrote:

> On Fri, Sep 14, 2007 at 04:54:07PM +0200, Stefan Richter wrote:
> > Adrian Bunk wrote:
> > > On Sun, Sep 09, 2007 at 05:11:44PM -0400, Jeff Garzik wrote:
> > >> Let's step back a moment and consider the actual scale and impact of
> > >> the problem at hand.
> Do "make menuconfig" with the .config you are normally using, count the 
> number of options that are visible, and ask yourself whether we can 
> really expect users to read the help texts for every single option shown.
> 
> People mostly read help texts for options where they don't understand 
> what this option is about - and "Serial ATA" therefore is an option that 
> is likely to get enabled without the user looking at the help text.
> 

As a "make menuconfig" user, let me say that I agree. Of course, I'm used
to rebuild kernel, but sometimes, some options are not clear, and the help
text is searched for. But, getting too much of "No help text available"
usually results in people no more reading the help text.

What about splitting the screen to have the top half with the menu, and the
bottom half with the help ?

Paul


-- 
Paul Rolland                                E-Mail : rol(at)witbe.net
Witbe.net SA                                Tel. +33 (0)1 47 67 77 77
Les Collines de l'Arche                     Fax. +33 (0)1 47 67 77 99
F-92057 Paris La Defense                    RIPE : PR12-RIPE

Please no HTML, I'm not a browser - Pas d'HTML, je ne suis pas un navigateur 
"Some people dream of success... while others wake up and work hard at it" 

"I worry about my child and the Internet all the time, even though she's too 
young to have logged on yet. Here's what I worry about. I worry that 10 or 15 
years from now, she will come to me and say 'Daddy, where were you when they 
took freedom of the press away from the Internet?'"
--Mike Godwin, Electronic Frontier Foundation 
