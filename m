From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [PATCH 8/19]: SCST SYSFS interface implementation
Date: Mon, 15 Nov 2010 23:39:17 +0300
Message-ID: <4CE19A75.7040600@vlnb.net>
References: <20101109002829.GA22633@kroah.com> <4CD9A9B8.70708@vlnb.net> <4CDA6CD4.3010308@panasas.com> <4CDAFE6E.7050200@vlnb.net> <4CDBBE80.40908@panasas.com> <4CDC56F9.9040601@vlnb.net> <20101112012315.GE17097@core.coreip.homeip.net> <4CDEC8D2.8080101@vlnb.net> <20101113235938.GA1827@kroah.com> <4CE1017E.4090409@panasas.com> <20101115161620.GB5981@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:62523 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758226Ab0KOUkA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Nov 2010 15:40:00 -0500
In-Reply-To: <20101115161620.GB5981@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Vu Pham <vuhuong@mellanox.com>, Bart Van Assche <bart.vanassche@gmail.com>, James Smart <James.Smart@Emulex.Com>, Joe Eykholt <jeykholt@cisco.com>, Andy Yan <ayan@marvell.com>, Chetan Loke <generationgnu@yahoo.com>, Hannes Reinecke <hare@suse.de>, Richard Sharpe <realrichardsharpe@gmail.com>, Daniel Henrique Debonzi <debonzi@linux.vnet.ibm.com>

Greg KH, on 11/15/2010 07:16 PM wrote:
> Why, I'm not allowed to get frustrated at repeated attempts to get the
> original poster to change their code to something that is acceptable and
> just give up and walk away?
> 
> Why not?

Hmm, frankly, I decided that you agreed with my arguments..

As I wrote, I'm willing to make any changes you requests. I only asked
why this should be done.

I really don't understand why we and other similar in-kernel developers
should treat kobjects in the different way than any other subobjects of
our outer objects and make for them _additional code_ to specially treat
them as life-time center (http://lkml.org/lkml/2010/11/10/421)? You have
not explained it anywhere in any doc I can find.

This is just small "why" question. Greg, don't we have a right to ask
this before go on?

>> This project, even though out-of-tree, is an old and mature project that
>> has many users. These are all *Linux* users. The authors and community
>> have come to us for help, and advice on making this code acceptable for
>> mainline and hardening the code the way, only one project on the planet
>> can do, the Linux community. I think it is our courtesy and obligation
>> to the Linux users of this Project to comment where they are doing wrong
>> and where they should do better.
> 
> It is also the job of the kernel community to say "No, what you are
> doing is wrong, please don't do that."
> 
> And that's what I'm doing here.
> 
>> It is not of their choice to be out-of-tree. It is ours. The least we can
>> do. Is give then some assistance if we can, and have 5 minutes of our time.
> 
> I have given _way_ more than 5 minutes of my time already.

We appreciated it very much.

>> All these issues we were discussing are interesting and are real Kernel
>> problems. For instance the last comment you made was that for such a dynamic
>> system and life time problems, and functionality. A better and expected
>> solution might be the device tree and not sysfs.
> 
> Yes, that is what I have been saying for a while now.
> 
> Again:
> 	This code is using kobjects incorrectly.
> 	This code should not be using kobjects.
> 
> this is my last response to this thread now, and I'm sure you can
> understand why.

It is REALLY frustrating you are refusing to explain why. I guess, I'm
too stupid to figure out that alone. Don't you want we rise as highly
skilled kernel developers? I believe, not only SCST developers are very
interested to know background behind particular moves in the kernel.

Thanks,
Vlad
