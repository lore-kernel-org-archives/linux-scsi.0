From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 85151] pm80xx + 7805H + HP SAS port expander =
 mpi_smp_completion 2604:smp IO status 0x2 and sas: expander ... discovery
 failed(0xffffffa6)
Date: Sun, 19 Oct 2014 12:17:14 +0000
Message-ID: <bug-85151-11613-6XbYiAN9G6@https.bugzilla.kernel.org/>
References: <bug-85151-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:41571 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868AbaJSMRT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Oct 2014 08:17:19 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id D61462020F
	for <linux-scsi@vger.kernel.org>; Sun, 19 Oct 2014 12:17:17 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 364DC201ED
	for <linux-scsi@vger.kernel.org>; Sun, 19 Oct 2014 12:17:16 +0000 (UTC)
In-Reply-To: <bug-85151-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=85151

--- Comment #15 from linux-ide@crashplan.pro ---
After the patch there are less issues. However only 1 HP SAS expander is usable
on the Adaptec/Pmcs 2280800-R 7805H. 

# uname -a
Linux ubuntu14 3.17.0-031700rc7-generic #201409281835 SMP Sun Sep 28 22:36:30
UTC 2014 x86_64 x86_64 x86_64 GNU/Linux

case #1: Attaching 1 expander to HBA port #1 (closest to bracket) = all 32
drives

# lsscsi -g
[0:0:0:0]    disk    ATA      OCZ-VERTEX       1.3   /dev/sda   /dev/sg0
[4:0:0:0]    disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdb   /dev/sg1
[4:0:1:0]    disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdc   /dev/sg2
[4:0:2:0]    disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdd   /dev/sg3
[4:0:3:0]    disk    ATA      Hitachi HDS5C302 AAB0  /dev/sde   /dev/sg4
[4:0:4:0]    disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdf   /dev/sg5
[4:0:5:0]    disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdg   /dev/sg6
[4:0:6:0]    disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdh   /dev/sg7
[4:0:7:0]    disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdi   /dev/sg8
[4:0:8:0]    disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdj   /dev/sg9
[4:0:9:0]    disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdk   /dev/sg10
[4:0:10:0]   disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdl   /dev/sg11
[4:0:11:0]   disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdm   /dev/sg12
[4:0:12:0]   disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdn   /dev/sg13
[4:0:13:0]   disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdo   /dev/sg14
[4:0:14:0]   disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdp   /dev/sg15
[4:0:15:0]   disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdq   /dev/sg16
[4:0:16:0]   disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdr   /dev/sg17
[4:0:17:0]   disk    ATA      Hitachi HDS5C302 AAB0  /dev/sds   /dev/sg18
[4:0:18:0]   disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdt   /dev/sg19
[4:0:19:0]   disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdu   /dev/sg20
[4:0:20:0]   disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdv   /dev/sg21
[4:0:21:0]   disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdw   /dev/sg22
[4:0:22:0]   disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdx   /dev/sg23
[4:0:23:0]   disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdy   /dev/sg24
[4:0:24:0]   disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdz   /dev/sg25
[4:0:25:0]   disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdaa  /dev/sg26
[4:0:26:0]   disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdab  /dev/sg27
[4:0:27:0]   disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdac  /dev/sg28
[4:0:28:0]   disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdad  /dev/sg29
[4:0:29:0]   disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdae  /dev/sg30
[4:0:30:0]   disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdaf  /dev/sg31
[4:0:31:0]   disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdag  /dev/sg32
[4:0:32:0]   enclosu HP       HP SAS EXP Card  2.10  -          /dev/sg33

case #2: Attaching 1 expander to HBA port #2 = all 32 drives

# lsscsi -g
[0:0:0:0]    disk    ATA      OCZ-VERTEX       1.3   /dev/sda   /dev/sg0
[4:0:0:0]    disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdb   /dev/sg1
[4:0:1:0]    disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdc   /dev/sg2
[4:0:2:0]    disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdd   /dev/sg3
[4:0:3:0]    disk    ATA      Hitachi HDS5C302 AAB0  /dev/sde   /dev/sg4
[4:0:4:0]    disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdf   /dev/sg5
[4:0:5:0]    disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdg   /dev/sg6
[4:0:6:0]    disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdh   /dev/sg7
[4:0:7:0]    disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdi   /dev/sg8
[4:0:8:0]    disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdj   /dev/sg9
[4:0:9:0]    disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdk   /dev/sg10
[4:0:10:0]   disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdl   /dev/sg11
[4:0:11:0]   disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdm   /dev/sg12
[4:0:12:0]   disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdn   /dev/sg13
[4:0:13:0]   disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdo   /dev/sg14
[4:0:14:0]   disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdp   /dev/sg15
[4:0:15:0]   disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdq   /dev/sg16
[4:0:16:0]   disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdr   /dev/sg17
[4:0:17:0]   disk    ATA      Hitachi HDS5C302 AAB0  /dev/sds   /dev/sg18
[4:0:18:0]   disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdt   /dev/sg19
[4:0:19:0]   disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdu   /dev/sg20
[4:0:20:0]   disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdv   /dev/sg21
[4:0:21:0]   disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdw   /dev/sg22
[4:0:22:0]   disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdx   /dev/sg23
[4:0:23:0]   disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdy   /dev/sg24
[4:0:24:0]   disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdz   /dev/sg25
[4:0:25:0]   disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdaa  /dev/sg26
[4:0:26:0]   disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdab  /dev/sg27
[4:0:27:0]   disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdac  /dev/sg28
[4:0:28:0]   disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdad  /dev/sg29
[4:0:29:0]   disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdae  /dev/sg30
[4:0:30:0]   disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdaf  /dev/sg31
[4:0:31:0]   disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdag  /dev/sg32
[4:0:32:0]   enclosu HP       HP SAS EXP Card  2.10  -          /dev/sg33

case #3: Attaching identical expanders to #1 and #2 = first 32 drives of 64
drives (only drives on port #1)

# lsscsi -g
[0:0:0:0]    disk    ATA      OCZ-VERTEX       1.3   /dev/sda   /dev/sg0
[4:0:0:0]    disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdb   /dev/sg1
[4:0:1:0]    disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdc   /dev/sg2
[4:0:2:0]    disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdd   /dev/sg3
[4:0:3:0]    disk    ATA      Hitachi HDS5C302 AAB0  /dev/sde   /dev/sg4
[4:0:4:0]    disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdf   /dev/sg5
[4:0:5:0]    disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdg   /dev/sg6
[4:0:6:0]    disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdh   /dev/sg7
[4:0:7:0]    disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdi   /dev/sg8
[4:0:8:0]    disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdj   /dev/sg9
[4:0:9:0]    disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdk   /dev/sg10
[4:0:10:0]   disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdl   /dev/sg11
[4:0:11:0]   disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdm   /dev/sg12
[4:0:12:0]   disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdn   /dev/sg13
[4:0:13:0]   disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdo   /dev/sg14
[4:0:14:0]   disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdp   /dev/sg15
[4:0:15:0]   disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdq   /dev/sg16
[4:0:16:0]   disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdr   /dev/sg17
[4:0:17:0]   disk    ATA      Hitachi HDS5C302 AAB0  /dev/sds   /dev/sg18
[4:0:18:0]   disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdt   /dev/sg19
[4:0:19:0]   disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdu   /dev/sg20
[4:0:20:0]   disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdv   /dev/sg21
[4:0:21:0]   disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdw   /dev/sg22
[4:0:22:0]   disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdx   /dev/sg23
[4:0:23:0]   disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdy   /dev/sg24
[4:0:24:0]   disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdz   /dev/sg25
[4:0:25:0]   disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdaa  /dev/sg26
[4:0:26:0]   disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdab  /dev/sg27
[4:0:27:0]   disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdac  /dev/sg28
[4:0:28:0]   disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdad  /dev/sg29
[4:0:29:0]   disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdae  /dev/sg30
[4:0:30:0]   disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdaf  /dev/sg31
[4:0:31:0]   disk    ATA      Hitachi HDS5C302 AAB0  /dev/sdag  /dev/sg32
[4:0:32:0]   enclosu HP       HP SAS EXP Card  2.10  -          /dev/sg33
See attachment for full debug dmesg output.

case #4: Attaching 1 expander to HBA port #1, and attaching a second expander
serially (the SFF-8088 port 1C of expander #1 to SFF-8087 port 8C of the second
expander) results in dmesg output result -70 and 0 expanders detected in lsscsi
-g. Dmesg tail:

[  466.935753] pm80xx mpi_smp_completion 2604:smp IO status 0x49
[  466.936112] sas: smp_execute_task: task to dev 5001438023aad066 response:
0x0 status 0x80
[  466.936488] sas: smp_execute_task: task to dev 5001438023aad066 response:
0xffffffff status 0x8a
[  466.936872] sas: smp_execute_task: task to dev 5001438023aad066 response:
0xffffffff status 0x8a
[  466.937211] sas: expander 5001438023aad066 discovery failed(0xffffffba)
[  466.937831] sas: DONE DISCOVERY on port 0, pid:1013, result:-70
[  466.938212] sas: DOING DISCOVERY on port 1, pid:1013
[  466.939344] sas: smp_execute_task: task to dev 5001438023aad066 response:
0xffffffff status 0x8a
[  466.939762] sas: smp_execute_task: task to dev 5001438023aad066 response:
0xffffffff status 0x8a
[  466.940242] sas: smp_execute_task: task to dev 5001438023aad066 response:
0xffffffff status 0x8a
[  466.940648] sas: RG to ex 5001438023aad066 failed:0xffffffba
[  466.941232] sas: DONE DISCOVERY on port 1, pid:1013, result:-70
[  466.941670] sas: DOING DISCOVERY on port 2, pid:1013
[  466.942264] sas: smp_execute_task: task to dev 5001438023aad066 response:
0xffffffff status 0x8a
[  466.942739] sas: smp_execute_task: task to dev 5001438023aad066 response:
0xffffffff status 0x8a
[  466.943221] sas: smp_execute_task: task to dev 5001438023aad066 response:
0xffffffff status 0x8a
[  466.943693] sas: RG to ex 5001438023aad066 failed:0xffffffba
[  466.944256] sas: DONE DISCOVERY on port 2, pid:1013, result:-70
[  466.944777] sas: DOING DISCOVERY on port 3, pid:1013
[  466.945455] sas: smp_execute_task: task to dev 5001438023aad066 response:
0xffffffff status 0x8a
[  466.945996] sas: smp_execute_task: task to dev 5001438023aad066 response:
0xffffffff status 0x8a
[  466.946538] sas: smp_execute_task: task to dev 5001438023aad066 response:
0xffffffff status 0x8a
[  466.947072] sas: RG to ex 5001438023aad066 failed:0xffffffba
[  466.947722] sas: DONE DISCOVERY on port 3, pid:1013, result:-70

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
