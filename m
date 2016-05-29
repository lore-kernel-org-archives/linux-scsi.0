From: TomK <tk@mdevsys.com>
Subject: Associate a single backingstore under a single initiator within the
 ACLS list.
Date: Sun, 29 May 2016 11:50:55 -0400
Message-ID: <eed21da3-f660-f86a-60f4-6974db653590@mdevsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.perfora.net ([74.208.4.197]:52411 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932282AbcE2Pu7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 May 2016 11:50:59 -0400
Received: from [192.168.0.32] ([108.168.115.11]) by mrelay.perfora.net
 (mreueus001) with ESMTPSA (Nemesis) id 0M6kp0-1bUMdi0N64-00wX5m for
 <linux-scsi@vger.kernel.org>; Sun, 29 May 2016 17:50:58 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hey All,

New here.  I need different backingstores / LUN's going to different 
initiators.  When creating a LUN under the luns section, it 
automatically get's associated with any initiator created in the ACLS 
list.  But I need only specific single backing stores / LUN's associated 
with single initiators in the ACLS list.  How do I therefore structure 
the create command using mapped_lun and tpg_lun to do so?

/qla2xxx/21:0...81:81:21/acls> cd 21:00:00:1b:32:00:83:b3
/qla2xxx/21:0...b:32:00:83:b3> create
Missing required parameters 'mapped_lun', 'tpg_lun'
/qla2xxx/21:0...b:32:00:83:b3> ls /
o- / ................................................ [...]
   o- backstores ..................................... [...]
   | o- fileio ....................................... [4 Storage Objects]
   | | o- mdsesxip01-d01.img .................................... [2.0T, 
/mnt/HTPCBackupXFS/san-luns-scst/mdsesxip01-d01.img, in use]
   | | o- mdskvmp01-d01.img .................................. [2.0T, 
/mnt/HTPCBackupXFS/san-luns-scst/mdskvmp01-d01.img, not in use]
   | | o- mdskvmp02-d01.img .................................. [2.0T, 
/mnt/HTPCBackupXFS/san-luns-scst/mdskvmp02-d01.img, not in use]
   | | o- mdskvmp03-d01.img .................................. [2.0T, 
/mnt/HTPCBackupXFS/san-luns-scst/mdskvmp03-d01.img, not in use]
   | o- iblock ........................................ [0 Storage Object]
   | o- pscsi ......................................... [0 Storage Object]
   | o- rd_mcp ........................................ [0 Storage Object]
   o- iscsi ........................................... [0 Targets]
   o- loopback ........................................ [0 Targets]
   o- qla2xxx ......................................... [1 Target]
   | o- 21:00:00:1b:32:81:81:21 ....................... [enabled]
   |   o- acls ........................................ [4 ACLs]
   |   | o- 21:00:00:1b:32:00:83:b3 ................... [0 Mapped LUNs]
   |   | o- 21:03:00:1b:32:74:b6:cb ................... [0 Mapped LUNs]
   |   | o- 50:01:43:80:16:77:99:38 ................... [0 Mapped LUNs]
   |   | o- 50:01:43:80:16:77:99:70 ................... [0 Mapped LUNs]
   |   o- luns ........................................ [1 LUN]
   |     o- lun0 .. [fileio/mdsesxip01-d01.img 
(/mnt/HTPCBackupXFS/san-luns-scst/mdsesxip01-d01.img)]
   o- usb_gadget ...................................... [0 Targets]
/qla2xxx/21:0...b:32:00:83:b3>

I get the following on attempts that I make:

Missing required parameters 'mapped_lun', 'tpg_lun'

-- 
Cheers,
Tom K.
-------------------------------------------------------------------------------------

Mobile: 416 618 8456
Home: 905 857 9652
Living on earth is expensive, but it includes a free trip around the sun.

