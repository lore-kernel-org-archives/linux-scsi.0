From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 8/19]: SCST SYSFS interface implementation
Date: Sun, 14 Nov 2010 22:59:20 -0800
Message-ID: <20101115065919.GB14442@core.coreip.homeip.net>
References: <4CD8566D.1020202@vlnb.net>
 <20101109002829.GA22633@kroah.com>
 <4CD9A9B8.70708@vlnb.net>
 <4CDA6CD4.3010308@panasas.com>
 <4CDAFE6E.7050200@vlnb.net>
 <4CDBBE80.40908@panasas.com>
 <4CDC56F9.9040601@vlnb.net>
 <20101112012315.GE17097@core.coreip.homeip.net>
 <4CDEC8D2.8080101@vlnb.net>
 <20101113235938.GA1827@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57421 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757203Ab0KOG7a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Nov 2010 01:59:30 -0500
Content-Disposition: inline
In-Reply-To: <20101113235938.GA1827@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Vu Pham <vuhuong@mellanox.com>, Bart Van Assche <bart.vanassche@gmail.com>, James Smart <James.Smart@Emulex.Com>, Joe Eykholt <jeykholt@cisco.com>, Andy Yan <ayan@marvell.com>, Chetan Loke <generationgnu@yahoo.com>, Hannes Reinecke <hare@suse.de>, Richard Sharpe <realrichardsharpe@gmail.com>, Daniel Henrique Debonzi <debonzi@linux.vnet.ibm.com>

On Sat, Nov 13, 2010 at 03:59:38PM -0800, Greg KH wrote:
> On Sat, Nov 13, 2010 at 08:20:18PM +0300, Vladislav Bolkhovitin wrote:
> > So, I decided to reimplement it to be completely synchronous. SYSFS
> > authors did really great job and thanks to the excellent internal SYSFS
> > design and implementation it is absolutely safe. See:
> > 
> > [root@tgt ~]# modprobe scst
> > [root@tgt ~]# cd /sys/kernel/scst_tgt/
> 
> Sorry, but no, you can't put this in /sys/kernel/ without getting the
> approval of the sysfs maintainer.
> 
> I really don't understand why you are using kobjects in the first place,
> why isn't this in the main device tree in the kernel, using 'struct
> device'?
> 

It is my understanding that Vlad is able to reflect the topology by
manipulating sysfs objects there.

> In the end, I guess it really doesn't matter as this code isn't getting
> merged so I shouldn't worry about it, right?
> 

This is quite unfortunate as I still have not seen the public comparison
of the 2 implementations and the lists of benefits and shortfalls for
both of them.

-- 
Dmitry
