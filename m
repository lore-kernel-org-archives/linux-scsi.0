From: Kumba <kumba@gentoo.org>
Subject: PCI Resource Collisions & qla1280
Date: Sat, 15 Oct 2005 02:45:43 -0400
Message-ID: <4350A597.1070304@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sccrmhc11.comcast.net ([204.127.202.55]:46556 "EHLO
	sccrmhc11.comcast.net") by vger.kernel.org with ESMTP
	id S1751093AbVJOGpv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 15 Oct 2005 02:45:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Anyone got any tips on debugging a cranky SCSI adapter that's not getting 
initialized due to resource collisions?  e.g.,

qla1280: QLA1040 found on PCI bus 0, dev 0
PCI: Device 0000:00:00.0 not available because of resource collisions
qla1280: Failed to enabled pci device, aborting.
qla1280: QLA1040 found on PCI bus 0, dev 1
PCI: Device 0000:00:01.0 not available because of resource collisions
qla1280: Failed to enabled pci device, aborting.


This happens on 2.6.13.4 on an SGI Origin (IP27).  2.6.12.5 seems to have better 
luck; actually seeing the drives/partitions, but gets stuck on something (unsure 
what), then issues several adapter/bus resets and either oopses or continues on 
normally.  Rather than focus on 2.6.12.5's oddities, though, I figured better to 
take a stab at 2.6.13.4.  Unsure if it's entirely mips-specific (probably is), 
but I can't seem to find any changes in git that would immediately stand out as 
being the cause.


--Kumba

-- 
Gentoo/MIPS Team Lead
Gentoo Foundation Board of Trustees

"Such is oft the course of deeds that move the wheels of the world: small hands 
do them because they must, while the eyes of the great are elsewhere."  --Elrond
