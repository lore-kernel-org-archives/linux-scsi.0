From: Ted Ede <ted@ede.com>
Subject: Adaptec 2120S not being recognized by aacraid
Date: Mon, 17 Oct 2005 08:01:36 -0400
Message-ID: <435392A0.7080405@ede.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gator18.hostgator.com ([70.85.214.66]:8155 "EHLO
	gator18.hostgator.com") by vger.kernel.org with ESMTP
	id S932287AbVJQMBM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Oct 2005 08:01:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I'm not sure if this is the proper place to post this, so if I should be 
asking elsewhere, a pointer would be appreciated.

Summary:
scanpci shows the card on the PCI bus, but the kernel does not recognize it.

Details:

I'm booting off of a standard serail-ata drive and trying to configure a 
2120S with four scsi drives as a RAID10 device for some performance testing.

I was able to create a RAID10 array using the on-card bios.  Each boot, 
the array is listed and its status is "Optimal"

I've got a Tyan Thunder K8WE S2895 rev 1.0 with two dual-core Opterons.
I'm running Centos 4.2 with kernel 2.6.9-22ELsmp.  I downloaded the 
1.1.5.2400 version of the aacraid driver from adaptec and 
built/installed it using dkms.

It appears to be part of the part of the kernel, but this is the only 
message I get upon boot:
[root@localhost tmp]# dmesg | grep -i aac
Adaptec aacraid driver (1.1-5 Oct 16 2005 19:29:08)

scanpci includes:
pci bus 0x000a cardnum 0x09 function 0x00: vendor 0x9005 device 0x0285
  Adaptec AAC-RAID
scanpci shows nothing else on pci bus 0x000a.

"scanpci -O" and lspci reveal nothing.  which leads me to believe the 
kernel is not recognizing it.

Any thoughts or next debugging steps would be greatly appreciated.

ted




