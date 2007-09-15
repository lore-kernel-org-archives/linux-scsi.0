From: david@lang.hm
Subject: Re: sata & scsi suggestion for make menuconfig
Date: Sat, 15 Sep 2007 11:23:16 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0709151122000.24221@asgard.lang.hm>
References: <20070907124800.GP16806@vanheusden.com> <p73fy1p9m57.fsf@bingen.suse.de>
 <1189371621.3526.28.camel@localhost.localdomain> <20070909210329.GE25798@one.firstfloor.org>
 <46E46190.6080607@garzik.org> <20070912224655.GC3563@stusta.de>
 <46EAA08F.30703@s5r6.in-berlin.de> <20070914151522.GL3563@stusta.de>
 <20070915080448.37457dcf@tux.DEF.witbe.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:46097
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755648AbXIOSYT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 15 Sep 2007 14:24:19 -0400
In-Reply-To: <20070915080448.37457dcf@tux.DEF.witbe.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paul Rolland <rol@as2917.net>
Cc: Adrian Bunk <bunk@kernel.org>, Stefan Richter <stefanr@s5r6.in-berlin.de>, Jeff Garzik <jeff@garzik.org>, Andi Kleen <andi@firstfloor.org>, James Bottomley <James.Bottomley@SteelEye.com>, Folkert van Heusden <folkert@vanheusden.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rol@witbe.net

On Sat, 15 Sep 2007, Paul Rolland wrote:

> On Fri, 14 Sep 2007 17:15:22 +0200
> Adrian Bunk <bunk@kernel.org> wrote:
>
>> On Fri, Sep 14, 2007 at 04:54:07PM +0200, Stefan Richter wrote:
>>> Adrian Bunk wrote:
>>>> On Sun, Sep 09, 2007 at 05:11:44PM -0400, Jeff Garzik wrote:
>>>>> Let's step back a moment and consider the actual scale and impact of
>>>>> the problem at hand.
>> Do "make menuconfig" with the .config you are normally using, count the
>> number of options that are visible, and ask yourself whether we can
>> really expect users to read the help texts for every single option shown.
>>
>> People mostly read help texts for options where they don't understand
>> what this option is about - and "Serial ATA" therefore is an option that
>> is likely to get enabled without the user looking at the help text.
>>
>
> As a "make menuconfig" user, let me say that I agree. Of course, I'm used
> to rebuild kernel, but sometimes, some options are not clear, and the help
> text is searched for. But, getting too much of "No help text available"
> usually results in people no more reading the help text.
>
> What about splitting the screen to have the top half with the menu, and the
> bottom half with the help ?

I useually have more screen space available to the side then above and 
below the list of options.

David Lang
