From: =?iso-8859-2?Q?Hor=E1k_Daniel?= <horak@sitmp.cz>
Subject: Compaq RA4x00 logical volumes not detected in kernel 2.6
Date: Wed, 15 Jun 2005 14:10:35 +0200
Message-ID: <66EFFC1A2B0A424E87D68EC10B1F458D6597C1@EXCH2.plzen-city.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fred2.plzen-city.cz ([195.113.166.14]:28584 "EHLO
	fred2.plzen-city.cz") by vger.kernel.org with ESMTP id S261382AbVFOMKi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Jun 2005 08:10:38 -0400
Received: from exch2.plzen-city.cz ([192.168.4.51])
	by fred2.plzen-city.cz (8.11.7/8.11.7/Wim) with ESMTP id j5FCAZq30756
	for <linux-scsi@vger.kernel.org>; Wed, 15 Jun 2005 14:10:35 +0200
Content-Class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

I have a problem with detecting logical volumes on Compaq Raid Array
4x00 which is connected to my server via Emulex LP8000 Fibre Channel
card and FC hub. System is CentOS 4 with kernel 2.6.9 (=RHEL4 clone)

I get the following messagen in syslog

scsi8 : Emulex LightPulse LP8000 1 Gigabit PCI Fibre Channel Adapter on
PCI bus 04 device 20 irq 5 
scsi: unknown device type 12 
Vendor: COMPAQ Model: ARRAY CONTROLLER Rev: 2.54 
Type: RAID ANSI SCSI revision: 00 
scsi: unknown device type 12 
Vendor: COMPAQ Model: ARRAY CONTROLLER Rev: 2.60 
Type: RAID ANSI SCSI revision: 00 

The result of discussion in lpfc forum is that there should be a problem
the scanning part of SCSI layer.

The detected devices should look like the folling output (these messages
are from the same system booted into RHEL3 clone (Whitebox, kernel 2.4)
with the arrays attached via Compaq FC card).

 kernel: Starting timer : 0 0
 kernel:   Vendor: COMPAQ    Model: LOGICAL VOLUME    Rev: 2.60
 kernel:   Type:   Direct-Access                      ANSI SCSI
revision: 02
 kernel: Starting timer : 0 0
 kernel:   Vendor: COMPAQ    Model: LOGICAL VOLUME    Rev: 2.60
 kernel:   Type:   Direct-Access                      ANSI SCSI
revision: 02
 kernel: Starting timer : 0 0
 kernel:   Vendor: COMPAQ    Model: LOGICAL VOLUME    Rev: 2.54
 kernel:   Type:   Direct-Access                      ANSI SCSI
revision: 02
 kernel: Starting timer : 0 0
 kernel: Attached scsi disk sda at scsi2, channel 0, id 0, lun 0
 kernel: Attached scsi disk sdb at scsi2, channel 0, id 0, lun 1
 kernel: Attached scsi disk sdc at scsi2, channel 0, id 1, lun 0


		Thank you
			Dan Horak
