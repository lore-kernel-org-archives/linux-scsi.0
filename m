From: Mark Knecht <markknecht@gmail.com>
Subject: Re: Slow I/O performance on SAS1064
Date: Thu, 6 Mar 2014 12:51:27 -0800
Message-ID: <CAK2H+eesWkK_w66e5BLcA_Ft0FHNTuNYmxF_LceMHVupX8T_xg@mail.gmail.com>
References: <20140305175036.GA23885@localhost.localdomain>
	<CAK2H+ecJKp+QLJsbGW2tquO5_DuQReJD8nKViHea9tTiJwfn-g@mail.gmail.com>
	<20140305214013.GA6287@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:58916 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824AbaCFUv2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Mar 2014 15:51:28 -0500
In-Reply-To: <20140305214013.GA6287@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: markus <markus@kola.li>
Cc: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, support@lsi.com, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org, Linux Kernel List <linux-kernel@vger.kernel.org>

On Wed, Mar 5, 2014 at 1:40 PM, markus <markus@kola.li> wrote:
> On Wed, Mar 05, 2014 at 10:21:07AM -0800, Mark Knecht wrote:
>> On Wed, Mar 5, 2014 at 9:50 AM, Markus <markus@kola.li> wrote:
>> <SNIP>
>>
>> > The hdparm result looks like there is somethink not right . There were no features supported but why ?
>>
>>
>> Does the HDD have S.M.A.R.T. features? Possibly
>>
>> smartctl -a /dev/sda
> root@outpost:~# smartctl -a /dev/sda
> smartctl 5.41 2011-06-09 r3365 [sparc64-linux-3.13.5-mar] (local build)
> Copyright (C) 2002-11 by Bruce Allen, http://smartmontools.sourceforge.net
>
>
> Probable ATA device behind a SAT layer
> Try an additional '-d ata' or '-d sat' argument.
>
> so i try it with scsi.
>
> root@outpost:~# smartctl -d scsi -a /dev/sda
> smartctl 5.41 2011-06-09 r3365 [sparc64-linux-3.13.5-mar] (local build)
> Copyright (C) 2002-11 by Bruce Allen, http://smartmontools.sourceforge.net
>
> User Capacity:        2,000,398,934,016 bytes [2.00 TB]
> Logical block size:   512 bytes
> Logical Unit id:      0x50000394e2380537
> Serial number:                   7365P4KNT
> Device type:          disk
> Local Time is:        Wed Mar  5 22:32:09 2014 CET
> Device supports SMART and is Disabled
> Temperature Warning Disabled or Not Supported
> SMART Health Status: OK
>
> Error Counter logging not supported
> Device does not support Self Test logging

I am not familiar with this message:

"Device supports SMART and is Disabled"

but there are lots of posts out there with folks asking about it.
Possibly you can figure out what's causing smart not to turn on, get
it turned on and get some info.

Sorry I cannot help more.

Good luck,
Mark
