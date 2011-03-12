From: Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: [PATCH 00/20] world-writable files in sysfs and debugfs
Date: Sat, 12 Mar 2011 23:23:06 +0300
Message-ID: <AANLkTikE-A=Fe-yRrN0opWwJGQ0f4uOzkyB3XCcEUrFE__14465.3154690333$1299961416$gmane$org@mail.gmail.com>
References: <cover.1296818921.git.segoon@openwall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41357 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754717Ab1CLUXI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 12 Mar 2011 15:23:08 -0500
In-Reply-To: <cover.1296818921.git.segoon@openwall.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org, linux-media@vger.kernel.org, platform-driver-x86@vger.kernel.

> Vasiliy Kulikov (20):
> =A0mach-ux500: mbox-db5500: world-writable sysfs fifo file
> =A0leds: lp5521: world-writable sysfs engine* files
> =A0leds: lp5523: world-writable engine* sysfs files
> =A0misc: ep93xx_pwm: world-writable sysfs files
> =A0rtc: rtc-ds1511: world-writable sysfs nvram file
> =A0scsi: aic94xx: world-writable sysfs update_bios file
> =A0scsi: iscsi: world-writable sysfs priv_sess file

These are still not merged :(
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
