From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 0/14] bfa: Brocade BFA FC SCSI driver (overview)
Date: Wed, 19 Aug 2009 23:54:43 -0700
Message-ID: <200908200654.n7K6shpn005971@swe57.brocade.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753555AbZHTGyo@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rvadivel@brocade.com, vravindr@brocade.com
List-Id: linux-scsi@vger.kernel.org

From: Jing Huang <huangj@brocade.com>

Resubmitting the patches after implemented some of the code review comments
from Sam Ravnborg. Patches are generated using 2.6.31-rc6 kernel.

[PATCH 1/14]: SCSI LLD driver code, module init/exit, PCI and SCSI host entry
points, interrupt handler, and sysfs interface etc. 

[PATCH 2/14]: Hardware/FW access code. part-1

[PATCH 3/14]: Hardware/FW access code. part-2

[PATCH 4/14]: Hardware/FW access code. part-3

[PATCH 5/14]: Hardware/FW access code. part-4

[PATCH 6/14]: FC state machines. part-1

[PATCH 7/14]: FC state machines. part-2

[PATCH 8/14]: FC state machines. part-3

[PATCH 9/14]: FC state machines. part-3

[PATCH 10/14]: Common header files shared by linux driver,
hardware/FW access code, FC state machines. part-1

[PATCH 11/14]: Common header files shared by linux driver,
hardware/FW access code, FC state machines. part-2

[PATCH 12/14]: Common header files shared by linux driver,
hardware/FW access code, FC state machines. part-3

[PATCH 13/14]: Updated Kconfig and Makefile for driver/scsi, and Makefile
for bfa driver 

[PATCH 14/14]: Updated MAINTAINER file.

Signed-off-by: Jing Huang <huangj@brocade.com>
---
