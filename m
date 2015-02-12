From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Subject: [PATCH 0/5] Rename regulator_set_optimum_mode
Date: Wed, 11 Feb 2015 19:35:26 -0800
Message-ID: <1423712131-23795-1-git-send-email-bjorn.andersson@sonymobile.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:16005 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754204AbbBLDfi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Feb 2015 22:35:38 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>, Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>, Vinayak Holikatti <vinholikatti@gmail.com>
Cc: linux-arm-msm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org

Changing the name of the regulator_set_optimum_mode() to
regulator_set_load() better reflects that the API is doing.

This series does the name change and move the current consumers
over.

Bjorn Andersson (5):
  regulator: s/regulator_set_optimum_mode/regulator_set_load/
  ufs: Rename of regulator_set_optimum_mode
  usb: phy: ab8500-usb: Rename regulator_set_optimum_mode
  usb: phy: phy-msm-usb: Rename regulator_set_optimum_mode
  regulator: Drop temporary regulator_set_optimum_mode wrapper

 Documentation/power/regulator/consumer.txt |  2 +-
 drivers/regulator/core.c                   |  8 ++++----
 drivers/scsi/ufs/ufshcd.c                  | 27 +++++++--------------------
 drivers/usb/phy/phy-ab8500-usb.c           |  4 ++--
 drivers/usb/phy/phy-msm-usb.c              | 15 +++++----------
 include/linux/regulator/consumer.h         |  5 ++---
 6 files changed, 21 insertions(+), 40 deletions(-)

-- 
1.8.2.2

