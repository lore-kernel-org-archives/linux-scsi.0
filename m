From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [PATCH 8/19]: SCST SYSFS interface implementation
Date: Tue, 16 Nov 2010 16:19:03 +0300
Message-ID: <4CE284C7.4040209@vlnb.net>
References: <4CDA6CD4.3010308@panasas.com> <4CDAFE6E.7050200@vlnb.net> <4CDBBE80.40908@panasas.com> <4CDC56F9.9040601@vlnb.net> <20101112012315.GE17097@core.coreip.homeip.net> <4CDEC8D2.8080101@vlnb.net> <20101113235938.GA1827@kroah.com> <AANLkTi=PxYi8kCsAxbopUHBC+=2QPuoEcojdqugS88sH@mail.gmail.com> <20101115184422.GA9566@kroah.com> <4CE19A94.8080504@vlnb.net> <20101115221359.GA9530@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101115221359.GA9530@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Bart Van Assche <bvanassche@acm.org>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>, James Bottomley <James.Bottomley@hansenpartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Vu Pham <vuhuong@mellanox.com>, James Smart <James.Smart@emulex.com>, Joe Eykholt <jeykholt@cisco.com>, Andy Yan <ayan@marvell.com>, Chetan Loke <generationgnu@yahoo.com>, Hannes Reinecke <hare@suse.de>, Richard Sharpe <realrichardsharpe@gmail.com>, Daniel Henrique Debonzi <debonzi@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Greg KH, on 11/16/2010 01:13 AM wrote:
>>> Please use 'struct device', it is what you want to do here.
>>
>> But we don't have any device to show up in the global device tree!
> 
> Not true at all.

Why?

Greg, sorry, you keep writing as if we all are idiots, but keep refusing
to explain us, idiots, why we can't do what we did. It isn't very
constructive, is it?

>> We don't have any devices in the struct device's understanding at all!
> 
> Then create them just like you are doing so for your kobject use.
> 
> The first device would be the root one, and then everything trickles
> down from there.

Sorry, I can't understand what you mean. What would be the purpose of
this configuration and what benefits it would bring?

Anyway, let's forget about SCSI. Do you believe that struct device
should be created for all IP addresses on which an NFS server listen and
for all exports it exports?

> And use configfs for your configuration stuff, that's what it is there
> for, and if it doesn't somehow work properly for you, please work with
> the configfs developers to fix that up.

I explained why it isn't a too good option in another e-mail.

Thanks,
Vlad
