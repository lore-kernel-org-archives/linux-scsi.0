From: Thomas Maguin <T.Maguin@web.de>
Subject: Re: cxscan-user.patch
Date: Fri, 16 Sep 2005 14:13:35 +0200
Message-ID: <200509161413.37726.T.Maguin@web.de>
References: <200509160736.22007.T.Maguin@web.de> <20050916114914.GD2862@suse.de>
Reply-To: T.Maguin@web.de
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp07.web.de ([217.72.192.225]:54194 "EHLO smtp07.web.de")
	by vger.kernel.org with ESMTP id S1161047AbVIPMNV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Sep 2005 08:13:21 -0400
Received: from [80.136.212.180] (helo=paris.troja)
	by smtp07.web.de with asmtp (TLSv1:RC4-MD5:128)
	(WEB.DE 4.105 #317)
	id 1EGF5j-0000F1-00
	for linux-scsi@vger.kernel.org; Fri, 16 Sep 2005 14:13:20 +0200
In-Reply-To: <20050916114914.GD2862@suse.de>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

--- drivers/block/old-scsi_ioctl.c      2005-09-16 07:06:37.000000000 +0200
+++ drivers/block/scsi_ioctl.c  2005-09-13 12:06:48.000000000 +0200
@@ -167,6 +167,7 @@ static int verify_command(struct file *f
                safe_for_write(WRITE_VERIFY_12),
                safe_for_write(WRITE_16),
                safe_for_write(WRITE_LONG),
+               safe_for_write(WRITE_LONG_2),
                safe_for_write(ERASE),
                safe_for_write(GPCMD_MODE_SELECT_10),
                safe_for_write(MODE_SELECT),


