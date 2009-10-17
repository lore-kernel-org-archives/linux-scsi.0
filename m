From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13783] udev causes high cpu usage
Date: Sat, 17 Oct 2009 04:01:17 GMT
Message-ID: <200910170401.n9H41HpL025419@demeter.kernel.org>
References: <bug-13783-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:48515 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698AbZJQEBM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 17 Oct 2009 00:01:12 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9H41H0t025420
	for <linux-scsi@vger.kernel.org>; Sat, 17 Oct 2009 04:01:17 GMT
In-Reply-To: <bug-13783-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=13783


Wendall Cada <wendallc@83864.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |wendallc@83864.com




--- Comment #16 from Wendall Cada <wendallc@83864.com>  2009-10-17 04:01:15 ---
I have the same issue. I have the exact results as detailed in Comment #8
(Here is the data on my hardware. (Please let me know if any additional
debugging information is required.)

Fedora Core 11

Linux version 2.6.30.8-64.fc11.i686.PAE (mockbuild@x86-6.fedora.phx.redhat.com)
(gcc version 4.4.1 20090725 (Red Hat 4.4.1-2) (GCC) ) #1 SMP

Output from hal-disable-polling --device /dev/sr0
Polling for drive /dev/sr0 have been disabled. The fdi file written was
 
/etc/hal/fdi/information/media-check-disable-storage_model_DVD_RW_AD_7560S.fdi

Partial output from devkit -m
action=change @ 19:46:30.318587
device:          
/sys/devices/pci0000:00/0000:00:1f.2/host1/target1:0:0/1:0:0:0/block/sr0
  subsystem:      block
  device file:    /dev/sr0
    symlink:      /dev/block/11:0
    symlink:      /dev/scd0
    symlink:      /dev/disk/by-path/pci-0000:00:1f.2-scsi-1:0:0:0
    symlink:      /dev/cdrom
    symlink:      /dev/cdrw
    symlink:      /dev/dvd
    symlink:      /dev/dvdrw
  properties:
    ID_VENDOR_ENC=Optiarc\x20
    UDEV_LOG=3
    ID_CDROM_MRW=1
    ACL_CDROM=1
    ID_MODEL=DVD_RW_AD-7560S
    ID_TYPE=cd
    ID_CDROM=1
    ID_CDROM_DVD_RAM=1
    ID_PATH=pci-0000:00:1f.2-scsi-1:0:0:0
    DEVTYPE=disk
    ID_VENDOR=Optiarc
    SEQNUM=89215
    DEVNAME=/dev/sr0
    ACTION=change
    ID_CDROM_DVD=1
   
DEVPATH=/devices/pci0000:00/0000:00:1f.2/host1/target1:0:0/1:0:0:0/block/sr0
    ID_CDROM_CD_R=1
    ID_BUS=scsi
    ID_CDROM_DVD_R=1
    MAJOR=11
    SUBSYSTEM=block
    ID_MODEL_ENC=DVD\x20RW\x20AD-7560S\x20
    ID_CDROM_MRW_W=1
    ID_CDROM_CD_RW=1
    GENERATED=1
    DEVLINKS=/dev/block/11:0 /dev/scd0
/dev/disk/by-path/pci-0000:00:1f.2-scsi-1:0:0:0 /dev/cdrom /dev/cdrw /dev/dvd
/dev/dvdrw
    MINOR=0
    ID_REVISION=S805

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
