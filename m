From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 0/6] bfa: Brocade BFA FC SCSI driver submission (2nd try)
Date: Thu, 25 Sep 2008 17:50:47 -0700
Message-ID: <200809260050.m8Q0oltC027096@swe37.brocade.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx10.brocade.com ([208.185.105.18]:63830 "EHLO mx10.brocade.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752164AbYIZAuu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Sep 2008 20:50:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: huangj@brocade.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rvadivel@brocade.com, srayas@brocade.com, vravindr@brocade.com

From: Jing Huang <huangj@brocade.com>

This is the initial submission of Brocade BFA FC SCSI Driver to the
upstream kernel. The following 1-6 patches contain the driver source for
Brocade 8G Fibre Channel to PCIe HBA and other supporting files for kernel
inclusion. Brocade Fibre Channel HBA driver, also called as BFA driver, is
a SCSI lower layer driver. It interfaces with SCSI mid layer, and controls
Brocade FC controller through its firmware API. BFA driver supports fabric,
P2P and autotopolgy. It runs at 1/2/4/8G and auto link speed. It also
supports features such as sysfs interface, NPIV, and PCI hotplug etc.     

Here is a brief description of the patches included in this submission:

[PATCH 1/6]: Linux driver specific code, things such as module load/unload,
PCI probe/release, interrupt handler, and sysfs interface etc. All the files
start with "bfad_" prefix.

[PATCH 2/6]: Hardware/FW access code. All files start with "bfa_" prefix.

[PATCH 3/6]: Common header files shared by linux driver specific and
hardware/FW access code.

[PATCH 4/6]: Updated Kconfig and Makefile for driver/scsi, and new Makefile
and Kconfig file for bfa driver 

[PATCH 5/6]: Document for Brocade specific sysfs interface for HBA management.

[PATCH 6/6]: Update MAINTAINER file.

Signed-off-by: Jing Huang <huangj@brocade.com>
---
