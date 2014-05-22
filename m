From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: [ANNOUNCE]: SCST 2.2 pre-release freeze
Date: Wed, 21 May 2014 21:10:16 -0700
Message-ID: <537D78A8.4030604@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: scst-devel <scst-devel@lists.sourceforge.net>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi All,

I'm glad to announce SCST 3.0 pre-release code freeze in the SCST SVN branch 3.0.x

You can get it by command:

$ svn co https://scst.svn.sourceforge.net/svnroot/scst/branches/3.0.x

It is going to be released after few weeks of testing, if nothing bad found.

SCST is alternative SCSI target stack for Linux. SCST allows creation of sophisticated storage devices, which provide advanced functionality, like replication, thin provisioning, deduplication, high availability, automatic backup, etc. Majority of recently developed SAN appliances, especially higher end ones, are SCST based. It might well be that your favorite storage appliance running SCST in the firmware.

More info about SCST and its modules you can find on: http://scst.sourceforge.net

Thanks to all who made it happen!

Vlad
