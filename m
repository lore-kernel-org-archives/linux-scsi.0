From: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH fix for 3.17 v4] uas: Add a quirk for rejecting ATA_12 and ATA_16
Date: Mon, 15 Sep 2014 10:25:36 +0200
Message-ID: <1410769537-7326-1-git-send-email-hdegoede@redhat.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Greg,

Sorry for the high number of iterations on this one. After the documentation
issues pointed out during review, I've just received a report from a user
that (as I already suspected) another seagate disk enclosure also benifits
from this quirk. So this version sets the quirk for 2 different seagate
models.

Regards,

Hans
