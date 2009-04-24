From: VaibhavNipunage <vaibhavnipunage@gmail.com>
Subject: Mode Pages implementaion
Date: Fri, 24 Apr 2009 03:26:10 -0700 (PDT)
Message-ID: <23213776.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kuber.nabble.com ([216.139.236.158]:55375 "EHLO
	kuber.nabble.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338AbZDXK0N (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Apr 2009 06:26:13 -0400
Received: from isper.nabble.com ([192.168.236.156])
	by kuber.nabble.com with esmtp (Exim 4.63)
	(envelope-from <lists@nabble.com>)
	id 1LxIbi-0008LR-Tg
	for linux-scsi@vger.kernel.org; Fri, 24 Apr 2009 03:26:10 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Hi All,

I want some help in Mode Pages. Currently I am implementing mode pages. 

When initiator sends Mode Sense (0x1Ah) with requested page opcode (0x3F :
all pages), then at that time on target side, target got the Allocation
Length as 192. I dont know why it is getting 192 size. I read PC-3 doc,
according to that target should receive 256 (for MODE SENSE 6) or 65,536
(for MODE SENSE 10). I am confused why this is happening? 

Please help me.

Thanks in advance.
-- 
View this message in context: http://www.nabble.com/Mode-Pages-implementaion-tp23213776p23213776.html
Sent from the linux-scsi mailing list archive at Nabble.com.

