From: edwin_rong <edwin_rong@realsil.com.cn>
Subject: Is it possible for Realtek card reader driver to reside in SCSI subsystem?
Date: Mon, 23 Apr 2012 11:49:06 +0800
Message-ID: <4F94D132.7070109@realsil.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([60.250.210.242]:52543 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206Ab2DWD6P (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Apr 2012 23:58:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, linux-scsi@vger.kernel.org, "gregkh@suse.de" <gregkh@suse.de>, =?UTF-8?B?546L54Kc?= <wei_wang@realsil.com.cn>

Dear James and all :

Sorry to disturb you again!

I'm an software engineer of Realtek corporation, responsible for writing 
driver for Realtek Card Reader chips.

Our device supports SD/MMC/MS/MSpro/xD series of cards, etc., which is 
implemented as an SCSI device in our driver,
and now our driver rts_pstor is under staging folder of linux kernel, so 
I want to know whether it is possible to move it out of staging folder,
and reside in SCSI subsystem?

I also know that both "mmc" and "memstick" subsystem exist in kernel 
now, but our device is a composition of these types of cards,
so it seems not suitable for keeping our driver there.

All replies are appreciated.

Thanks & BRs
Edwin.Rong
