From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 8/19]: SCST SYSFS interface implementation
Date: Mon, 15 Nov 2010 08:16:20 -0800
Message-ID: <20101115161620.GB5981@kroah.com>
References: <20101109002829.GA22633@kroah.com>
 <4CD9A9B8.70708@vlnb.net>
 <4CDA6CD4.3010308@panasas.com>
 <4CDAFE6E.7050200@vlnb.net>
 <4CDBBE80.40908@panasas.com>
 <4CDC56F9.9040601@vlnb.net>
 <20101112012315.GE17097@core.coreip.homeip.net>
 <4CDEC8D2.8080101@vlnb.net>
 <20101113235938.GA1827@kroah.com>
 <4CE1017E.4090409@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:49027 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757621Ab0KOQkU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Nov 2010 11:40:20 -0500
Content-Disposition: inline
In-Reply-To: <4CE1017E.4090409@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Vu Pham <vuhuong@mellanox.com>, Bart Van Assche <bart.vanassche@gmail.com>, James Smart <James.Smart@Emulex.Com>, Joe Eykholt <jeykholt@cisco.com>, Andy Yan <ayan@marvell.com>, Chetan Loke <generationgnu@yahoo.com>, Hannes Reinecke <hare@suse.de>, Richard Sharpe <realrichardsharpe@gmail.com>, Daniel Henrique Debonzi <debonzi@linux.vnet.ibm.com>

On Mon, Nov 15, 2010 at 11:46:38AM +0200, Boaz Harrosh wrote:
> On 11/14/2010 01:59 AM, Greg KH wrote:
> > In the end, I guess it really doesn't matter as this code isn't getting
> > merged so I shouldn't worry about it, right?
> > 
> 
> This is not nice and is uncharacteristic of you.

Why, I'm not allowed to get frustrated at repeated attempts to get the
original poster to change their code to something that is acceptable and
just give up and walk away?

Why not?

> This project, even though out-of-tree, is an old and mature project that
> has many users. These are all *Linux* users. The authors and community
> have come to us for help, and advice on making this code acceptable for
> mainline and hardening the code the way, only one project on the planet
> can do, the Linux community. I think it is our courtesy and obligation
> to the Linux users of this Project to comment where they are doing wrong
> and where they should do better.

It is also the job of the kernel community to say "No, what you are
doing is wrong, please don't do that."

And that's what I'm doing here.

> It is not of their choice to be out-of-tree. It is ours. The least we can
> do. Is give then some assistance if we can, and have 5 minutes of our time.

I have given _way_ more than 5 minutes of my time already.

> All these issues we were discussing are interesting and are real Kernel
> problems. For instance the last comment you made was that for such a dynamic
> system and life time problems, and functionality. A better and expected
> solution might be the device tree and not sysfs.

Yes, that is what I have been saying for a while now.

Again:
	This code is using kobjects incorrectly.
	This code should not be using kobjects.

this is my last response to this thread now, and I'm sure you can
understand why.

thanks,

greg k-h
