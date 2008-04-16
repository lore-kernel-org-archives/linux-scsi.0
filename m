From: Mark Salyzyn <Mark_Salyzyn@adaptec.com>
Subject: Re: [PATCH] [AACRAID] Do not describe check_reset parameter with its value
Date: Wed, 16 Apr 2008 08:29:32 -0400
Message-ID: <7151509B-739F-4568-8C0C-2240C8561B6B@adaptec.com>
References: <1208334879.5614.34.camel@compaq.thuisdomein>
Mime-Version: 1.0 (Apple Message framework v919.2)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ts.adaptec.com ([162.62.93.58]:38999 "EHLO mail-gw3.adaptec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758503AbYDPM3e (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Apr 2008 08:29:34 -0400
In-Reply-To: <1208334879.5614.34.camel@compaq.thuisdomein>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paul Bolle <pebolle@tiscali.nl>, Linux-Scsi <linux-scsi@vger.kernel.org>

ACK

On Apr 16, 2008, at 4:34 AM, Paul Bolle wrote:

From: Paul Bolle <pebolle@tiscali.nl>

Describe check_reset parameter with its name (and not its value)

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/ 
aachba.c
index c05092f..43c7890 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -205,7 +205,7 @@ MODULE_PARM_DESC(check_interval, "Interval in  
seconds between adapter health"

int aac_check_reset = 1;
module_param_named(check_reset, aac_check_reset, int, S_IRUGO|S_IWUSR);
-MODULE_PARM_DESC(aac_check_reset, "If adapter fails health check,  
reset the"
+MODULE_PARM_DESC(check_reset, "If adapter fails health check, reset  
the"
        " adapter. a value of -1 forces the reset to adapters  
programmed to"
        " ignore it.");



