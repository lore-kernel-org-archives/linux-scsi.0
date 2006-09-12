From: "english" <english@ms1.dhps.ylc.edu.tw>
Subject: booting linux from a SAS drive attached to aic94xx
Date: Tue, 12 Sep 2006 20:25:03 +0800
Message-ID: <20060912122418.M37772@ms1.dhps.ylc.edu.tw>
References: <20060911034952.M44911@ms1.dhps.ylc.edu.tw> <4504FAD4.1040700@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=big5
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms1.dhps.ylc.edu.tw ([163.27.227.1]:48270 "EHLO
	ms1.dhps.ylc.edu.tw") by vger.kernel.org with ESMTP id S932302AbWILMCY
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Sep 2006 08:02:24 -0400
Received: from ms1.dhps.ylc.edu.tw (ms1 [127.0.0.1])
	by ms1.dhps.ylc.edu.tw (Postfix) with ESMTP id 7B34B126D210
	for <linux-scsi@vger.kernel.org>; Tue, 12 Sep 2006 20:25:03 +0800 (CST)
In-Reply-To: <4504FAD4.1040700@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello everyone,

First, i would like to thank Darrick Wong for pointing me to the sequencer code
for the AIC94xx. Thanks to him, i was able to get my SAS drives to work. 

Currently, my boot partition is located on an IDE drive. The aic94xx loads
successfully because the kernel has no problem detecting the IDE drive.
However, i would like to boot linux from the SAS drive that is attached to the
adaptec controller. 

I tried building the aic94xx as a part of the kernel. During the boot process,
there is an error stating that the firmware cannot be loaded (error -2). 

I also tried including the aic94xx module and the firmware on an external
initrd image. The kernel panic right after the ramdisk fails to load. I
suspect it is because the initrd image is located on the SAS drive which is
inaccessible at the moment.

If anyone knows a simple way to enable to boot linux from a SAS drive attached
to the adaptec SAS controller, please tell me.

Thanks in advance,

Mingjui Liao

--
Open WebMail Project (http://openwebmail.org)

