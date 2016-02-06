From: wangyijing <wangyijing@huawei.com>
Subject: Re: Question for Patch"libsas: fix "sysfs group not found" warnings
 at port teardown time"
Date: Sat, 6 Feb 2016 09:20:26 +0800
Message-ID: <56B54A5A.10103@huawei.com>
References: <CAOE4rSyHYcNyzeAK7w6f29sR+QEn+z7AUV3NF4SgBroL101+5Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([119.145.14.52]:11203 "EHLO
	szxga04-in.huawei.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750748AbcBFB0w (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Feb 2016 20:26:52 -0500
In-Reply-To: <CAOE4rSyHYcNyzeAK7w6f29sR+QEn+z7AUV3NF4SgBroL101+5Q@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?UTF-8?B?RMSBdmlzIE1vc8SBbnM=?= <davispuh@gmail.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Yes, it seems to be the same issue.

=E5=9C=A8 2016/2/6 1:22, D=C4=81vis Mos=C4=81ns =E5=86=99=E9=81=93:
> 2016-02-05 11:20 GMT+02:00 wangyijing <wangyijing@huawei.com>:
>>
>> Hi Dan and Praveen,
>>    I found a patch titled "libsas: fix "sysfs group not found" warni=
ngs at
>> port teardown time" by google,
>> https://www.mail-archive.com/linux-scsi@vger.kernel.org/msg39187.htm=
l
>>
>=20
>  Maybe this is related?
>=20
>  kernel: WARNING: CPU: 4 PID: 16820 at fs/sysfs/group.c:237
>  sysfs_remove_group+0x8b/0x90()
>  kernel: sysfs group ffffffff818a3b60 not found for kobject 'end_devi=
ce-7:7'
>  [...]
>  kernel: Workqueue: scsi_wq_7 sas_destruct_devices [libsas]
>=20
>  I'm getting this warning when removing disk from HighPoint RocketRAI=
D 2760
>  controller (mvsas driver)
>  See https://bugzilla.kernel.org/show_bug.cgi?id=3D71021#c3
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
