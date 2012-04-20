From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 0/6] libfc, libfcoe and fcoe patches for scsi-misc
Date: Fri, 20 Apr 2012 12:16:20 -0700
Message-ID: <20120420191620.4634.94869.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:16610 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751375Ab2DTTQX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Apr 2012 15:16:23 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Here are a variety of fixes for the libfc, libfcoe and fcoe kernel
modules. I've included a pull request that points to a signed-tag.
I don't have many signatures on my pgp key as I haven't been to a
key signing party. It's up to you, James, as to whether you want
to use/trust it or not.

git://open-fcoe.org/fcoe/linux-fcoe.git tags/for-james-1

Thanks, //Rob

---

Dan Carpenter (1):
      fcoe: remove a stray unlock

Robert Love (1):
      fcoe: Don't hold rtnl_mutex in fcoe_update_src_mac

Vasu Dev (3):
      fcoe: remove lport from net device before doing per cpu rx thread cleanup
      libfc: flush lport worker after its disabled
      libfc: defer releasing master lport until complete fcoe interface cleanuped up

Yi Zou (1):
      libfcoe: fix VN2VN N_Port_ID Beacon source MAC


 drivers/scsi/fcoe/fcoe.c      |   41 ++++++++++++++++++++++++++++++-----------
 drivers/scsi/fcoe/fcoe.h      |    4 +++-
 drivers/scsi/fcoe/fcoe_ctlr.c |    8 +++++++-
 drivers/scsi/libfc/fc_lport.c |    2 +-
 4 files changed, 41 insertions(+), 14 deletions(-)

-- 
