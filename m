From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Time to conclude the Sony USB mass storage thread
Date: 14 Nov 2003 09:52:24 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1068825146.2134.6.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:20998 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262740AbTKNPwd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Nov 2003 10:52:33 -0500
List-Id: linux-scsi@vger.kernel.org
To: usb-storage@one-eyed-alien.net, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdharm-scsi@one-eyed-alien.net

I think the fix we're all agreed on is preventing mode sense being
issued to USB storage.

Since Patrick has already provided the mechanics for this, I suggest we
do this by setting the skip_ms_page_3f and skip_ms_page_8 globally in
the usb-storage slave configure routines.

If there are known good devices, it would probably be best to add them
to the USB special devices list to have these flags reset for the
capabilities.

The nice thing about this approach is that I don't have to do anything
in SCSI, and the control of the USB black/white list is entirely in the
USB subsystem.

Does this sound like a plan?

James


