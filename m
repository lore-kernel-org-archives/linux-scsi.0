From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: [ANNOUNCE]: SCST target driver for QLogic adapters qla_isp 1.0.2
 released
Date: Tue, 27 Oct 2009 16:48:16 +0300
Message-ID: <4AE6FA20.1090609@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:59871 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754353AbZJ0NsX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Oct 2009 09:48:23 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>
Cc: Stanislaw Gruszka <stf_xl@wp.pl>, Matthew Jacob <lydianconcepts@gmail.com>

Hi All,

I'm glad to announce that SCST target driver for QLogic FC adapters
qla_isp version 1.0.2 released and can be downloaded from the SCST
download page, thanks to Stanislaw Gruszka and Matthew Jacob!

This is, most likely, the final release of this driver. Users of it are 
encouraged to migrate on qla2x00t driver.

Summary of changes between versions 1.0.0 and 1.0.2
---------------------------------------------------

- Support for 2532 chipset (8Gb/s).

- Fixed random firmware crash during startup.

- Fixed problem with N_port login.

- Synchronize with mainline Feral repository (various low level fixes).

- Firmware update, (again) add firmware with multichannel support.

- Fixed oops when stopping kernel thread.

- Fixed residual setting for 21xx/22xx/23xx chipsets.

- Fixed WWN setting for cards with scrambled NVRAM.

- Print information about loop state, link speed and topology in human
   readable form.

- Compilation fixes for kernel up to 2.6.32


SCST page of the qla_isp target driver located at
http://scst.sourceforge.net/target_qla_isp.html.

Vlad

