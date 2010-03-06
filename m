From: <kgudipat@brocade.com>
Subject: [PATCH 00/23] bfa: update bfa driver to version 2.1.2.1 (resubmit)
Date: Fri, 5 Mar 2010 19:34:19 -0800
Message-ID: <1267846459-21559-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hq-exedge.brocade.com ([66.243.153.82]:55926 "EHLO
	hq-exedge.brocade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205Ab0CFDeZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Mar 2010 22:34:25 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@brocade.com, huangj@brocade.com, kgudipat@brocade.com

From: Krishna Gudipati <kgudipat@brocade.com>

Hi James,

We are resubmitting rest of the brocade bfa 2.1.2.1 driver patch.


I have made the patches bisectable and also fixed the checkpatch errors

you had pointed out. I have compiled the patches against your scsi-misc

and linux-2.6.33.


About this submission, we completely reworked the patch set by hand merging

previous checkins so that each patch addresses a specific issue.

We hope this patch set meets the upstream standard and gets included in

your scsi-misc tree. In the following weeks, we will submit more patches

to clean up the driver and reduce the number of files to be on par

with most of the upstream drivers.


Here are the changes we made in 2.1.2.1 driver:

Krishna Gudipati (23):
  bfa: IOC changes: Support faster recovery and split bfa_ioc.c into
    ASIC specific code.
  bfa: Clear LL_HALT and PSS_ERR bit when IOC crashes.
  bfa: Replace bfa_assert() with bfa_sm_fault()
  bfa: RPORT state machine: direct attach mode fix.
  bfa: Fix to copy fpma MAC when requested by user space application.
  bfa: PCI VPD, FIP and include file changes.
  bfa: FCS authentication related changes.
  bfa: Added firmware save clear feature for BFA driver.
  bfa: Introduce a link notification state machine.
  bfa: AEN and byte alignment fixes.
  bfa: IOC recovery fix in fcmode.
  bfa: Fix Command Queue (CPE) full condition check and ack CPE
    interrupt.
  bfa: In MSIX mode, ignore spurious RME interrupts when FCoE ports are
    in FW mismatch state.
  bfa: IOC fixes, check for IOC down condition.
  bfa: Rename pport to fcport in BFA FCS.
  bfa: New portlog entries for events (FIP/FLOGI/FDISC/LOGO).
  bfa: Replace bfa_get_attr() with specific APIs
  bfa: Modified the portstats get/clear logic
  bfa: FCS and include file changes.
  bfa: Handle SCSI IO underrun case.
  bfa: Support vport create/delete from sysfs.
  bfa: Remove unused header files and did some cleanup.
  bfa: Update the driver version to 2.1.2.1.

Thanks,

Krishna Chaitanya Gudipati.
