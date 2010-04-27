From: Tom Rini <tom_rini@mentor.com>
Subject: [PATCH][SCSI] Unexport scsi/scsi.h from headers_install
Date: Tue, 27 Apr 2010 14:11:47 -0700
Message-ID: <1272402707.3865.741.camel@trini-m4400>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:36734 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754655Ab0D0WC0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Apr 2010 18:02:26 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org

Hey all,

scsi: Unexport scsi/scsi.h from headers_install

The scsi/scsi.h header is normally provided by the libc (and was not
exported by the kernel since 2.6.24) and has been until it was
re-exported with 2.6.31.  The kernel version is not userspace clean and
does not appear to provide anything useable in userland over the
(e)glibc version.

Signed-off-by: Tom Rini <tom_rini@mentor.com>

diff --git a/include/scsi/Kbuild b/include/scsi/Kbuild
index b3a0ee6..f2b9491 100644
--- a/include/scsi/Kbuild
+++ b/include/scsi/Kbuild
@@ -1,4 +1,3 @@
-header-y += scsi.h
 header-y += scsi_netlink.h
 header-y += scsi_netlink_fc.h
 header-y += scsi_bsg_fc.h

-- 
Tom Rini <tom_rini@mentor.com>
Mentor Graphics Corporation
