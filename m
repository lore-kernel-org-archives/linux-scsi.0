From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: sata & scsi suggestion for make menuconfig
Date: Sun, 09 Sep 2007 17:39:11 -0400
Message-ID: <1189373951.3526.37.camel@localhost.localdomain>
References: <20070907124800.GP16806@vanheusden.com>
	 <p73fy1p9m57.fsf@bingen.suse.de>
	 <1189371621.3526.28.camel@localhost.localdomain>
	 <20070909210329.GE25798@one.firstfloor.org> <46E46190.6080607@garzik.org>
	 <20070909212159.GF25798@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1759689AbXIIVjZ@vger.kernel.org>
In-Reply-To: <20070909212159.GF25798@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: Jeff Garzik <jeff@garzik.org>, Folkert van Heusden <folkert@vanheusden.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, 2007-09-09 at 23:22 +0200, Andi Kleen wrote:
> > The current setup expresses the dependencies as they exist -- OPTIONAL 
> > extras, and that is a problem once a year or so, when someone builds 
> 
> Disk support over SCSI/SATA is hardly an "optional extra". It's more the 99+%
> case.

Using that argument, there's an equal case for always requiring SCSI to
be built for every kernel, since very few people can boot a system
without a disk.  However, the 1% case is the embedded flash booting
community plus a few others, so we allow SCSI to be optional for our 1%
who don't want it.

At base, the Kconfig system is designed to give the greatest flexibility
with the fewest foot shooting opportunities.  However, we do tend to err
on the side of flexibility if there's a conflict between the two design
goals.

> > their own kernel but must learn this fact anew.
> 
> When it costs 10000 people half an hour to learn and correct this it 
> wasted 5000 hours of previous livetime.
>
> Besides there is no good reason to have ever learned this imho.

The process of becoming an expert in the kernel build system naturally
involves making mistakes and learning from them, so this is probably
time reasonably well spent.

James
