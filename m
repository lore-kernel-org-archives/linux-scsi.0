From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 00/17] libfc, libfcoe and fcoe fixes
Date: Fri, 11 Jun 2010 16:43:28 -0700
Message-ID: <20100611234328.4616.95199.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:40510 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752473Ab0FKXna (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jun 2010 19:43:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org

This patch series fixes a variety of issues in libfc, libfcoe and fcoe. The
patches apply against scsi-misc.

The "fnic: drivers/scsi/fnic/fnic_scsi.c: clean up" patch was brought in
from a series posted to linux-scsi from Roel Kluin.

---

Bhanu Prakash Gollapudi (8):
      libfcoe: Avoid hang when receiving non-critical descriptors
      libfcoe: No solicitation if adv is dropped
      libfc: Retry a rejected PRLI request
      libfc: Honor LS_ACC response codes for PRLI
      libfc: Handle unsolicited PRLO request
      libfcoe: Handle duplicate critical descriptors
      libfcoe: Host doesnt handle CVL to NPIV ports
      libfcoe: Check for order and missing critical descriptors for FIP ELS requests

Joe Eykholt (7):
      libfcoe: FIP link keep-alive should continue while logged off
      fcoe: clean up TBD comments in FCoE prototype header
      libfcoe: fix lenient aging of FCF advertisements
      libfcoe: Use fka_period as periodic timeouts to age out fcf if
      libfcoe: update FIP FCF D flag from advertisments
      libfc: Fix remote port restart problem
      libfc: fix indefinite rport restart

Roel Kluin (1):
      fnic: drivers/scsi/fnic/fnic_scsi.c: clean up

Yi Zou (1):
      libfc: lport state is enum not bit mask


 drivers/scsi/fcoe/libfcoe.c   |  221 ++++++++++++++++++++++++++++++-----------
 drivers/scsi/fnic/fnic_scsi.c |   22 +---
 drivers/scsi/libfc/fc_fcp.c   |    2 
 drivers/scsi/libfc/fc_rport.c |  175 ++++++++++++++++++++++----------
 include/scsi/fc/fc_els.h      |    9 ++
 include/scsi/fc/fc_fcoe.h     |   15 +--
 include/scsi/libfc.h          |    7 +
 7 files changed, 307 insertions(+), 144 deletions(-)

-- 
Thanks, //Rob
