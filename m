From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: [ANNOUNCE]: SCST 3.2 pre-release freeze
Date: Tue, 02 Aug 2016 19:50:41 -0700
Message-ID: <57A15C01.7030602@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.75]:51355 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755572AbcHCCu7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Aug 2016 22:50:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scst-devel <scst-devel@lists.sourceforge.net>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Hi All,

I'm glad to announce SCST 3.2 pre-release code freeze in the SCST SVN branch 3.2.x.

You can get it by command:

$ svn co https://scst.svn.sourceforge.net/svnroot/scst/branches/3.2.x

It is going to be released after few weeks of testing, if no significant issues found.

SCST is alternative SCSI target stack for Linux. SCST allows creation of sophisticated storage devices, which can provide advanced functionality, like replication, thin provisioning, deduplication, high availability, automatic backup, etc. Majority of recently developed SAN appliances, especially higher end ones, are SCST based. It might well be that your favorite storage appliance running SCST in the firmware.

More info about SCST and its modules you can find on: http://scst.sourceforge.net

Thanks to all who made it happen, especially to SanDisk/WDC for the great support!

Vlad

