From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: sata & scsi suggestion for make menuconfig
Date: Fri, 14 Sep 2007 17:37:37 +0200
Message-ID: <46EAAAC1.3050409@s5r6.in-berlin.de>
References: <20070907124800.GP16806@vanheusden.com> <p73fy1p9m57.fsf@bingen.suse.de> <1189371621.3526.28.camel@localhost.localdomain> <20070909210329.GE25798@one.firstfloor.org> <46E46190.6080607@garzik.org> <20070912224655.GC3563@stusta.de> <46EAA08F.30703@s5r6.in-berlin.de> <20070914151522.GL3563@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:41136 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164AbXINPis (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Sep 2007 11:38:48 -0400
In-Reply-To: <20070914151522.GL3563@stusta.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@kernel.org>
Cc: Jeff Garzik <jeff@garzik.org>, Andi Kleen <andi@firstfloor.org>, James Bottomley <James.Bottomley@SteelEye.com>, Folkert van Heusden <folkert@vanheusden.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Adrian Bunk wrote:
> On Fri, Sep 14, 2007 at 04:54:07PM +0200, Stefan Richter wrote:
>> The patch which is discussed here is specifically targeted towards users
>> who are convinced that they can migrate to different drivers without
>> reading Kconfig help texts.
> 
> Nothing about the patch is only about migration.
> 
> The same applies if you configure a kernel from scratch.
> 
> Do "make menuconfig" with the .config you are normally using, count the 
> number of options that are visible, and ask yourself whether we can 
> really expect users to read the help texts for every single option shown.
> 
> People mostly read help texts for options where they don't understand 
> what this option is about - and "Serial ATA" therefore is an option that 
> is likely to get enabled without the user looking at the help text.

If you create .config from scratch, then you can get away without
reading help texts if you have a target with minimal hardware and
protocols requirements and you know all the subsystems involved.

In all other cases, you theoretically need to read all help texts (minus
the ones that don't appear because you deselect entire subsystems).  In
practice, this takes too much time, hence you take an existing .config
(yours or somebody else's) and go from there.

Whenever one enables an option for the first time, it would IMO be
foolish to ignore its help text.
-- 
Stefan Richter
-=====-=-=== =--= -===-
http://arcgraph.de/sr/
