From: "jack wang" <jack_wang@usish.com>
Subject: [RFC][PATCH 0/5]PMC-Sierra PM8001 PCIE 8x6G SAS/SATA HBA driver
Date: Wed, 1 Jul 2009 20:07:30 +0800
Message-ID: <075FEFB270D94EB095D5F7293BE8EE30@usish.com.cn>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from usish.com ([210.5.144.203]:58495 "EHLO sr-smtp.usish.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052AbZGAMVi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Jul 2009 08:21:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, jeff@garzik.org, lindar_liu@usish.com, tom_peng@usish.com, aoqingyun@usish.com, jack_wang@usish.com

The following series implements a driver for a PMC-Sierra PM8001 PCIE 8x6G
SAS/SATA HBA. This driver is base on libsas modules . In the patch set ,
There are two patches for libsas(patch 3 & 4).

This patch series applies on top of scsi-misc-2.6.git tree:
git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git

The driver interfaces with scsi and libsas .

Patch 1) Add pm8001 SAS/SATA HBA driver to scsi Makefile

Patch 2) Add pm8001 SAS/SATA HBA driver to scsi Kconfig

Patch 3) reuse the original port when reenable the phy in a port

Patch 4) fix wide port hotplug issues

Patch 5) Add pm8001 SAS/SATA HBA driver


Thanks for any reviews and comments
Jack Wang

