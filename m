From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: [ANNOUNCE]: SCST 3.3 pre-release freeze
Date: Thu, 31 Aug 2017 21:16:29 -0700
Message-ID: <59A8DF1D.8080704@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: scst-devel <scst-devel@lists.sourceforge.net>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi All,

I'm glad to announce SCST 3.3 pre-release code freeze in the SCST SVN branch 3.3.x.

You can get it by command:

$ svn co https://scst.svn.sourceforge.net/svnroot/scst/branches/3.3.x

It is going to be released after few weeks of testing, if no significant issues found.

SCST is alternative SCSI target stack for Linux. SCST allows creation of sophisticated storage devices, which can provide advanced functionality, like replication, thin provisioning, deduplication, high availability, automatic backup, etc. Many recently developed SAN appliances, especially higher end ones, are SCST based. It might well be that your favorite storage appliance running SCST in the firmware.

More info about SCST and its modules you can find on: http://scst.sourceforge.net

Thanks to all who made it happen, especially to Bart Van Assche and SanDisk/Western Digital!

Vlad
