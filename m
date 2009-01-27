From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 0/5] bfa: Brocade BFA FC SCSI driver submission
Date: Tue, 27 Jan 2009 10:52:41 -0800
Message-ID: <200901271852.n0RIqf3E026606@swe37.brocade.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx30.brocade.com ([144.49.194.4]:12397 "EHLO mx30.brocade.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751304AbZA0TC0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Jan 2009 14:02:26 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: kgudipat@brocade.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rvadivel@brocade.com, vravindr@brocade.com

From: Jing Huang <huangj@brocade.com>

This is the second submission of Brocade BFA FC SCSI Driver to the upstream
kernel. It implements the code review comments we received from our first
submission: 1) Removed Brocade specific sysfs implementation due to the
negative feedback from kernel.org. 2) Other code review comments by Greg KH. 

It contains a serial of 5 patches generated using 2.6.29-rc2 kernel. Here is
a brief description of each patch:

[PATCH 1/5]: Linux driver specific code, things such as module load/unload,
PCI probe/release, interrupt handler, and sysfs interface etc. All the files
start with "bfad_" prefix.

[PATCH 2/5]: Hardware/FW access code. All files start with "bfa_" prefix.

[PATCH 3/5]: Common header files shared by linux driver specific and
hardware/FW access code.

[PATCH 4/5]: Updated Kconfig and Makefile for driver/scsi, and new Makefile
and Kconfig file for bfa driver 

[PATCH 5/5]: Updated MAINTAINER file.

Signed-off-by: Jing Huang <huangj@brocade.com>
---
