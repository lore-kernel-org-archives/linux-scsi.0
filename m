From: "Norman Diamond" <n0diamond@yahoo.co.jp>
Subject: Adaptec driver crashes (1/3 and 2/3)
Date: Wed, 6 May 2009 16:13:49 +0900
Message-ID: <8690A202112B4316A178F6DD0AD7E394@DIAMOND8600>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-2022-jp";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp10.mail.tnz.yahoo.co.jp ([203.216.226.138]:22088 "HELO
	smtp10.mail.tnz.yahoo.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751310AbZEFHUo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 May 2009 03:20:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

The easiest 100% reproducible way to crash a Linux system is as follows.

Insert either an Adaptec 1460 PCMCIA card or Adaptec 1480 CardBus card. 
Remove the card.  Insert the card again.  Even if you knew to set the 
console to a text mode terminal first (since Linux doesn't give Blue Screens 
of Death otherwise), you still won't get a dump.  Not much to go on without 
a dump, but at least it's 100% repro.

It doesn't happen with a NinjaSCSI card.  Insert card, access SCSI disk, 
remove card, insert card again, access SCSI disk again, remove card, insert 
again, no problem.  So there's something about two Adaptec drivers. 

--------------------------------------
Power up the Internet with Yahoo! Toolbar.
http://pr.mail.yahoo.co.jp/toolbar/
