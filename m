From: Philip Rhoades <phil@chu.com.au>
Subject: RHEL4/FC5 on Intel D945
Date: Fri, 07 Apr 2006 14:06:34 +1000
Message-ID: <1144382794.7341.17.camel@phil.chu.com.au>
Reply-To: phil@chu.com.au
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [203.166.81.114] ([203.166.81.114]:24582 "EHLO
	chunetbox.safenetbox.biz") by vger.kernel.org with ESMTP
	id S932184AbWDGEGC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Apr 2006 00:06:02 -0400
Received: from chunetbox.safenetbox.biz (chunetbox.safenetbox.biz [127.0.0.1])
	by chunetbox.safenetbox.biz (Postfix) with ESMTP id 8DD097362D
	for <linux-scsi@vger.kernel.org>; Fri,  7 Apr 2006 14:05:58 +1000 (EST)
Received: from nsw.chu.com.au (ip-192-168-0-100.local [192.168.0.100])
	by chunetbox.safenetbox.biz (Postfix) with SMTP id 441FB73555
	for <linux-scsi@vger.kernel.org>; Fri,  7 Apr 2006 14:05:58 +1000 (EST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

People,

Not sure if this is appropriate here - tell me where to go if
necessary . .

When I try and install RHEL4WS (2.6.9-34.ELsmp) on an Intel D945GTP
motherboard with a SATA HD, I get a message that there are no HDs
connected.  However, if I try to install FC5 (2.6.15-1.2054_FC5) it
works fine.

This is a relatively new MB and it appears the kernel SATA drivers for
FC5 are more up to date than RHEL4?

Is there some way of using the new drivers so I can install RHEL4?

Thanks,

Phil.
-- 
Philip Rhoades

Pricom Pty Limited  (ACN 003 252 275  ABN 91 003 252 275)
GPO Box 3411
Sydney NSW      2001
Australia
Mobile:  +61:0411-185-652
Fax:  +61:2:8923-5363
E-mail:  phil@chu.com.au


