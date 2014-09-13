From: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH fix for 3.17 0/1] uas: Add a quirk for rejecting ATA_12 and ATA_16
Date: Sat, 13 Sep 2014 12:19:07 +0200
Message-ID: <1410603548-3579-1-git-send-email-hdegoede@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21518 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887AbaIMKTN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 13 Sep 2014 06:19:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org

Hi Greg,

As the subject indicates, if possible I would like to still get this into
3.17.

For now this impacts only a single usb-id, but looking at
https://bbs.archlinux.org/viewtopic.php?id=183190

It seems more seagate uas capable enclosures are having issues, I'm waiting
for feedback from their users. I hope those can be fixed by adding the same
quirk for there usb-ids.

Regards,

Hans
