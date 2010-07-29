From: Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [PATCH 6/6] Remove owner field from sysfs struct attribute
Date: Wed, 28 Jul 2010 22:09:26 -0700
Message-ID: <1280380166-29196-7-git-send-email-guenter.roeck@ericsson.com>
References: <1280380166-29196-1-git-send-email-guenter.roeck@ericsson.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1280380166-29196-1-git-send-email-guenter.roeck@ericsson.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>, Richard Purdie <rpurdie@rpsys.net>, Greg Kroah-Hartman <gregkh@suse.de>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul
Cc: Jean Delvare <khali@linux-fr.org>, Dmitry Torokhov <dtor@mail.ru>, Liam Girdwood <lrg@slimlogic.co.uk>, Mark Brown <broonie@opensource.wolfsonmicro.com>, Jani Nikula <ext-jani.1.nikula@nokia.com>, Linus Walleij <linus.walleij@stericsson.com>, Chris Wright <chrisw@sous-sol.org>, Nick Cheng <nick.cheng@areca.com.tw>, James Smart <james.smart@emulex.com>, Alex Iannicelli <alex.iannicelli@emulex.com>, "Eric W. Biederman" <ebiederm@aristanetworks.com>, Benjamin Thery <benjamin.thery@bull.net>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linuxppc-dev@ozlabs.org, Guenter Roeck <guenter.roeck@ericsson.com>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
---
 include/linux/sysfs.h |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index f2694eb..880fa1a 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -22,14 +22,8 @@ struct kobject;
 struct module;
 enum kobj_ns_type;
 
-/* FIXME
- * The *owner field is no longer used.
- * x86 tree has been cleaned up. The owner
- * attribute is still left for other arches.
- */
 struct attribute {
 	const char		*name;
-	struct module		*owner;
 	mode_t			mode;
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lock_class_key	*key;
-- 
1.7.0.87.g0901d
