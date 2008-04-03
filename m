From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Spin down disk at suspend/shotdown
Date: Thu, 03 Apr 2008 18:10:04 +0200
Message-ID: <47F5015C.1080706@s5r6.in-berlin.de>
References: <20080403064910.GB7716@dose.home.local>	<47F4F35E.50309@s5r6.in-berlin.de> <20080403152017.GA32750@dose.home.local> <47F4FD97.5060103@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:43648 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706AbYDCQKh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Apr 2008 12:10:37 -0400
In-Reply-To: <47F4FD97.5060103@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tino Keitel <tino.keitel+firewire@tikei.de>
Cc: linux1394-user@lists.sourceforge.net, linux-scsi@vger.kernel.org

Stefan Richter wrote:
> Tino Keitel wrote:
>> This is an ICY Box case with USB and Firewire interfaces.
> 
> Most or all oft the ICY Box combo interface HDD enclosures are based on
> the PL3507 bridge chip.  One thing you could try is to update its
> firmware.  The firmware uploader requires Windows and USB.
> http://www.raidsonic.de/de/pages/service/driver.php
> http://www.prolific.com.tw/eng/downloads.asp?ID=44  (apparently has a
> newer firmware than raidsonic)

PS:  I have no idea though whether newer firmware would actually fix it.
It's just that many PL3507 firmware variants are full of bugs, and that
the newest firmware is known to fix at least some of them.
-- 
Stefan Richter
-=====-==--- -=-- ---==
http://arcgraph.de/sr/
