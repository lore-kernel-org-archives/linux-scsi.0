From: James Smart <james.smart@emulex.com>
Subject: [PATCH 0/8] lpfc 8.3.8: BugFixes: SLI relates changes
Date: Tue, 26 Jan 2010 23:07:02 -0500
Message-ID: <1264565242.2972.0.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:39123 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751229Ab0A0EHu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jan 2010 23:07:50 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


This patch set updates the lpfc driver to revision 8.3.8

The patches for 8.3.8 contain:
BugFixes:
- SLI relates changes
- Discovery relates changes
Additions:
- Add code to display logical link speed
- (BSG1) Update BSG infrastructure
- (BSG2) Create lpfc_bsg.h
- (BSG3) Modify BSG commands to operate asynchronously
- (BSG4) Add new vendor specific BSG Commands
- Update Driver version to 8.3.8

The bugfixes were cut against scsi-rc-fixes-2.6, but apply w/o change to
scsi-misc-2.6

The additions features were cut against scsi-misc-2.6. They did not assume
that patches 1 & 2 were applied. If combined w/ 1 & 2 there will be a little
fuzz in patches 3 & 4, but still apply fine.


-- james s


  Signed-off-by: James Smart <james.smart@emulex.com>




