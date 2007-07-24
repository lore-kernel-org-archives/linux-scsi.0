From: "Prakash, Sathya" <sathya.prakash@lsi.com>
Subject: [PATCH 0/5] mpt fusion: Add logging support
Date: Tue, 24 Jul 2007 15:36:59 +0530
Message-ID: <20070724100659.GA1831@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:42610 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761087AbXGXKJ0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jul 2007 06:09:26 -0400
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.11/8.12.11) with ESMTP id l6OA86dc000194
	for <linux-scsi@vger.kernel.org>; Tue, 24 Jul 2007 03:08:06 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: eric.moore@lsi.com

The patches in this patch set adds support for logging facility that can be used
to debug a number of Fusion MPT related problems.

The logging support can be enabled or disabled changing the kernel
configuration flag CONFIF_FUSION_LOGGING

The debug level can be programmed on the fly via SysFS (hex values)
	echo [level] > /sys/class/scsi_host/host#/debug_level
and also can be passed as module parameter mpt_debug_level for mptbase.ko

There are various debug levels that can be found in the source file mptdebug.h

Since the difference is of size 175 KB, it is split into five different patches
grouped based on the files as described below.

	[PATCH 1/5] : Changes for logging support in Kconfig, Makefile,
			 mptbase.h and addition of mptdebug.h
 	[PATCH 2/5] : Changes in mptbase.c for logging support
 	[PATCH 3/5] : Changes in mptscsih.c for logging support
 	[PATCH 4/5] : Changes in mptfc.c mptlan.c mptsas.c and mptspi.c
		      for logging support
 	[PATCH 5/5] : Changes in mptctl.c for logging support

signed-off-by: Sathya Prakash <sathya.prakash@lsi.com>
---
