From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 0/2] osst: remove scsi_execute_async usage
Date: Sun, 14 Dec 2008 00:55:16 +0900
Message-ID: <1229183718-1171-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:40805 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796AbYLMQMt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 13 Dec 2008 11:12:49 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: osst@riede.org
Cc: James.Bottomley@HansenPartnership.com, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org

This patchset removes scsi_execute_async usage in osst driver. IOW,
this converts osst driver to use the block layer functions. We are in
the process of removing scsi_execute_async and
scsi_req_map_sg. scsi_execute_async in sg driver were removed in
2.6.27. The patchset to remove scsi_execute_async in st is available
(the first half patchset was already merged into scsi-misc). osst is
the last user.

This is against scsi-misc and depends on 'removing scsi_execute_async
in st' the second half patchset:

http://marc.info/?l=linux-scsi&m=122900494917385&w=2



