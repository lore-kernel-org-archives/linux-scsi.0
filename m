From: "Bailey, Scott" <scott.bailey@eds.com>
Subject: qla1280 bugfix in limbo?
Date: Thu, 24 Aug 2006 12:33:13 -0400
Message-ID: <F3598542BAC24B4783B7A440D45522FF04B5D899@usahm236.amer.corp.eds.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ahmler2.mail.eds.com ([192.85.154.72]:29153 "EHLO
	ahmler2.mail.eds.com") by vger.kernel.org with ESMTP
	id S1751613AbWHXQeG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Aug 2006 12:34:06 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 366730@bugs.debian.org
Cc: "Bailey, Scott" <scott.bailey@eds.com>, linux-scsi@vger.kernel.org

Just tuning in briefly to report:

1. I have been running my 3-processor Alphaserver 4100 with Ian's patch
http://bugzilla.kernel.org/show_bug.cgi?id=6275 for a little over a
month now, first with 2.6.16 and now with 2.6.17, and it continues to
work like a champ. I very much would like to see this fix incorporated
into the Debian kernel or preferably upstream, since my DLT drive is
pretty much useless without it.

2. Unfortunately, I see no sign that anybody has looked at the kernel
bugzilla report above.

Is there anything I can do to help move things along?

Thanks,

Scott Bailey
scott.bailey@eds.com
