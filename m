From: Troy Klein <res1uo0c@verizon.net>
Subject: Megaraid corruption?
Date: Wed, 08 Dec 2004 18:17:45 -0800
Message-ID: <1102558665.31354.22.camel@TroysLinux.verari.com>
Reply-To: res1uo0c@verizon.net
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out011pub.verizon.net ([206.46.170.135]:14817 "EHLO
	out011.verizon.net") by vger.kernel.org with ESMTP id S261431AbULICRr
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Dec 2004 21:17:47 -0500
Received: from TroysLinux.verari.com ([216.9.37.88]) by out011.verizon.net
          (InterMail vM.5.01.06.06 201-253-122-130-106-20030910) with ESMTP
          id <20041209021746.KTDZ1380.out011.verizon.net@TroysLinux.verari.com>
          for <linux-scsi@vger.kernel.org>; Wed, 8 Dec 2004 20:17:46 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I am attempting to find out why I am having data corruption problems on
my megaraid2 driver and not on megaraid.  The system is a 32-bit Xeon
with a LSI 150-6 SATA controller running Redhat EL 3.0AS.  When I am
running megaraid I can write data, read data, and modify data and get NO
corruption.  With megaraid2 I get data corruption with tar, rsync, and
scp.

Can anyone help?

Troy Perplexed




