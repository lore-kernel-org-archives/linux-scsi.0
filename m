From: Paul Bolle <pebolle@tiscali.nl>
Subject: Re: [PATCH] [AACRAID] Do not describe check_reset parameter with
	its value
Date: Wed, 16 Apr 2008 14:43:00 +0200
Message-ID: <1208349780.5614.64.camel@compaq.thuisdomein>
References: <1208334879.5614.34.camel@compaq.thuisdomein>
	 <7151509B-739F-4568-8C0C-2240C8561B6B@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:57563 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757708AbYDPMnD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Apr 2008 08:43:03 -0400
In-Reply-To: <7151509B-739F-4568-8C0C-2240C8561B6B@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Salyzyn <Mark_Salyzyn@adaptec.com>
Cc: Linux-Scsi <linux-scsi@vger.kernel.org>

From: Paul Bolle <pebolle@tiscali.nl>

Do not describe check_reset parameter with its value
    
Describe check_reset parameter with its name (and not its value)
    
Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Mark Salyzyn <Mark_Salyzyn@adaptec.com>
---
Reformatted patch (with Mark Salyzyn's sign-off added).

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index c05092f..43c7890 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -205,7 +205,7 @@ MODULE_PARM_DESC(check_interval, "Interval in seconds between adapter health"
 
 int aac_check_reset = 1;
 module_param_named(check_reset, aac_check_reset, int, S_IRUGO|S_IWUSR);
-MODULE_PARM_DESC(aac_check_reset, "If adapter fails health check, reset the"
+MODULE_PARM_DESC(check_reset, "If adapter fails health check, reset the"
 	" adapter. a value of -1 forces the reset to adapters programmed to"
 	" ignore it.");
 


