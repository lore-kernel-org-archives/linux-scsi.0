From: "Miquel van Smoorenburg" <miquels@cistron.nl>
Subject: Re: PATCH: 64 bit support for dpt_i2o driver
Date: Thu, 24 Apr 2008 17:03:56 +0200
Message-ID: <E1Jp2zM-0005Zh-SP@n2o.xs4all.nl>
References: <xs4all.20080418215937.GA15199@xs4all.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3840 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759607AbYDXPPE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Apr 2008 11:15:04 -0400
In-Reply-To: <xs4all.200804232329.22140.eike-kernel@sf-tec.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: eike-kernel@sf-tec.de
Cc: Linux-Scsi <linux-scsi@vger.kernel.org>

In article <xs4all.200804232329.22140.eike-kernel@sf-tec.de> you write:
>Miquel van Smoorenburg wrote:
>> * 64 bit code based on unofficial Adaptec 64 bit driver
>> * removes scsi_module.c dependency, adds module_init / module_exit
>>   this is needed because we need to pass the proper device to
>>   scsi_add_host(), and the scsi_module.c passes NULL. With NULL,
>>   code like arch/x64/kernel/pci-gart_64.c::need_iommu() crashes
>>   because the dev pointer it is passed is NULL.
>> * adds sysfs entry for /sys/class/dpt_i2o/dptiX so that udev
>>   can create /dev/dptiX dynamically
>
>Is there any chance that you could split this into (at least) 2 patches, one 
>for the 64 bit stuff and one for the driver model stuff? This patch is huge, 
>the review (and the chances for this getting merged) will be higher if it is 
>in small pieces.

The sysfs is stuff is just a few lines, but sure ..

The dpt_i2o driver works fine, but code-wise it isn't in terrific
shape. This patch does make some things cleaner, but it's not
a complete rewrite - on purpose. So when revieuwing the patch,
keep the context in mind. General cleanups, not related to the
64-bit code, can be done later.

Mike.
