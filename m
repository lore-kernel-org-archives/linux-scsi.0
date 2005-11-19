From: Jeff <jeff@kconline.com>
Subject: HP (AMI) NetRAID-1M support
Date: Sat, 19 Nov 2005 17:05:50 +0000
Message-ID: <20051119170550.GB38987@kconline.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shell0.kconline.com ([216.241.132.5]:13533 "EHLO
	shell0.kconline.com") by vger.kernel.org with ESMTP
	id S1750901AbVKSWDm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Nov 2005 17:03:42 -0500
Received: from shell0.kconline.com (localhost [127.0.0.1])
	by shell0.kconline.com (8.13.4/8.13.3) with ESMTP id jAJH5okH039410
	for <linux-scsi@vger.kernel.org>; Sat, 19 Nov 2005 17:05:50 GMT
	(envelope-from jeff@kconline.com)
Received: (from archaic@localhost)
	by shell0.kconline.com (8.13.4/8.13.3/Submit) id jAJH5oVV039409
	for linux-scsi@vger.kernel.org; Sat, 19 Nov 2005 17:05:50 GMT
	(envelope-from jeff@kconline.com)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I'm stuck with this old SCSI RAID card and have been googling around for
drivers. I found some old ones. The latest is IA64 aware, but still it
is 4.5 years old:

http://www.hyper-linux.org/HP-HOWTO/mirror/Software/mega115.tgz

The README for the above tarball says to overwrite the megaraid.{c,h}
files and to change

#define SD_TIMEOUT              (15 * HZ)
to
#define SD_TIMEOUT              (30 * HZ)

which is already the default in 2.6.12.5.

So the question is, will this driver work on 2.6.12, or any 2.6 kernel?

Thanks a bunch!

-- 
Jeff

