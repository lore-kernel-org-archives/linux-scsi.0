From: Andrew Morton <akpm@digeo.com>
Subject: aix7xxx_old woes in 2.5
Date: Sat, 14 Dec 2002 20:36:25 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DFC06C9.19AFADE2@digeo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from digeo-nav01.digeo.com (digeo-nav01.digeo.com [192.168.1.233])
	by packet.digeo.com (8.9.3+Sun/8.9.3) with SMTP id UAA24937
	for <linux-scsi@vger.kernel.org>; Sat, 14 Dec 2002 20:36:25 -0800 (PST)
Received: from digeo-e2k04.digeo.com ([192.168.2.24])
 by digeo-nav01.digeo.com (NAVGW 2.5.2.12) with SMTP id M2002121420382204008
 for <linux-scsi@vger.kernel.org>; Sat, 14 Dec 2002 20:38:22 -0800
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


ho hum.

It just doesn't start at all:

scsi HBA driver <NULL> didn't set max_sectors, please fix the template<6>(scsi0) <Adaptec AIC-7892 Ultra 160/m SCSI host adapter> found at PCI 3/4/0
(scsi0) Wide Channel, SCSI ID=7, 32/255 SCBs
(scsi0) Downloading sequencer code... 396 instructions downloaded
(scsi1) <Adaptec AIC-7880 Ultra SCSI host adapter> found at PCI 0/10/0
(scsi1) Wide Channel, SCSI ID=7, 16/255 SCBs
(scsi1) Downloading sequencer code... 436 instructions downloaded
scsi0 : Adaptec AHA274x/284x/294x (EISA/VLB/PCI-Fast SCSI) 5.2.6/5.2.0
       <Adaptec AIC-7892 Ultra 160/m SCSI host adapter>
scsi: Device offlined - not ready or command retry failed after error recovery: host 0 channel 0 id 0 lun 0
scsi: Device offlined - not ready or command retry failed after error recovery: host 0 channel 0 id 1 lun 0
scsi: Device offlined - not ready or command retry failed after error recovery: host 0 channel 0 id 2 lun 0
scsi: Device offlined - not ready or command retry failed after error recovery: host 0 channel 0 id 3 lun 0
scsi: Device offlined - not ready or command retry failed after error recovery: host 0 channel 0 id 4 lun 0
scsi: Device offlined - not ready or command retry failed after error recovery: host 0 channel 0 id 5 lun 0
scsi: Device offlined - not ready or command retry failed after error recovery: host 0 channel 0 id 6 lun 0
scsi: Device offlined - not ready or command retry failed after error recovery: host 0 channel 0 id 8 lun 0

(The above took three minutes or more)


Note that I have set the machine's BIOS up to not run external BIOSes, so the
Adaptec firmware is not being used.  Reboot times are unacceptable otherwise.

This doesn't seem to offend the 2.4 aic7xxx driver, nor the 2.5 aic7xxx 75%
of the time...
