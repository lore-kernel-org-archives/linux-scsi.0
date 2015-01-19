From: Ondrej Zary <linux@rainbow-software.org>
Subject: [RFC PATCH 0/13] aha1542: Various improvements
Date: Mon, 19 Jan 2015 23:37:44 +0100
Message-ID: <1421707077-25291-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:44249 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751997AbbASWiL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Jan 2015 17:38:11 -0500
Received: from stip-static-68.213-81-217.telecom.sk ([213.81.217.68] helo=gsql.ggedos.sk)
	by gsystem.sk with esmtpsa (TLS1.1:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <linux@rainbow-software.org>)
	id 1YDKxU-0006A4-1E
	for linux-scsi@vger.kernel.org; Mon, 19 Jan 2015 23:38:08 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This (incomplete) patch series updates aha1542 driver to not use deprecated
initialization, removes dead code, ugly macros and simplifies the code.
It's probably not checkpatch-clean yet.


 aha1542.c |  984 ++++++++++++++++++++++----------------------------------------
 aha1542.h |   99 ++----
 2 files changed, 402 insertions(+), 681 deletions(-)

-- 
Ondrej Zary

