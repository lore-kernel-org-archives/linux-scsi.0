From: Mario Giammarco <mgiammarco@virgilio.it>
Subject: Bad fibre channel performance: need howto
Date: Fri, 21 Nov 2003 20:37:38 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1069443458.7047.35.camel@cala>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vsmtp12.tin.it ([212.216.176.206]:51374 "EHLO vsmtp12.tin.it")
	by vger.kernel.org with ESMTP id S264421AbTKUThm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Nov 2003 14:37:42 -0500
Received: from [62.211.165.163] (62.211.165.163) by vsmtp12.tin.it (7.0.019)
        id 3F8C84920112EC84 for linux-scsi@vger.kernel.org; Fri, 21 Nov 2003 20:37:40 +0100
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,
I asked a similar question last week.
I discovered that my hard disk which can do 60mb/sec sequential read,
under linux/lsilogic40909 fibre hba gives only 30mb/sec, 45 if I tweak a
lot readahead (why  I need to?).

I have searched a lot in internet and it seems that:

1) fibrechannel howto was in sistina home page but now disappeared
2) fibrechannel specific mailing list for linux disappeared (archives
to)

Where can I search for help? 
Here it not seems appropriate to me. 

I have to find my bottleneck, please help with sending me docs.

-- 
Mario Giammarco

