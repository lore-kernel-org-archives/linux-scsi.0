From: hadmut@danisch.de (Hadmut Danisch)
Subject: aic79xx and RAID ?
Date: Thu, 1 Dec 2005 11:20:39 +0100
Message-ID: <20051201102039.GA23336@danisch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sklave3.rackland.de ([213.133.101.23]:44261 "EHLO
	sklave3.rackland.de") by vger.kernel.org with ESMTP id S932119AbVLAKUy
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Dec 2005 05:20:54 -0500
Received: from andromeda (uucp@localhost)
	by sklave3.rackland.de (8.13.5/8.13.5/Debian-3) with BSMTP id jB1AKmvS003020
	for linux-scsi@vger.kernel.org; Thu, 1 Dec 2005 11:20:48 +0100
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I have a question about the aic79xx driver and RAID.

A friend of mine tries to install Linux on a IBM rack server machine,
which has two hard disks and a aic 7902 SCSI/RAID controller. 
He has configured both disks as a RAID1 mirror in the BIOS. 

However, when booting Linux (SuSE or Knoppix), the kernel recognizes
the controller and loads the aic79xx driver, but does not recognize
the RAID mirror. Instead it presents both disks as separate disks
/dev/sda and /dev/sdb. 

I could not find any documentation except that which comes with the
kernel (Documentation/scsi/aic79xx.txt), but it doesn't say anything
about RAID. 


Where could I find any hint about how to use RAID disks with aic7902
cards?

regards
Hadmut Danisch
