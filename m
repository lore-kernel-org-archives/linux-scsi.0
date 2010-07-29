From: Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [PATCH 4/6] regulator: Remove owner field from attribute initialization in regulator core driver
Date: Wed, 28 Jul 2010 22:09:24 -0700
Message-ID: <1280380166-29196-5-git-send-email-guenter.roeck@ericsson.com>
References: <1280380166-29196-1-git-send-email-guenter.roeck@ericsson.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imr1.ericy.com ([198.24.6.9]:37099 "EHLO imr1.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845Ab0G2FSa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Jul 2010 01:18:30 -0400
In-Reply-To: <1280380166-29196-1-git-send-email-guenter.roeck@ericsson.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>, Richard Purdie <rpurdie@rpsys.net>, Greg Kroah-Hartman <gregkh@suse.de>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul
Cc: Jean Delvare <khali@linux-fr.org>, Dmitry Torokhov <dtor@mail.ru>, Liam Girdwood <lrg@slimlogic.co.uk>, Mark Brown <broonie@opensource.wolfsonmicro.com>, Jani Nikula <ext-jani.1.nikula@nokia.com>, Linus Walleij <linus.walleij@stericsson.com>, Chris Wright <chrisw@sous-sol.org>, Nick Cheng <nick.cheng@areca.com.tw>, James Smart <james.smart@emulex.com>, Alex Iannicelli <alex.iannicelli@emulex.com>, "Eric W. Biederman" <ebiederm@aristanetworks.com>, Benjamin Thery <benjamin.thery@bull.net>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linuxppc-dev@ozlabs.org, Guenter Roeck <guenter.roeck@ericsson.com>

Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
---
 drivers/regulator/core.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 2248087..422a709 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1025,7 +1025,6 @@ static struct regulator *create_regulator(struct regulator_dev *rdev,
 		if (regulator->dev_attr.attr.name == NULL)
 			goto attr_name_err;
 
-		regulator->dev_attr.attr.owner = THIS_MODULE;
 		regulator->dev_attr.attr.mode = 0444;
 		regulator->dev_attr.show = device_requested_uA_show;
 		err = device_create_file(dev, &regulator->dev_attr);
-- 
1.7.0.87.g0901d

