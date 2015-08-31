From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] hfcldd: Add Hitachi FC driver.
Date: Mon, 31 Aug 2015 17:06:13 +0200
Message-ID: <mqdmvx7qyze.fsf@c203.arch.suse.de>
References: <4E270F2FD2FF914680A5846BB512683C82F285@GSjpTK1DCembx01.service.hitachi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59498 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751982AbbHaPGO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Aug 2015 11:06:14 -0400
In-Reply-To: <4E270F2FD2FF914680A5846BB512683C82F285@GSjpTK1DCembx01.service.hitachi.net>
	(=?utf-8?B?IuixiuWOn+WQieWujw==?= / =?utf-8?Q?TOYOHARA=EF=BC=8CYOSHIHIRO?=
 =?utf-8?Q?=22's?= message of "Mon, 31 Aug 2015
	14:25:25 +0000")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?utf-8?B?6LGK5Y6f5ZCJ5a6PIC8gVE9ZT0hBUkHvvIxZT1NISUhJUk8=?= <yoshihiro.toyohara.qs@hitachi.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, =?utf-8?B?5bGx55Sw6Zm95LuLIC8gWUFNQURB77yMWU9VU1VLRQ==?= <yosuke.yamada.no@hitachi.com>, =?utf-8?B?5LqV5aC05b65IC8gSUJB77yMVE9P?= =?utf-8?B?UlU=?= <toru.iba.uj@hitachi.com>, =?utf-8?B?5a+65bGL5ouT5Y+4?= =?utf-8?B?IC8gVEVSQVlB77yMVEFLVUpJ?= <takuji.teraya.dg@hitachi.com>, =?utf-8?B?5LqU5piO5bCG5bm4IC8gR09NWU/vvIxNQVNBWVVLSQ==?= <masayuki.gomyo.pf@hitachi.com>, =?utf-8?B?5rWm5LiK5pmDIC8gVVJBS0FNSQ==?= =?utf-8?B?77yMQUtJUkE=?= <akira.urakami.pk@hitachi.com>, =?utf-8?B?5p2+?= =?utf-8?B?5pys56icIC8gTUFUU1VNT1RP77yMUllP?= <ryo.matsumoto.ch@hitachi.com>, =?utf-8?B?5p6X5piM5bm4IC8gSEFZQVNISQ==?= =?utf-8?B?77yMTUFTQVlVS0k=?= <masayuki.hayashi.zh@hitachi.com>, =?utf-8?B?6Zi/5Y+j6Kqg5Y+4IC8gQUdVQ0hJ77yMU0VJSkk=?= <seiji.aguchi.tr@hitachi.com>, =?utf-8?B?5a6J5LqV6ZqG5a6PIC8gWUFTVUk=?=

"=E8=B1=8A=E5=8E=9F=E5=90=89=E5=AE=8F / TOYOHARA=EF=BC=8CYOSHIHIRO" <yo=
shihiro.toyohara.qs@hitachi.com>
writes:

> I am an engineer in Hitachi. ,
> We committed the following files newly
> and mailed the patch by one mail.

Maybe you could split it up into a logical patch series. All in all
131907 LOC in one patch are quite some work to review as well.

>
> But the mail has about 4,600,000 characters,
> and is blocked beyond 100,000 character of the mail permission.
> There are also source file beyond 20,000 lines.=20
>
> Could you advise how to do and send patch?
>
> Yoshihiro Toyohara
> Hitachi Ltd.
>
> ---------------------------------------------------------------------=
-------------------------
> hfcldd is a driver of Hitachi FC Adapter and committed newly.
>
> Signed-off-by: Yoshihiro Toyohara <yoshihiro.toyohara.qs@hitachi.com>
> ---
> drivers/scsi/hfcldd/Makefile                   |    15 +
> drivers/scsi/hfcldd/hfcddwwn.h                 |   134 +
> drivers/scsi/hfcldd/hfcl_conf.c                |   198 +
> drivers/scsi/hfcldd/hfcl_detect.c              | 20642 ++++++++++++++=
+++++++++
> drivers/scsi/hfcldd/hfcl_detect.h              |   267 +
> drivers/scsi/hfcldd/hfcl_detect_fx.c           | 11269 +++++++++++++
> drivers/scsi/hfcldd/hfcl_detect_fx.h           |   172 +
> drivers/scsi/hfcldd/hfcl_diag.c                |  4296 +++++
> drivers/scsi/hfcldd/hfcl_diag_fx.c             |  6062 +++++++
> drivers/scsi/hfcldd/hfcl_hand_timer_trace.h    |   301 +
> drivers/scsi/hfcldd/hfcl_hand_timer_trace_fx.h |  1657 ++
> drivers/scsi/hfcldd/hfcl_handler.c             |  3680 ++++
> drivers/scsi/hfcldd/hfcl_handler.h             |    66 +
> drivers/scsi/hfcldd/hfcl_handler_fx.c          |  9809 +++++++++++
> drivers/scsi/hfcldd/hfcl_handler_fx.h          |   135 +
> drivers/scsi/hfcldd/hfcl_handler_trace.h       |   164 +
> drivers/scsi/hfcldd/hfcl_ioctl.c               |  5501 ++++++
> drivers/scsi/hfcldd/hfcl_ioctl.h               |   188 +
> drivers/scsi/hfcldd/hfcl_ioctl_fx.c            |  3640 ++++
> drivers/scsi/hfcldd/hfcl_ioctl_fx.h            |   167 +
> drivers/scsi/hfcldd/hfcl_mlpf.c                |  3234 ++++
> drivers/scsi/hfcldd/hfcl_mlpf.h                |   309 +
> drivers/scsi/hfcldd/hfcl_mlpf_fx.c             |  3493 ++++
> drivers/scsi/hfcldd/hfcl_mlpf_fx.h             |   345 +
> drivers/scsi/hfcldd/hfcl_moduleparam.h         |  2590 +++
> drivers/scsi/hfcldd/hfcl_modulever.h           |    17 +
> drivers/scsi/hfcldd/hfcl_npiv_fx.c             |  1015 ++
> drivers/scsi/hfcldd/hfcl_npiv_fx.h             |    53 +
> drivers/scsi/hfcldd/hfcl_stra_trace.h          |   256 +
> drivers/scsi/hfcldd/hfcl_stra_trace_fx.h       |   200 +
> drivers/scsi/hfcldd/hfcl_strategy.c            |  5830 +++++++
> drivers/scsi/hfcldd/hfcl_strategy.h            |   141 +
> drivers/scsi/hfcldd/hfcl_strategy_fx.c         |  5650 +++++++
> drivers/scsi/hfcldd/hfcl_strategy_fx.h         |   211 +
> drivers/scsi/hfcldd/hfcl_tbol.h                |   191 +
> drivers/scsi/hfcldd/hfcl_timer_recovery.c      |  7431 ++++++++
> drivers/scsi/hfcldd/hfcl_timer_recovery.h      |   103 +
> drivers/scsi/hfcldd/hfcl_timer_recovery_fx.c   |  7606 +++++++++
> drivers/scsi/hfcldd/hfcl_timer_recovery_fx.h   |   133 +
> drivers/scsi/hfcldd/hfcl_top.c                 |  4304 +++++
> drivers/scsi/hfcldd/hfcl_top.h                 |   261 +
> drivers/scsi/hfcldd/hfcl_top_fx.c              |  8807 ++++++++++
> drivers/scsi/hfcldd/hfcl_top_fx.h              |   753 +
> drivers/scsi/hfcldd/hfcl_version.c             |   165 +
> drivers/scsi/hfcldd/hfcl_version.h             |    19 +
> drivers/scsi/hfcldd/hfcldd.h                   |  2516 +++
> drivers/scsi/hfcldd/hfcldd_conf.c              |   243 +
> drivers/scsi/hfcldd/hfcldd_conf.h              |    20 +
> drivers/scsi/hfcldd/hfcldd_fx.h                |  2167 +++
> drivers/scsi/hfcldd/hfclddcom.h                |  1644 ++
> drivers/scsi/hfcldd/hfclddcom_fx.h             |  1546 ++
> drivers/scsi/hfcldd/hfclddioc.h                |  2030 +++
> drivers/scsi/hfcldd/hfclddutil.h               |    48 +
> drivers/scsi/hfcldd/hfcmpcfg.h                 |    78 +
> drivers/scsi/hfcldd/hraslog.h                  |    52 +
> drivers/scsi/hfcldd/hraslog_link.c             |    83 +
> 56 files changed, 131907 insertions(+)
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--=20
Johannes Thumshirn                                           Storage
jthumshirn@suse.de                                 +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=C3=BCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600  D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
