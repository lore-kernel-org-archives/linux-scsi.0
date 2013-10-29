From: Markus Blank-Burian <burian@muenster.de>
Subject: arcmsr driver update
Date: Tue, 29 Oct 2013 16:14:57 +0100
Message-ID: <CA+SBX_NroS6+uVT7a3+2Pf6QxHJZ=CfHtq8VeSFftNeq+VpWmw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:47867 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756915Ab3J2PO7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Oct 2013 11:14:59 -0400
Received: by mail-lb0-f175.google.com with SMTP id z5so146189lbh.6
        for <linux-scsi@vger.kernel.org>; Tue, 29 Oct 2013 08:14:57 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Dear all,

two month ago, there was a patch submitted by the company areca
regarding their in-kernel driver:
"[PATCH v1.2 1/1] arcmsr: Support Areca new SATA Raid Adapter
ARC1214/1224/1264/1284"

This patch fixes (among other things) a major bug which forces a
hardware reset on the adapter (1882 in our case, kernel log of error
appended) and is leading to stability issues, but was rejected due to
various reasons. The latest version of their patch works without error
using the 3.10.17 longterm stable kernel, and with it our system seems
to be running stable. Would it be possible to include this patch (or
parts of it) into the linux kernel, so we won't have to worry about
future incompatibilities with new kernel releases?

Best regards,

Markus Blank-Burian


Oct 28 15:39:44 bagheera2 kernel: [11343.946558] arcmsr4: abort device
command of scsi id = 0 lun = 0
Oct 28 15:39:44 bagheera2 kernel: [11343.946572] arcmsr4: abort device
command of scsi id = 0 lun = 0
Oct 28 15:39:44 bagheera2 kernel: [11343.946576] arcmsr4: abort device
command of scsi id = 0 lun = 0
Oct 28 15:39:44 bagheera2 kernel: [11343.946579] arcmsr4: abort device
command of scsi id = 0 lun = 0
Oct 28 15:39:44 bagheera2 kernel: [11343.946581] arcmsr4: abort device
command of scsi id = 0 lun = 0
Oct 28 15:39:44 bagheera2 kernel: [11343.946584] arcmsr4: abort device
command of scsi id = 0 lun = 0
Oct 28 15:39:44 bagheera2 kernel: [11343.946587] arcmsr4: abort device
command of scsi id = 0 lun = 0
Oct 28 15:39:44 bagheera2 kernel: [11343.946590] arcmsr4: abort device
command of scsi id = 0 lun = 0
Oct 28 15:39:44 bagheera2 kernel: [11343.946592] arcmsr4: abort device
command of scsi id = 0 lun = 0
Oct 28 15:39:44 bagheera2 kernel: [11343.946595] arcmsr4: abort device
command of scsi id = 0 lun = 0
Oct 28 15:39:44 bagheera2 kernel: [11343.946597] arcmsr4: abort device
command of scsi id = 0 lun = 0
Oct 28 15:39:44 bagheera2 kernel: [11343.946600] arcmsr4: abort device
command of scsi id = 0 lun = 0
Oct 28 15:39:44 bagheera2 kernel: [11343.946602] arcmsr4: abort device
command of scsi id = 0 lun = 0
Oct 28 15:39:44 bagheera2 kernel: [11343.946605] arcmsr4: abort device
command of scsi id = 0 lun = 0
Oct 28 15:39:44 bagheera2 kernel: [11343.946608] arcmsr4: abort device
command of scsi id = 0 lun = 0
Oct 28 15:39:44 bagheera2 kernel: [11343.946610] arcmsr4: abort device
command of scsi id = 0 lun = 0
Oct 28 15:39:44 bagheera2 kernel: [11343.946613] arcmsr4: abort device
command of scsi id = 0 lun = 0
Oct 28 15:39:44 bagheera2 kernel: [11343.946615] arcmsr4: abort device
command of scsi id = 0 lun = 0
Oct 28 15:39:44 bagheera2 kernel: [11343.946618] arcmsr4: abort device
command of scsi id = 0 lun = 0
Oct 28 15:39:44 bagheera2 kernel: [11343.946621] arcmsr4: abort device
command of scsi id = 0 lun = 0
Oct 28 15:39:44 bagheera2 kernel: [11343.946623] arcmsr4: abort device
command of scsi id = 0 lun = 0
Oct 28 15:39:44 bagheera2 kernel: [11343.946626] arcmsr4: abort device
command of scsi id = 0 lun = 0
Oct 28 15:39:44 bagheera2 kernel: [11343.946628] arcmsr4: abort device
command of scsi id = 0 lun = 0
Oct 28 15:39:44 bagheera2 kernel: [11343.946631] arcmsr4: abort device
command of scsi id = 0 lun = 0
Oct 28 15:39:44 bagheera2 kernel: [11343.946634] arcmsr4: abort device
command of scsi id = 0 lun = 0
Oct 28 15:39:44 bagheera2 kernel: [11343.946636] arcmsr4: abort device
command of scsi id = 0 lun = 0
Oct 28 15:39:44 bagheera2 kernel: [11343.946639] arcmsr4: abort device
command of scsi id = 0 lun = 0
Oct 28 15:39:44 bagheera2 kernel: [11343.946641] arcmsr4: abort device
command of scsi id = 0 lun = 0
Oct 28 15:39:44 bagheera2 kernel: [11343.946644] arcmsr4: abort device
command of scsi id = 0 lun = 0
Oct 28 15:39:44 bagheera2 kernel: [11343.946646] arcmsr4: abort device
command of scsi id = 0 lun = 0
Oct 28 15:39:44 bagheera2 kernel: [11343.946649] arcmsr4: abort device
command of scsi id = 0 lun = 0
Oct 28 15:39:44 bagheera2 kernel: [11343.946652] arcmsr4: abort device
command of scsi id = 0 lun = 0
Oct 28 15:39:44 bagheera2 kernel: [11343.946654] arcmsr4: abort device
command of scsi id = 0 lun = 0
Oct 28 15:39:44 bagheera2 kernel: [11343.946657] arcmsr4: abort device
command of scsi id = 0 lun = 1
Oct 28 15:39:44 bagheera2 kernel: [11343.946659] arcmsr4: abort device
command of scsi id = 0 lun = 1
Oct 28 15:39:44 bagheera2 kernel: [11343.946662] arcmsr4: abort device
command of scsi id = 0 lun = 1
Oct 28 15:39:44 bagheera2 kernel: [11343.946665] arcmsr4: abort device
command of scsi id = 0 lun = 0
Oct 28 15:39:44 bagheera2 kernel: [11343.946667] arcmsr4: abort device
command of scsi id = 0 lun = 0
Oct 28 15:39:44 bagheera2 kernel: [11343.946670] arcmsr4: abort device
command of scsi id = 0 lun = 1
Oct 28 15:39:44 bagheera2 kernel: [11343.946672] arcmsr4: abort device
command of scsi id = 0 lun = 1
Oct 28 15:39:44 bagheera2 kernel: [11343.946675] arcmsr4: abort device
command of scsi id = 0 lun = 1
Oct 28 15:39:44 bagheera2 kernel: [11343.946677] arcmsr4: abort device
command of scsi id = 0 lun = 1
Oct 28 15:39:44 bagheera2 kernel: [11343.956856] arcmsr4: pCCB
='0xffff88040573b880' isr got aborted command
Oct 28 15:39:47 bagheera2 kernel: [11346.571268] arcmsr: executing bus
reset eh.....num_resets = 0, num_aborts = 42
Oct 28 15:39:47 bagheera2 kernel: [11346.571273] arcmsr4: executing hw
bus reset .....
Oct 28 15:41:08 bagheera2 kernel: [11428.250862] Areca RAID
Controller4: F/W V1.51 2012-11-21 & Model ARC-1882
Oct 28 15:41:08 bagheera2 kernel: [11428.261439] arcmsr: scsi bus
reset eh returns with success
