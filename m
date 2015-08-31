From: =?iso-2022-jp?B?GyRCSy04NjVIOSgbKEIgLyBUT1lPSEFSQRskQiEkGyhCWU9TSElISVJP?=
	<yoshihiro.toyohara.qs@hitachi.com>
Subject: [PATCH] hfcldd: Add Hitachi FC driver.
Date: Mon, 31 Aug 2015 14:25:25 +0000
Message-ID: <4E270F2FD2FF914680A5846BB512683C82F285@GSjpTK1DCembx01.service.hitachi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail9.hitachi.co.jp ([133.145.228.44]:37369 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054AbbHaOZ3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Aug 2015 10:25:29 -0400
Received: from mlsv6.hitachi.co.jp (unknown [133.144.234.166])
	by mail9.hitachi.co.jp (Postfix) with ESMTP id F29E5109BD82
	for <linux-scsi@vger.kernel.org>; Mon, 31 Aug 2015 23:25:27 +0900 (JST)
Received: from vshuts02.hitachi.co.jp (vshuts02.hitachi.co.jp [10.201.6.84])
	by mfilter06.hitachi.co.jp (Switch-3.3.4/Switch-3.3.4) with ESMTP id t7VEPQrP027515
	for <linux-scsi@vger.kernel.org>; Mon, 31 Aug 2015 23:25:27 +0900
Received: from GSjpTK1DCehcs03.service.hitachi.net (unknown [158.213.41.12])
	by vshuts02.hitachi.co.jp (Postfix) with ESMTP id 65EC3490052
	for <linux-scsi@vger.kernel.org>; Mon, 31 Aug 2015 23:25:26 +0900 (JST)
Content-Language: ja-JP
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>
Cc: =?iso-2022-jp?B?GyRCSy04NjVIOSgbKEIgLyBUT1lPSEFSQRskQiEkGyhCWU9TSElISVJP?= <yoshihiro.toyohara.qs@hitachi.com>, =?iso-2022-jp?B?GyRCOzNFRE1bMnAbKEIgLyBZQU1BREEbJEIhJBsoQllPVVNVS0U=?= <yosuke.yamada.no@hitachi.com>, =?iso-2022-jp?B?GyRCMGY+bEUwGyhCIC8gSUJBGyRCISQbKEJUT09SVQ==?= <toru.iba.uj@hitachi.com>, =?iso-2022-jp?B?GyRCO3syMEJzO0obKEIgLyBURVJBWUEbJEIhJBsoQlRBS1VKSQ==?= <takuji.teraya.dg@hitachi.com>, =?iso-2022-jp?B?GyRCOF5MQD4tOSwbKEIgLyBHT01ZTxskQiEkGyhCTUFTQVlVS0k=?= <masayuki.gomyo.pf@hitachi.com>, =?iso-2022-jp?B?GyRCMTo+ZTk4GyhCIC8gVVJBS0FNSRskQiEkGyhCQUtJUkE=?= <akira.urakami.pk@hitachi.com>, =?iso-2022-jp?B?GyRCPj5LXE5HGyhCIC8gTUFUU1VNT1RPGyRCISQbKEJSWU8=?= <ryo.matsumoto.ch@hitachi.com>, =?iso-2022-jp?B?GyRCTlM+OzksGyhCIC8gSEFZQVNISRskQiEkGyhCTUFTQVlVS0k=?= <masayuki.hayashi.zh@hitachi.com>, =?iso-2022-jp?B?GyRCMCQ4fUA/O0obKEIgLyBBR1VDSEkbJEIhJBso

I am an engineer in Hitachi. ,
We committed the following files newly
and mailed the patch by one mail.

But the mail has about 4,600,000 characters,
and is blocked beyond 100,000 character of the mail permission.
There are also source file beyond 20,000 lines. 

Could you advise how to do and send patch?

Yoshihiro Toyohara
Hitachi Ltd.

----------------------------------------------------------------------------------------------
hfcldd is a driver of Hitachi FC Adapter and committed newly.

Signed-off-by: Yoshihiro Toyohara <yoshihiro.toyohara.qs@hitachi.com>
---
drivers/scsi/hfcldd/Makefile                   |    15 +
drivers/scsi/hfcldd/hfcddwwn.h                 |   134 +
drivers/scsi/hfcldd/hfcl_conf.c                |   198 +
drivers/scsi/hfcldd/hfcl_detect.c              | 20642 +++++++++++++++++++++++
drivers/scsi/hfcldd/hfcl_detect.h              |   267 +
drivers/scsi/hfcldd/hfcl_detect_fx.c           | 11269 +++++++++++++
drivers/scsi/hfcldd/hfcl_detect_fx.h           |   172 +
drivers/scsi/hfcldd/hfcl_diag.c                |  4296 +++++
drivers/scsi/hfcldd/hfcl_diag_fx.c             |  6062 +++++++
drivers/scsi/hfcldd/hfcl_hand_timer_trace.h    |   301 +
drivers/scsi/hfcldd/hfcl_hand_timer_trace_fx.h |  1657 ++
drivers/scsi/hfcldd/hfcl_handler.c             |  3680 ++++
drivers/scsi/hfcldd/hfcl_handler.h             |    66 +
drivers/scsi/hfcldd/hfcl_handler_fx.c          |  9809 +++++++++++
drivers/scsi/hfcldd/hfcl_handler_fx.h          |   135 +
drivers/scsi/hfcldd/hfcl_handler_trace.h       |   164 +
drivers/scsi/hfcldd/hfcl_ioctl.c               |  5501 ++++++
drivers/scsi/hfcldd/hfcl_ioctl.h               |   188 +
drivers/scsi/hfcldd/hfcl_ioctl_fx.c            |  3640 ++++
drivers/scsi/hfcldd/hfcl_ioctl_fx.h            |   167 +
drivers/scsi/hfcldd/hfcl_mlpf.c                |  3234 ++++
drivers/scsi/hfcldd/hfcl_mlpf.h                |   309 +
drivers/scsi/hfcldd/hfcl_mlpf_fx.c             |  3493 ++++
drivers/scsi/hfcldd/hfcl_mlpf_fx.h             |   345 +
drivers/scsi/hfcldd/hfcl_moduleparam.h         |  2590 +++
drivers/scsi/hfcldd/hfcl_modulever.h           |    17 +
drivers/scsi/hfcldd/hfcl_npiv_fx.c             |  1015 ++
drivers/scsi/hfcldd/hfcl_npiv_fx.h             |    53 +
drivers/scsi/hfcldd/hfcl_stra_trace.h          |   256 +
drivers/scsi/hfcldd/hfcl_stra_trace_fx.h       |   200 +
drivers/scsi/hfcldd/hfcl_strategy.c            |  5830 +++++++
drivers/scsi/hfcldd/hfcl_strategy.h            |   141 +
drivers/scsi/hfcldd/hfcl_strategy_fx.c         |  5650 +++++++
drivers/scsi/hfcldd/hfcl_strategy_fx.h         |   211 +
drivers/scsi/hfcldd/hfcl_tbol.h                |   191 +
drivers/scsi/hfcldd/hfcl_timer_recovery.c      |  7431 ++++++++
drivers/scsi/hfcldd/hfcl_timer_recovery.h      |   103 +
drivers/scsi/hfcldd/hfcl_timer_recovery_fx.c   |  7606 +++++++++
drivers/scsi/hfcldd/hfcl_timer_recovery_fx.h   |   133 +
drivers/scsi/hfcldd/hfcl_top.c                 |  4304 +++++
drivers/scsi/hfcldd/hfcl_top.h                 |   261 +
drivers/scsi/hfcldd/hfcl_top_fx.c              |  8807 ++++++++++
drivers/scsi/hfcldd/hfcl_top_fx.h              |   753 +
drivers/scsi/hfcldd/hfcl_version.c             |   165 +
drivers/scsi/hfcldd/hfcl_version.h             |    19 +
drivers/scsi/hfcldd/hfcldd.h                   |  2516 +++
drivers/scsi/hfcldd/hfcldd_conf.c              |   243 +
drivers/scsi/hfcldd/hfcldd_conf.h              |    20 +
drivers/scsi/hfcldd/hfcldd_fx.h                |  2167 +++
drivers/scsi/hfcldd/hfclddcom.h                |  1644 ++
drivers/scsi/hfcldd/hfclddcom_fx.h             |  1546 ++
drivers/scsi/hfcldd/hfclddioc.h                |  2030 +++
drivers/scsi/hfcldd/hfclddutil.h               |    48 +
drivers/scsi/hfcldd/hfcmpcfg.h                 |    78 +
drivers/scsi/hfcldd/hraslog.h                  |    52 +
drivers/scsi/hfcldd/hraslog_link.c             |    83 +
56 files changed, 131907 insertions(+)


