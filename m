From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 0/3] lpfc 8.2.8 v2 : recut of conflicting 8.2.8 patches
Date: Sun, 07 Sep 2008 11:51:46 -0400
Message-ID: <1220802706.6747.9.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:61712 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbYIGPxN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Sep 2008 11:53:13 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id m87FrBT7026385
	for <linux-scsi@vger.kernel.org>; Sun, 7 Sep 2008 08:53:12 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


This patch set is reworked versions of 8.2.8 patches that were failing
due to conflicts with the target busy and transport disrupted changes.

patch1 resolves the target_busy vs transport_disrupted status

patch2 is a recut of:
  [PATCH 12/15] lpfc 8.2.8 : Add sysfs control of target queue depth handling

patch3 is a recut of:
  [PATCH 14/15] lpfc 8.2.8 : Add statistical reporting control and additional
    fc vendor events

-- james s



