From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 0/5] bfa: Brocade BFA FC SCSI driver (overview)
Date: Sat, 14 Mar 2009 12:52:40 -0700
Message-ID: <200903141952.n2EJqeHb028773@blc-10-6.brocade.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757923AbZCNUCg@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: kgudipat@brocade.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rvadivel@brocade.com, vravindr@brocade.com
List-Id: linux-scsi@vger.kernel.org

From: Jing Huang <huangj@brocade.com>

This is the an interim submission of Brocade BFA FC SCSI Driver for code review.
We moved FC protocol/port state machine part of the driver to the firmware to
make the driver simpler. We also implemented the code review comments received
from last submission which includes: 1) replaced bfa specific list management
routines by standard linux list implemetation. 2) Other minor fixes such as 
namming, kconfig etc.

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
for bfa driver 

[PATCH 5/5]: Updated MAINTAINER file.

Signed-off-by: Jing Huang <huangj@brocade.com>
---
