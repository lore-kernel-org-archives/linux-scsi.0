From: bburk@extremeprotocol.com
Subject: ATA resets
Date: Sat, 23 Aug 2008 08:18:23 -0700
Message-ID: <20080823081823.a3c6426c1bfee0652ed014f32bc3b38e.48eba9268d.wbe@email.secureserver.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtpoutwbe03.prod.mesa1.secureserver.net ([208.109.78.114]:54549
	"HELO smtpoutwbe03.prod.mesa1.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751063AbYHWPSY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 23 Aug 2008 11:18:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Is there any mechanism to force resets (device and/or host/bus) on ATA
devices?   SG_SCSI_RESET results in ENOTTY on the sd interface and EIO
on the sg interface.  hdparm didn't seem able to do it, and I haven't
been able to get protocols 0, 1, or 9 to work via the SATL mechanism.
 
As far as I can tell the driver(s) basically just reject the call out of
hand even though it's a valid action.
 
 
Brent

