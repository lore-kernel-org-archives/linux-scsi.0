From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: [ANNOUNCE]: SCST target driver for QLocic 24xx adapters qla_isp 1.0.1
 released
Date: Mon, 13 Jul 2009 15:55:27 +0400
Message-ID: <4A5B20AF.80205@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:63518 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755497AbZGMLzZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2009 07:55:25 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>
Cc: Stanislaw Gruszka <stf_xl@wp.pl>, Matthew Jacob <lydianconcepts@gmail.com>

Hi All,

I'm glad to announce that SCST target driver for QLogic 24xx adapters 
qla_isp version 1.0.1 released and can be downloaded from the SCST 
download page, thanks to Stanislaw Gruszka and Matthew Jacob!

Summary of changes between versions 1.0.0 and 1.0.1
---------------------------------------------------

- Rewritten DMA mappings code.

- Fixed resources leakage when disabling target during pending I/O 
operations.

- Fixed 64 bit Type 3 request breakage.

- Recovery from not being able to push CTIO fix.

- Various task management fixes.

- Fixed OOPS when firmware provide bad VPIDX number.

- Fixed 24xx startup problems.

- In driver firmware images update.

- Various compilation fixes for different gcc and Linux kernel versions.

SCST page of the qla_isp target driver located at 
http://scst.sourceforge.net/target_qla_isp.html.

Vlad
