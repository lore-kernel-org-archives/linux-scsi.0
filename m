From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 0/5] bfa: Brocade BFA FC SCSI driver (overview)
Date: Sun, 19 Jul 2009 23:20:58 -0700
Message-ID: <200907200620.n6K6Kw2O011121@swe57.brocade.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752134AbZGTGad@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: kgudipat@brocade.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rvadivel@brocade.com, vravindr@brocade.com, xmzhang@brocade.com
List-Id: linux-scsi@vger.kernel.org

From: Jing Huang <huangj@brocade.com>

In this submission, we completed all the pening works in our last submission
in April, including:
1) Added support of Brocade PCIe FCOE HBA.
2) Cleaned up FC state machine code.
3) Completed implementing code review comments received from the open source
community.

It contains a serial of 5 patches generated using 2.6.30.1 kernel. Here is
a brief description of each patch:

[PATCH 1/5]: SCSI LLD driver code, module init/exit, PCI and SCSI host entry
points, interrupt handler, and sysfs interface etc. 

[PATCH 2/5]: Hardware/FW access code and FC state machines.

[PATCH 3/5]: Common header files shared by linux driver specific,
hardware/FW access code, FC state machines.

[PATCH 4/5]: Updated Kconfig and Makefile for driver/scsi, and Makefile
for bfa driver 

[PATCH 5/5]: Updated MAINTAINER file.

Signed-off-by: Jing Huang <huangj@brocade.com>
---
