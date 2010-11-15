From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 8/19]: SCST SYSFS interface implementation
Date: Mon, 15 Nov 2010 19:19:10 +0200
Message-ID: <4CE16B8E.1000300@panasas.com>
References: <20101109002829.GA22633@kroah.com> <4CD9A9B8.70708@vlnb.net> <4CDA6CD4.3010308@panasas.com> <4CDAFE6E.7050200@vlnb.net> <4CDBBE80.40908@panasas.com> <4CDC56F9.9040601@vlnb.net> <20101112012315.GE17097@core.coreip.homeip.net> <4CDEC8D2.8080101@vlnb.net> <20101113235938.GA1827@kroah.com> <4CE1017E.4090409@panasas.com> <20101115161620.GB5981@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:59275 "EHLO
	daytona.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932839Ab0KORTQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Nov 2010 12:19:16 -0500
In-Reply-To: <20101115161620.GB5981@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Vu Pham <vuhuong@mellanox.com>, Bart Van Assche <bart.vanassche@gmail.com>, James Smart <James.Smart@Emulex.Com>, Joe Eykholt <jeykholt@cisco.com>, Andy Yan <ayan@marvell.com>, Chetan Loke <generationgnu@yahoo.com>, Hannes Reinecke <hare@suse.de>, Richard Sharpe <realrichardsharpe@gmail.com>, Daniel Henrique Debonzi <debonzi@linux.vnet.ibm.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

On 11/15/2010 06:16 PM, Greg KH wrote:
> On Mon, Nov 15, 2010 at 11:46:38AM +0200, Boaz Harrosh wrote:
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
> 
> thanks,
> 
> greg k-h

Thank you Greg for your time and most valuable input.
I'm sorry for not understanding your position. I needed the
clear cut statement:

	This code should not be using kobjects. i.e not belong in sysfs

SCST guys. This sounds pretty clear cut to me. Sysfs was not built
in mind for such dynamic systems, and it will cause never ending
conflicts with future maintenance of sysfs vs SCST.

Perhaps consider a new alternative like the device tree as Greg suggested
or maybe finally accept the harsh realities of ConfigFS, and come join us
in the LIO project. SCST is a most valuable project and community which
we would like to join forces with in making Linux the best.

Lets call it Linux-Target and unify all our efforts.

Boaz
