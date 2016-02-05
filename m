From: =?UTF-8?B?RMSBdmlzIE1vc8SBbnM=?= <davispuh@gmail.com>
Subject: Re: Question for Patch"libsas: fix "sysfs group not found" warnings
 at port teardown time"
Date: Fri, 5 Feb 2016 19:22:44 +0200
Message-ID: <CAOE4rSyHYcNyzeAK7w6f29sR+QEn+z7AUV3NF4SgBroL101+5Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:34435 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753067AbcBERWo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Feb 2016 12:22:44 -0500
Received: by mail-ig0-f171.google.com with SMTP id ik10so45229316igb.1
        for <linux-scsi@vger.kernel.org>; Fri, 05 Feb 2016 09:22:44 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

2016-02-05 11:20 GMT+02:00 wangyijing <wangyijing@huawei.com>:
>
> Hi Dan and Praveen,
>    I found a patch titled "libsas: fix "sysfs group not found" warnings at
> port teardown time" by google,
> https://www.mail-archive.com/linux-scsi@vger.kernel.org/msg39187.html
>

 Maybe this is related?

 kernel: WARNING: CPU: 4 PID: 16820 at fs/sysfs/group.c:237
 sysfs_remove_group+0x8b/0x90()
 kernel: sysfs group ffffffff818a3b60 not found for kobject 'end_device-7:7'
 [...]
 kernel: Workqueue: scsi_wq_7 sas_destruct_devices [libsas]

 I'm getting this warning when removing disk from HighPoint RocketRAID 2760
 controller (mvsas driver)
 See https://bugzilla.kernel.org/show_bug.cgi?id=71021#c3
