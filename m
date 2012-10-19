From: John Soni Jose <sony.john-n@emulex.com>
Subject: [PATCH v2 00/19] be2iscsi driver updates
Date: Sat, 20 Oct 2012 04:41:08 +0530
Message-ID: <257c4982-e7d0-4b5e-9eee-5f60f4c49dba@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:38717 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755127Ab2JSXMP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Oct 2012 19:12:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org
Cc: John Soni Jose <sony.john-n@emulex.com>

 V2 patches for be2iscsi driver updates. Fixed the review comments
 with this patch. These patches were generated aganist scsi-misc branch.

  be2iscsi: Fix the issue with soft reset.
  be2iscsi: Display Completion Event string instead of Opcode
  be2iscsi: Fix memory leak in control path of driver
  be2iscsi: Fix max supported EQ count to 8.
  be2iscsi: Display driver name and version in device attribute
  be2iscsi: Issue an FLR when driver is loaded
  be2iscsi: Fix kernel panic in blk_iopoll disable mode.
  be2iscsi: Fix return value and typo.
  be2iscsi: Fix driver support for an adapter.
  be2iscsi: Fix max EQ supported by the driver.
  be2iscsi: Fix support for handling CQ_CREATE V2 version.
  be2iscsi: Fix support for V2 version of WRB.
  be2iscsi: Fix session update context with V2 version.
  be2iscsi: Fix Task Completion Event handling
  be2iscsi: Fix issue of displaying adapter family.
  be2iscsi: Fix the copyright information
  be2iscsi: Fix for MBX timeout issue
  be2iscsi: Fix Unrecoverable Error Detection
  be2iscsi: Bump the driver version

 drivers/scsi/be2iscsi/be.h       |    7 +-
 drivers/scsi/be2iscsi/be_cmds.c  |  236 +++++++--
 drivers/scsi/be2iscsi/be_cmds.h  |   93 ++++-
 drivers/scsi/be2iscsi/be_iscsi.c |  124 ++---
 drivers/scsi/be2iscsi/be_iscsi.h |    2 +-
 drivers/scsi/be2iscsi/be_main.c  | 1068 ++++++++++++++++++++++++--------------
 drivers/scsi/be2iscsi/be_main.h  |  152 +++++-
 drivers/scsi/be2iscsi/be_mgmt.c  |  424 +++++++++++++---
 drivers/scsi/be2iscsi/be_mgmt.h  |   23 +-
 9 files changed, 1547 insertions(+), 582 deletions(-)

-- 
1.7.2

