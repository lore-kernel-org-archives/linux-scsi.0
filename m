From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 0/3] block: completion releated functions cleanup
Date: Mon, 11 May 2009 17:56:06 +0900
Message-ID: <1242032169-22422-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:37527 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755825AbZEKI47 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 May 2009 04:56:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: tj@kernel.org, James.Bottomley@HansenPartnership.com, bharrosh@panasas.com, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

This is a minor cleanup on the completion releated functions. It is on
the top of Tejun's unify request processing model patchset.


