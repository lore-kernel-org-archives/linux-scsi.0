From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 0/36] aha1542: Various improvements
Date: Fri,  6 Feb 2015 23:11:21 +0100
Message-ID: <1423260717-15944-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:56929 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756832AbbBFWMM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Feb 2015 17:12:12 -0500
Received: from stip-static-68.213-81-217.telecom.sk ([213.81.217.68] helo=gsql.ggedos.sk)
	by gsystem.sk with esmtpsa (TLS1.1:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <linux@rainbow-software.org>)
	id 1YJr8D-0006fF-1i
	for linux-scsi@vger.kernel.org; Fri, 06 Feb 2015 23:12:09 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,
this patch series updates aha1542 driver to not use deprecated
initialization, removes dead code, ugly macros and simplifies the code.
No major CodingStyle fixes yet.

Tested on AHA-1542B.

 aha1542.c | 1687 +++++++++++++++++++-------------------------------------------
 aha1542.h |  136 +---
 2 files changed, 583 insertions(+), 1240 deletions(-)

-- 
Ondrej Zary

