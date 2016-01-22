From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: [ANNOUNCE]: SCST 3.1 release
Date: Thu, 21 Jan 2016 20:17:12 -0800
Message-ID: <56A1AD48.5040104@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.135]:62081 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756AbcAVER0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Jan 2016 23:17:26 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scst-devel <scst-devel@lists.sourceforge.net>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Hi All,

I'm glad to announce that SCST version 3.1 has just been released and available for
download from http://scst.sourceforge.net/downloads.html.

Highlights for this release:

 - Cluster support for SCSI reservations. This feature is essential for initiator-side
clustering approaches based on persistent reservations, e.g. the quorum disk
implementation in Windows Clustering.

 - Full support for VAAI or vStorage API for Array Integration: Extended Copy command
support has been added as well as performance of WRITE SAME and of Atomic Test & Set,
also known as COMPARE AND WRITE, has been improved.

 - T10-PI support has been added.

 - ALUA support has been improved: explicit ALUA (SET TARGET PORT GROUPS command) has
been added and DRBD compatibility has been improved.

 - SCST events user space infrastructure has been added, so now SCST can notify a user
space agent about important internal and fabric events.

 - QLogic target driver has been significantly improved.

SCST is alternative SCSI target stack for Linux. SCST allows creation of sophisticated
storage devices, which can provide advanced functionality, like replication, thin
provisioning, deduplication, high availability, automatic backup, etc. Majority of
recently developed SAN appliances, especially higher end ones, are SCST based. It might
well be that your favorite storage appliance running SCST in the firmware.

More info about SCST and its modules you can find on: http://scst.sourceforge.net

Thanks to all who made it happen, especially to SanDisk for the great support! All
above highlights development was supported by SanDisk.

Vlad

