From: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH fix for 3.17 v2] uas: Disable uas on ASM1051 devices
Date: Wed, 10 Sep 2014 10:51:35 +0200
Message-ID: <1410339096-13227-1-git-send-email-hdegoede@redhat.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Greg,

Here is v2 of my ASM1051 blacklist patch. The commit message and some of
the log messages have been changed to reflect that my vision on the ASM1051
woes has shifted from: "too bad we need to blacklist this because it does not
work in some cases", to: "this thing is just too buggy to try and use with uas,
disable it already".

Other then that there are no changes.

It would be good if we could get this fix into 3.17, as we've been receiving
a number of uas bug reports from ASM1051 users.

Regards,

Hans
