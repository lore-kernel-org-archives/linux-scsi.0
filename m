From: Krishna Gudipati <kgudipat@brocade.com>
Subject: [PATCH 0/5] bfa: Brocade BFA FC SCSI driver (overview)
Date: Mon, 23 Mar 2009 17:10:09 -0700
Message-ID: <200903240010.n2O0A9vp013492@blc-10-2.brocade.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx40.brocade.com ([144.49.195.4]:12255 "EHLO mx40.brocade.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752218AbZCXATs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Mar 2009 20:19:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: huangj@brocade.com, kgudipat@brocade.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rvadivel@brocade.com, vravindr@brocade.com

From: Krishna Chaitanya Gudipati <kgudipat@brocade.com>

This is the an interim submission of Brocade BFA FC SCSI Driver for code review.
We moved FC protocol/port state machine part of the driver to the firmware to
make the driver simpler. We also implemented the code review comments received
from last submission which includes: 1) replaced bfa specific list management
routines by standard linux list implemetation. 2) Other minor fixes to naming,
Makefile, kconfig etc.

Please note that this driver is still not fully functioning. We expect to do
anoher submssion next week after we complete all the changes.

It contains a serial of 5 patches generated using 2.6.29-rc8 kernel. Here is
a brief description of each patch:

[PATCH 1/5]: Linux driver specific code, things such as module load/unload,
PCI probe/release, interrupt handler, and sysfs interface etc. All the files
start with "bfad_" prefix.

[PATCH 2/5]: Hardware/FW access code. All files start with "bfa_" prefix.

[PATCH 3/5]: Common header files shared by linux driver specific and
hardware/FW access code.

[PATCH 4/5]: Updated Kconfig and Makefile for driver/scsi, and Makefile
for bfa driver.

[PATCH 5/5]: Updated MAINTAINER file.

Signed-off-by: Krishna Chaitanya Gudipati <kgudipat@brocade.com>
---
