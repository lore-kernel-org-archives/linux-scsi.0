From: Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [PATCH 3/6] leds: Remove owner field from attribute initialization in bd2802 driver
Date: Wed, 28 Jul 2010 22:09:23 -0700
Message-ID: <1280380166-29196-4-git-send-email-guenter.roeck@ericsson.com>
References: <1280380166-29196-1-git-send-email-guenter.roeck@ericsson.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imr3.ericy.com ([198.24.6.13]:45806 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287Ab0G2FNx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Jul 2010 01:13:53 -0400
In-Reply-To: <1280380166-29196-1-git-send-email-guenter.roeck@ericsson.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>, Richard Purdie <rpurdie@rpsys.net>, Greg Kroah-Hartman <gregkh@suse.de>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul
Cc: Jean Delvare <khali@linux-fr.org>, Dmitry Torokhov <dtor@mail.ru>, Liam Girdwood <lrg@slimlogic.co.uk>, Mark Brown <broonie@opensource.wolfsonmicro.com>, Jani Nikula <ext-jani.1.nikula@nokia.com>, Linus Walleij <linus.walleij@stericsson.com>, Chris Wright <chrisw@sous-sol.org>, Nick Cheng <nick.cheng@areca.com.tw>, James Smart <james.smart@emulex.com>, Alex Iannicelli <alex.iannicelli@emulex.com>, "Eric W. Biederman" <ebiederm@aristanetworks.com>, Benjamin Thery <benjamin.thery@bull.net>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linuxppc-dev@ozlabs.org, Guenter Roeck <guenter.roeck@ericsson.com>

Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
---
 drivers/leds/leds-bd2802.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/leds/leds-bd2802.c b/drivers/leds/leds-bd2802.c
index 5dcdf9d..19dc4b6 100644
--- a/drivers/leds/leds-bd2802.c
+++ b/drivers/leds/leds-bd2802.c
@@ -351,7 +351,7 @@ static ssize_t bd2802_store_reg##reg_addr(struct device *dev,		\
 	return count;							\
 }									\
 static struct device_attribute bd2802_reg##reg_addr##_attr = {		\
-	.attr = {.name = reg_name, .mode = 0644, .owner = THIS_MODULE},	\
+	.attr = {.name = reg_name, .mode = 0644},			\
 	.store = bd2802_store_reg##reg_addr,				\
 };
 
@@ -482,7 +482,6 @@ static struct device_attribute bd2802_adv_conf_attr = {
 	.attr = {
 		.name = "advanced_configuration",
 		.mode = 0644,
-		.owner = THIS_MODULE
 	},
 	.show = bd2802_show_adv_conf,
 	.store = bd2802_store_adv_conf,
@@ -519,7 +518,6 @@ static struct device_attribute bd2802_##attr_name##_attr = {		\
 	.attr = {							\
 		.name = name_str,					\
 		.mode = 0644,						\
-		.owner = THIS_MODULE					\
 	},								\
 	.show = bd2802_show_##attr_name,				\
 	.store = bd2802_store_##attr_name,				\
-- 
1.7.0.87.g0901d

