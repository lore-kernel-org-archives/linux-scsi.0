From: =?iso-8859-1?Q?Gon=E7alo_Rosa?= <goncalo.rosa@gmail.com>
Subject: CentOS 6.5 tgtadm LUN ID set doesn't work
Date: Tue, 16 Sep 2014 14:30:29 -0500
Message-ID: <000601cfd1e4$ad659ca0$0830d5e0$@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qg0-f54.google.com ([209.85.192.54]:55765 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754840AbaIPTac convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Sep 2014 15:30:32 -0400
Received: by mail-qg0-f54.google.com with SMTP id z60so448966qgd.41
        for <linux-scsi@vger.kernel.org>; Tue, 16 Sep 2014 12:30:31 -0700 (PDT)
Received: from LPTV2SCOPGCR01 ([181.48.132.106])
        by mx.google.com with ESMTPSA id e48sm6831651yhe.27.2014.09.16.12.30.30
        for <linux-scsi@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 16 Sep 2014 12:30:30 -0700 (PDT)
Content-Language: en-us
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Hello,

I did the following procedure:
tgtadm =96lld iscsi =96mode target =96op new =96tid 1 =96targetname
iqn.2014-09.local.vclass:tg0
tgtadm =96lld iscsi =96op new =96mode logicalunit =96tid 1 =96lun 1 =96=
backing-store
/dev/sdg
tgtadm =96lld iscsi =96op new =96mode logicalunit =96tid 1 =96lun 2 =96=
backing-store
/dev/sdh
tgtadm =96lld iscsi =96op new =96mode logicalunit =96tid 1 =96lun 3 =96=
backing-store
/dev/sdi
tgtadm =96lld iscsi =96op new =96mode logicalunit =96tid 1 =96lun 4 =96=
backing-store
/dev/sdj
tgtadm =96lld iscsi =96mode target =96op new =96tid 2 =96targetname
iqn.2014-09.local.vclass:tg1
tgtadm =96lld iscsi =96mode target =96op new =96tid 3 =96targetname
iqn.2014-09.local.vclass:tg2
tgtadm =96lld iscsi =96op new =96mode logicalunit =96tid 2 =96lun 5 =96=
backing-store
/dev/sde
tgtadm =96lld iscsi =96op new =96mode logicalunit =96tid 3 =96lun 5 =96=
backing-store
/dev/sdf
tgtadm =96lld iscsi =96op bind =96mode target =96tid 2 =96initiator-add=
ress
172.20.10.61
tgtadm =96lld iscsi =96op bind =96mode target =96tid 3 =96initiator-add=
ress
172.20.10.62
tgtadm =96mode target =96op show
tgt-admin =96dump > /etc/tgt/targets.conf

and the tgtadm =96mode target =96op show output was as shown bellow:
[root@iscsi ~]# tgtadm =96mode target =96op show
Target 1: iqn.2014-09.local.vclass:tg0
System information:
Driver: iscsi
State: ready
I_T nexus information:
LUN information:
LUN: 0
Type: controller
SCSI ID: IET 00010000
SCSI SN: beaf10
Size: 0 MB, Block size: 1
Online: Yes
Removable media: No
Prevent removal: No
Readonly: No
Backing store type: null
Backing store path: None
Backing store flags:
LUN: 1
Type: disk
SCSI ID: IET 00010001
SCSI SN: beaf11
Size: 10737 MB, Block size: 512
Online: Yes
Removable media: No
Prevent removal: No
Readonly: No
Backing store type: rdwr
Backing store path: /dev/sdg
Backing store flags:
LUN: 2
Type: disk
SCSI ID: IET 00010002
SCSI SN: beaf12
Size: 10737 MB, Block size: 512
Online: Yes
Removable media: No
Prevent removal: No
Readonly: No
Backing store type: rdwr
Backing store path: /dev/sdh
Backing store flags:
LUN: 3
Type: disk
SCSI ID: IET 00010003
SCSI SN: beaf13
Size: 10737 MB, Block size: 512
Online: Yes
Removable media: No
Prevent removal: No
Readonly: No
Backing store type: rdwr
Backing store path: /dev/sdi
Backing store flags:
LUN: 4
Type: disk
SCSI ID: IET 00010004
SCSI SN: beaf14
Size: 10737 MB, Block size: 512
Online: Yes
Removable media: No
Prevent removal: No
Readonly: No
Backing store type: rdwr
Backing store path: /dev/sdj
Backing store flags:
Account information:
ACL information:
Target 2: iqn.2014-09.local.vclass:tg1
System information:
Driver: iscsi
State: ready
I_T nexus information:
LUN information:
LUN: 0
Type: controller
SCSI ID: IET 00020000
SCSI SN: beaf20
Size: 0 MB, Block size: 1
Online: Yes
Removable media: No
Prevent removal: No
Readonly: No
Backing store type: null
Backing store path: None
Backing store flags:
LUN: 5
Type: disk
SCSI ID: IET 00020005
SCSI SN: beaf25
Size: 10737 MB, Block size: 512
Online: Yes
Removable media: No
Prevent removal: No
Readonly: No
Backing store type: rdwr
Backing store path: /dev/sde
Backing store flags:
Account information:
ACL information:
172.20.10.61
Target 3: iqn.2014-09.local.vclass:tg2
System information:
Driver: iscsi
State: ready
I_T nexus information:
LUN information:
LUN: 0
Type: controller
SCSI ID: IET 00030000
SCSI SN: beaf30
Size: 0 MB, Block size: 1
Online: Yes
Removable media: No
Prevent removal: No
Readonly: No
Backing store type: null
Backing store path: None
Backing store flags:
LUN: 5
Type: disk
SCSI ID: IET 00030005
SCSI SN: beaf35
Size: 10737 MB, Block size: 512
Online: Yes
Removable media: No
Prevent removal: No
Readonly: No
Backing store type: rdwr
Backing store path: /dev/sdf
Backing store flags:
Account information:
ACL information:
172.20.10.62

My intention is that all LUN IDs should be different per host, so tg0 w=
ill
serves shared LUNs 1,2,3 and 4 and tg1 serves LUN 5 to host 172.20.10.6=
1 and
tg2 serves LUN 5 to host 172.20.10.62. I am using CentOS 6.5
After reboot tg1 and tg2 presents the LUNs both with LUN ID 1.
Also added LUN 5 to both targets in /etc/tgt/targets.conf and after reb=
oot
ignores the instruction and still presents with LUN ID 1.

/etc/tgt/targets.conf bellow:

Default-driver iscsi

backing-store /dev/sdf
LUN 5
initiator-address 172.20.10.62

backing-store /dev/sde
LUN 5
initiator-address 172.20.10.61

backing-store /dev/sdg
backing-store /dev/sdh
backing-store /dev/sdi
backing-store /dev/sdj

Please, can anyone be so kind and help me to fix the LUN IDs?

Thank you in advance.

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
