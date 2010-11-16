From: Richard Williams <richard@etechsoft.com>
Subject: Re: [Scst-devel] [PATCH 8/19]: SCST SYSFS interface implementation
Date: Tue, 16 Nov 2010 06:59:33 -0500
Message-ID: <8985DEAF-4227-4629-B90A-938D2BA3534E@etechsoft.com>
References: <20101109002829.GA22633@kroah.com> <4CD9A9B8.70708@vlnb.net>
 <4CDA6CD4.3010308@panasas.com> <4CDAFE6E.7050200@vlnb.net>
 <4CDBBE80.40908@panasas.com> <4CDC56F9.9040601@vlnb.net>
 <20101112012315.GE17097@core.coreip.homeip.net> <4CDEC8D2.8080101@vlnb.net>
 <20101113235938.GA1827@kroah.com> <4CE1017E.4090409@panasas.com>
 <20101115161620.GB5981@kroah.com> <4CE16B8E.1000300@panasas.com>
 <AANLkTikPVXGJ5-5YDk1uqfqrqxGLpSiSdaX3h7qxo-ie@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:55806 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933883Ab0KPMAJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Nov 2010 07:00:09 -0500
In-Reply-To: <AANLkTikPVXGJ5-5YDk1uqfqrqxGLpSiSdaX3h7qxo-ie@mail.gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Boaz Harrosh <bharrosh@panasas.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Vladislav Bolkhovitin <vst@vlnb.net>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Greg KH <greg@kroah.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, scst-devel <scst-devel@lists.sourceforge.net>, Hannes Reinecke <hare@suse.de>, Andy Yan <ayan@marvell.com>, Andrew Morton <akpm@linux-foundation.org>, Vu Pham <vuhuong@mellanox.com>

I'm just an outsider - but maybe my perspective has value - it seems there are two sides to this debate:

1) sysfs is great for scst due to certain stability concerns and code concerns
2) sysfs is bad for scst due to the intended role of sysfs and its namespace

Maybe I misunderstand -
But if both sides have merit then wouldn't a compromise be appropriate?

Maybe the sensical compromise is to use sysfs code to create a new namespace that would fit this purpose?  It seems that I am also hearing that the alternatives to sysfs aren't always adequate - so why not use sysfs, but have a place where it's appropriate to use it?  

Apologies in advance if I'm just way off base here... 

- Richard Williams