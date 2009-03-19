From: "Andy Yan" <ayan@marvell.com>
Subject: [PATCH 0/3] mvsas updated for 88SE64xx and 88SE94xx
Date: Thu, 19 Mar 2009 01:49:14 -0700
Message-ID: <FE3F06125A99254E8D92161AA4569C6F0693DCE5@sc-exch02.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host2.marvell.com ([65.219.4.2]:23979 "EHLO maili.marvell.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752964AbZCSItR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Mar 2009 04:49:17 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, jeff@garzik.org, Tejun Heo <tj@kernel.org>
Cc: linux-scsi@vger.kernel.org, Michael Wang <qswang@marvell.com>, Jacky Feng <jfeng@marvell.com>, Ying Chu <jasonchu@marvell.com>, Ke Wei <kewei@marvell.com>

Greetings all,
	Here are updated mvsas driver with bugfixes and new features.
This version contains following main changes
  - Switch to new layout to support more types of ASIC.
  - SSP TMF supported and related Error Handing enhanced.
  - Support flash feature with delay 2*HZ when PHY changed.
  - Support Marvell 94xx series ASIC for 6G SAS/SATA, which has 2
88SE64xx chips but any different register description.
  - Support SPI flash for HBA-related configuration info.
  - Other patch enhanced from kernel side such as increasing PHY type
detection wait time. (http://lkml.org/lkml/2009/1/15/502)

The first patch is to update the Makefile and Kconfig for layout change.
The second patch is to add the code for common use with ASICs.
The thirst patch is to add the code for ASIC specific function and const
value.
The subjects of all patches are 
[PATCH 1/3] Layout changes for new mvsas
[PATCH 2/3] Common code for init and runtime
[PATCH 3/3] ASIC specific
