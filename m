From: Tom Yan <tom.ty89@gmail.com>
Subject: how to "decode" SG_IO: bad/missing sense data?
Date: Tue, 16 Jun 2015 19:05:26 +0800
Message-ID: <CAGnHSEkbmVnby-QRs56JRUWCXHYxNZ_jiuE7R4Uard59GOy=Yw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f175.google.com ([209.85.220.175]:36519 "EHLO
	mail-qk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817AbbFPLF1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Jun 2015 07:05:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

When I "ATA Secure Erase" a USB Flash Drive, I got:

SG_IO: bad/missing sense data, sb[]:  f0 00 01 00 50 40 00 0a 00 00 00
00 00 1d 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

While the erase seems to work without bricking the device (multiple
trials with shred and hexdump), this message still bothers me a bit.
So is there anyway I could "decode" it so that I can know what it
actually means?
