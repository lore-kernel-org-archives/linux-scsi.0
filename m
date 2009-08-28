From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 0/14] bfa: Brocade BFA FC SCSI driver (overview)
Date: Fri, 28 Aug 2009 00:52:44 -0700
Message-ID: <200908280752.n7S7qi0q029726@blc-10-6.brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hq-exedge.brocade.com ([66.243.153.82]:38664 "EHLO
	hq-exedge.brocade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbZH1Hwn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Aug 2009 03:52:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rvadivel@brocade.com, vravindr@brocade.com

From: Jing Huang <huangj@brocade.com>

Resubmitting the patches to address code review comments from Rolf Eike Beer
on 8/21/2009.

Patches are generated using 2.6.31-rc7 kernel.

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
