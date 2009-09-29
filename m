From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCHv2 3/4] scsi: export scsi_ioctl.h and sg.h headers
Date: Tue, 29 Sep 2009 12:34:33 +0200
Message-ID: <20090929103432.GD11183@redhat.com>
References: <cover.1254220284.git.mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4742 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753914AbZI2Kgp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Sep 2009 06:36:45 -0400
Content-Disposition: inline
In-Reply-To: <cover.1254220284.git.mst@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Boaz Harrosh <bharrosh@panasas.com>, Sam Ravnborg <sam@ravnborg.org>

glibc uses scsi/sg.h and scsi/scsi_ioctl.h, so we need to
export these headers.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/scsi/Kbuild |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/scsi/Kbuild b/include/scsi/Kbuild
index 33b2750..a61932c 100644
--- a/include/scsi/Kbuild
+++ b/include/scsi/Kbuild
@@ -1,3 +1,5 @@
+header-y += sg.h
+header-y += scsi_ioctl.h
 header-y += scsi.h
 header-y += scsi_netlink.h
 header-y += scsi_netlink_fc.h
-- 
1.6.5.rc2

