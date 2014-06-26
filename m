From: loody <miloody@gmail.com>
Subject: how to firing device event when SD card inserting usb card reader
Date: Thu, 26 Jun 2014 22:47:27 +0800
Message-ID: <CANudz+tSTQLOQpNx71+h+cCUnoEshiCyDe+e=9E_ajvoj3a8Dg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:51588 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430AbaFZOrd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Jun 2014 10:47:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>

hi all:
I try below flow:
1. plug in usb card reader
2. wait 2 seconds
3. plug in SD card

on ubuntu PC system, the udev can get SD plug in event
but on my embedded system, there is no udev plug event when SD plug in.

Is this issue related to media change command?
if so, should I enable kernel config or do anything in user mode program?

thanks for your help in advance,
