From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: sata & scsi suggestion for make menuconfig
Date: Fri, 14 Sep 2007 18:50:03 +0200
Message-ID: <46EABBBB.7060201@s5r6.in-berlin.de>
References: <20070907124800.GP16806@vanheusden.com> <p73fy1p9m57.fsf@bingen.suse.de> <1189371621.3526.28.camel@localhost.localdomain> <20070909210329.GE25798@one.firstfloor.org> <46E46190.6080607@garzik.org> <20070912224655.GC3563@stusta.de> <46EAA08F.30703@s5r6.in-berlin.de> <20070914151522.GL3563@stusta.de> <46EAAAC1.3050409@s5r6.in-berlin.de> <20070914161619.GM3563@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:43526 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbXINQu7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Sep 2007 12:50:59 -0400
In-Reply-To: <20070914161619.GM3563@stusta.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@kernel.org>
Cc: Jeff Garzik <jeff@garzik.org>, Andi Kleen <andi@firstfloor.org>, James Bottomley <James.Bottomley@SteelEye.com>, Folkert van Heusden <folkert@vanheusden.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Adrian Bunk wrote:
> On Fri, Sep 14, 2007 at 05:37:37PM +0200, Stefan Richter wrote:
>> In
>> practice, this takes too much time, hence you take an existing .config
>> (yours or somebody else's) and go from there.
> 
> Kconfig let's you start with the defconfig when doing "make menuconfig" 
> without any .config present,
[...]

This is one of those "somebody else's .config".

>> Whenever one enables an option for the first time, it would IMO be
>> foolish to ignore its help text.
> 
> Then the number of non-foolish users is quite near to 0...

Perhaps.  Although I meant only options which one enables oneself, not
options which are taken over from somebody else's .config.

> If you expect people to read several hundreds or thousands of help texts 
> only for configuring a kernel then you are expecting something that is 
> simply not realistic.
> 
> It is intuitive for a user to enable the "Serial ATA" menu and he might 
> not expect to have to read the help text when he has SATA drivers, while 
> having to enable anything in the "SCSI device support" menu is highly 
> unintuitively when the user does not have SCSI hardware.

It surely is unintuitive, and it is one of the worse cases where the
current menu layout is unintuitive.  We have to improve that, even
though it is ultimately impossible to serve everyone's needs equally
well or, generally, make kernel configuration a piece of cake.

Note though, some suggestions which came up here don't actually make the
menus more intuitive.  Notably the patch "Select BLK_DEV_SD for all
SCSI/libata drivers" is counterintuitive in a different color:  It
follows the philosophy of "I know what's good for you and I act on your
behalf behind your back --- trust me, it's for your best".

I too am guilty of proposing the usage of 'select'
(http://lkml.org/lkml/2007/9/8/9) but I suggested a variant which lets
the user stay informed and in control (as far as this is possible with
'select' which always increases complexity, never reduces it).

But rather than adding multiple menu items which enable the same option,
a reorganization of the menus which better reflect the role of SCSI core
and SCSI highlevel might be more effective --- similar to "Networking"
which is separate from "Network device support"
(http://lkml.org/lkml/2007/9/10/5, http://lkml.org/lkml/2007/9/10/115).
-- 
Stefan Richter
-=====-=-=== =--= -===-
http://arcgraph.de/sr/
