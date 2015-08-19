From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 101891] mvsas prep failed, NULL pointer dereference in
 mvs_slot_task_free+0x5/0x1f0 [mvsas]
Date: Wed, 19 Aug 2015 22:09:10 +0000
Message-ID: <bug-101891-11613-4lSqshUjyR@https.bugzilla.kernel.org/>
References: <bug-101891-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:58195 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406AbbHSWJP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Aug 2015 18:09:15 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 6022A20552
	for <linux-scsi@vger.kernel.org>; Wed, 19 Aug 2015 22:09:13 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id A05B220864
	for <linux-scsi@vger.kernel.org>; Wed, 19 Aug 2015 22:09:10 +0000 (UTC)
In-Reply-To: <bug-101891-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D101891

--- Comment #5 from D=C4=81vis <davispuh@gmail.com> ---
Success, patch indeed fixed it :)

Now instead of crash I get this =E2=86=93, but everything seems to be w=
orking and no
need for reboot.

kernel: mvsas 0000:07:00.0: mvsas prep failed[0]!
kernel: mvsas 0000:07:00.0: mvsas prep failed[0]!
kernel: mvsas 0000:07:00.0: mvsas prep failed[0]!
kernel: mvsas 0000:07:00.0: mvsas prep failed[0]!
kernel: mvsas 0000:07:00.0: mvsas prep failed[0]!
kernel: mvsas 0000:07:00.0: mvsas prep failed[0]!
kernel: mvsas 0000:07:00.0: mvsas prep failed[0]!
kernel: mvsas 0000:07:00.0: mvsas prep failed[0]!
kernel: mvsas 0000:07:00.0: mvsas prep failed[0]!
kernel: mvsas 0000:07:00.0: mvsas prep failed[0]!
kernel: mvsas 0000:07:00.0: mvsas prep failed[0]!
kernel: mvsas 0000:07:00.0: mvsas prep failed[0]!
kernel: mvsas 0000:07:00.0: mvsas prep failed[0]!
kernel: mvsas 0000:07:00.0: mvsas prep failed[0]!
kernel: mvsas 0000:07:00.0: mvsas prep failed[0]!
kernel: mvsas 0000:07:00.0: mvsas prep failed[0]!
kernel: mvsas 0000:07:00.0: mvsas prep failed[0]!
kernel: mvsas 0000:07:00.0: mvsas prep failed[0]!
kernel: mvsas 0000:07:00.0: mvsas prep failed[0]!
kernel: sas: Enter sas_scsi_recover_host busy: 19 failed: 19
kernel: sas: trying to find task 0xffff8801c9599100
kernel: sas: sas_scsi_find_task: aborting task 0xffff8801c9599100
kernel: sas: sas_scsi_find_task: task 0xffff8801c9599100 is aborted
kernel: sas: sas_eh_handle_sas_errors: task 0xffff8801c9599100 is abort=
ed
kernel: sas: trying to find task 0xffff8801c9599500
kernel: sas: sas_scsi_find_task: aborting task 0xffff8801c9599500
kernel: sas: sas_scsi_find_task: task 0xffff8801c9599500 is aborted
kernel: sas: sas_eh_handle_sas_errors: task 0xffff8801c9599500 is abort=
ed
kernel: sas: trying to find task 0xffff8801c9599900
kernel: sas: sas_scsi_find_task: aborting task 0xffff8801c9599900
kernel: sas: sas_scsi_find_task: task 0xffff8801c9599900 is aborted
kernel: sas: sas_eh_handle_sas_errors: task 0xffff8801c9599900 is abort=
ed
kernel: sas: trying to find task 0xffff8801ba22a500
kernel: sas: sas_scsi_find_task: aborting task 0xffff8801ba22a500
kernel: sas: sas_scsi_find_task: task 0xffff8801ba22a500 is aborted
kernel: sas: sas_eh_handle_sas_errors: task 0xffff8801ba22a500 is abort=
ed
kernel: sas: trying to find task 0xffff88000f686300
kernel: sas: sas_scsi_find_task: aborting task 0xffff88000f686300
kernel: sas: sas_scsi_find_task: task 0xffff88000f686300 is aborted
kernel: sas: sas_eh_handle_sas_errors: task 0xffff88000f686300 is abort=
ed
kernel: sas: trying to find task 0xffff88000f687f00
kernel: sas: sas_scsi_find_task: aborting task 0xffff88000f687f00
kernel: sas: sas_scsi_find_task: task 0xffff88000f687f00 is aborted
kernel: sas: sas_eh_handle_sas_errors: task 0xffff88000f687f00 is abort=
ed
kernel: sas: trying to find task 0xffff88000f687c00
kernel: sas: sas_scsi_find_task: aborting task 0xffff88000f687c00
kernel: sas: sas_scsi_find_task: task 0xffff88000f687c00 is aborted
kernel: sas: sas_eh_handle_sas_errors: task 0xffff88000f687c00 is abort=
ed
kernel: sas: trying to find task 0xffff88000f686e00
kernel: sas: sas_scsi_find_task: aborting task 0xffff88000f686e00
kernel: sas: sas_scsi_find_task: task 0xffff88000f686e00 is aborted
kernel: sas: sas_eh_handle_sas_errors: task 0xffff88000f686e00 is abort=
ed
kernel: sas: trying to find task 0xffff88000f686a00
kernel: sas: sas_scsi_find_task: aborting task 0xffff88000f686a00
kernel: sas: sas_scsi_find_task: task 0xffff88000f686a00 is aborted
kernel: sas: sas_eh_handle_sas_errors: task 0xffff88000f686a00 is abort=
ed
kernel: sas: trying to find task 0xffff88000f687d00
kernel: sas: sas_scsi_find_task: aborting task 0xffff88000f687d00
kernel: sas: sas_scsi_find_task: task 0xffff88000f687d00 is aborted
kernel: sas: sas_eh_handle_sas_errors: task 0xffff88000f687d00 is abort=
ed
kernel: sas: trying to find task 0xffff88000f686f00
kernel: sas: sas_scsi_find_task: aborting task 0xffff88000f686f00
kernel: sas: sas_scsi_find_task: task 0xffff88000f686f00 is aborted
kernel: sas: sas_eh_handle_sas_errors: task 0xffff88000f686f00 is abort=
ed
kernel: sas: trying to find task 0xffff88000f687500
kernel: sas: sas_scsi_find_task: aborting task 0xffff88000f687500
kernel: sas: sas_scsi_find_task: task 0xffff88000f687500 is aborted
kernel: sas: sas_eh_handle_sas_errors: task 0xffff88000f687500 is abort=
ed
kernel: sas: trying to find task 0xffff88000f687000
kernel: sas: sas_scsi_find_task: aborting task 0xffff88000f687000
kernel: sas: sas_scsi_find_task: task 0xffff88000f687000 is aborted
kernel: sas: sas_eh_handle_sas_errors: task 0xffff88000f687000 is abort=
ed
kernel: sas: trying to find task 0xffff8800024f1900
kernel: sas: sas_scsi_find_task: aborting task 0xffff8800024f1900
kernel: sas: sas_scsi_find_task: task 0xffff8800024f1900 is aborted
kernel: sas: sas_eh_handle_sas_errors: task 0xffff8800024f1900 is abort=
ed
kernel: sas: trying to find task 0xffff8800024f0d00
kernel: sas: sas_scsi_find_task: aborting task 0xffff8800024f0d00
kernel: sas: sas_scsi_find_task: task 0xffff8800024f0d00 is aborted
kernel: sas: sas_eh_handle_sas_errors: task 0xffff8800024f0d00 is abort=
ed
kernel: sas: trying to find task 0xffff88007c8ec600
kernel: sas: sas_scsi_find_task: aborting task 0xffff88007c8ec600
kernel: sas: sas_scsi_find_task: task 0xffff88007c8ec600 is aborted
kernel: sas: sas_eh_handle_sas_errors: task 0xffff88007c8ec600 is abort=
ed
kernel: sas: trying to find task 0xffff88007c8ecf00
kernel: sas: sas_scsi_find_task: aborting task 0xffff88007c8ecf00
kernel: sas: sas_scsi_find_task: task 0xffff88007c8ecf00 is aborted
kernel: sas: sas_eh_handle_sas_errors: task 0xffff88007c8ecf00 is abort=
ed
kernel: sas: trying to find task 0xffff88007c8ec700
kernel: sas: sas_scsi_find_task: aborting task 0xffff88007c8ec700
kernel: sas: sas_scsi_find_task: task 0xffff88007c8ec700 is aborted
kernel: sas: sas_eh_handle_sas_errors: task 0xffff88007c8ec700 is abort=
ed
kernel: sas: trying to find task 0xffff880079672700
kernel: sas: sas_scsi_find_task: aborting task 0xffff880079672700
kernel: sas: sas_scsi_find_task: task 0xffff880079672700 is aborted
kernel: sas: sas_eh_handle_sas_errors: task 0xffff880079672700 is abort=
ed
kernel: sas: ata11: end_device-5:6: cmd error handler
kernel: sas: ata12: end_device-5:7: cmd error handler
kernel: sas: ata5: end_device-5:0: dev error handler
kernel: sas: ata6: end_device-5:1: dev error handler
kernel: sas: ata7: end_device-5:2: dev error handler
kernel: sas: ata8: end_device-5:3: dev error handler
kernel: sas: ata9: end_device-5:4: dev error handler
kernel: sas: ata10: end_device-5:5: dev error handler
kernel: sas: ata11: end_device-5:6: dev error handler
kernel: ata11.00: exception Emask 0x0 SAct 0x3fff78 SErr 0x0 action 0x6=
 frozen
kernel: sas: ata12: end_device-5:7: dev error handler
kernel: ata12.00: exception Emask 0x0 SAct 0x100 SErr 0x0 action 0x6 fr=
ozen
kernel: ata11.00: failed command: READ FPDMA QUEUED
kernel: ata11.00: cmd 60/10:00:70:5b:78/00:00:12:00:00/40 tag 3 ncq 819=
2 in
                                           res
40/00:00:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
kernel: ata11.00: status: { DRDY }
kernel: ata11.00: failed command: READ FPDMA QUEUED
kernel: ata11.00: cmd 60/10:00:60:72:78/00:00:12:00:00/40 tag 4 ncq 819=
2 in
                                           res
40/00:ff:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
kernel: ata11.00: status: { DRDY }
kernel: ata11.00: failed command: READ FPDMA QUEUED
kernel: ata11.00: cmd 60/10:00:10:b9:78/00:00:12:00:00/40 tag 5 ncq 819=
2 in
                                           res
40/00:00:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
kernel: ata11.00: status: { DRDY }
kernel: ata11.00: failed command: READ FPDMA QUEUED
kernel: ata11.00: cmd 60/20:00:48:bb:78/00:00:12:00:00/40 tag 6 ncq 163=
84 in
                                           res
40/00:0c:b8:5e:aa/00:00:0e:00:00/40 Emask 0x4 (timeout)
kernel: ata11.00: status: { DRDY }
kernel: ata11.00: failed command: READ FPDMA QUEUED
kernel: ata11.00: cmd 60/20:00:10:d6:79/00:00:12:00:00/40 tag 8 ncq 163=
84 in
                                           res
40/00:ff:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
kernel: ata11.00: status: { DRDY }
kernel: ata11.00: failed command: READ FPDMA QUEUED
kernel: ata11.00: cmd 60/20:00:f0:ed:79/00:00:12:00:00/40 tag 9 ncq 163=
84 in
                                           res
40/00:ff:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
kernel: ata11.00: status: { DRDY }
kernel: ata11.00: failed command: READ FPDMA QUEUED
kernel: ata11.00: cmd 60/10:00:e0:2f:7a/00:00:12:00:00/40 tag 10 ncq 81=
92 in
                                           res
40/00:ff:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
kernel: ata11.00: status: { DRDY }
kernel: ata11.00: failed command: READ FPDMA QUEUED
kernel: ata11.00: cmd 60/10:00:e8:8e:7a/00:00:12:00:00/40 tag 11 ncq 81=
92 in
                                           res
40/00:00:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
kernel: ata11.00: status: { DRDY }
kernel: ata11.00: failed command: READ FPDMA QUEUED
kernel: ata11.00: cmd 60/10:00:a0:a8:7a/00:00:12:00:00/40 tag 12 ncq 81=
92 in
                                           res
40/00:ff:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
kernel: ata11.00: status: { DRDY }
kernel: ata11.00: failed command: READ FPDMA QUEUED
kernel: ata11.00: cmd 60/10:00:20:e8:7a/00:00:12:00:00/40 tag 13 ncq 81=
92 in
                                           res
40/00:ff:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
kernel: ata11.00: status: { DRDY }
kernel: ata11.00: failed command: READ FPDMA QUEUED
kernel: ata11.00: cmd 60/10:00:b0:12:7c/00:00:12:00:00/40 tag 14 ncq 81=
92 in
                                           res
40/00:ff:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
kernel: ata11.00: status: { DRDY }
kernel: ata11.00: failed command: READ FPDMA QUEUED
kernel: ata11.00: cmd 60/10:00:50:26:7c/00:00:12:00:00/40 tag 15 ncq 81=
92 in
                                           res
40/00:ff:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
kernel: ata11.00: status: { DRDY }
kernel: ata11.00: failed command: READ FPDMA QUEUED
kernel: ata11.00: cmd 60/10:00:a8:d2:7c/00:00:12:00:00/40 tag 16 ncq 81=
92 in
                                           res
40/00:ff:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
kernel: ata11.00: status: { DRDY }
kernel: ata11.00: failed command: READ FPDMA QUEUED
kernel: ata11.00: cmd 60/10:00:c0:ec:7c/00:00:12:00:00/40 tag 17 ncq 81=
92 in
                                           res
40/00:ff:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
kernel: ata11.00: status: { DRDY }
kernel: ata11.00: failed command: READ FPDMA QUEUED
kernel: ata11.00: cmd 60/08:00:98:6f:70/00:00:12:00:00/40 tag 18 ncq 40=
96 in
                                           res
40/00:64:b8:7e:aa/00:00:0e:00:00/40 Emask 0x4 (timeout)
kernel: ata11.00: status: { DRDY }
kernel: ata11.00: failed command: READ FPDMA QUEUED
kernel: ata11.00: cmd 60/08:00:b8:3c:73/00:00:12:00:00/40 tag 19 ncq 40=
96 in
                                           res
40/00:70:a0:40:8e/00:00:29:01:00/40 Emask 0x4 (timeout)
kernel: ata11.00: status: { DRDY }
kernel: ata11.00: failed command: READ FPDMA QUEUED
kernel: ata11.00: cmd 60/08:00:68:57:73/00:00:12:00:00/40 tag 20 ncq 40=
96 in
                                           res
40/00:00:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
kernel: ata11.00: status: { DRDY }
kernel: ata11.00: failed command: READ FPDMA QUEUED
kernel: ata11.00: cmd 60/08:00:f8:89:73/00:00:12:00:00/40 tag 21 ncq 40=
96 in
                                           res
40/00:ff:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
kernel: ata11.00: status: { DRDY }
kernel: ata11: hard resetting link
kernel: ata12.00: failed command: WRITE FPDMA QUEUED
kernel: ata12.00: cmd 61/c0:00:40:33:50/00:00:0d:00:00/40 tag 8 ncq 983=
04 out
                                           res
40/00:00:00:4f:c2/00:00:00:00:00/40 Emask 0x4 (timeout)
kernel: ata12.00: status: { DRDY }
kernel: ata12: hard resetting link
kernel: sas: sas_form_port: phy2 belongs to port6 already(1)!
kernel: sas: sas_form_port: phy3 belongs to port7 already(1)!
kernel: /mnt/linux/drivers/scsi/mvsas/mv_sas.c 1439:mvs_I_T_nexus_reset=
 for
kernel: /mnt/linux/drivers/scsi/mvsas/mv_sas.c 1439:mvs_I_T_nexus_reset=
 for
kernel: ata12.00: configured for UDMA/133
kernel: ata12.00: device reported invalid CHS sector 0
kernel: ata12: EH complete
kernel: ata11.00: configured for UDMA/133
kernel: ata11.00: device reported invalid CHS sector 0
kernel: ata11.00: device reported invalid CHS sector 0
kernel: ata11.00: device reported invalid CHS sector 0
kernel: ata11.00: device reported invalid CHS sector 0
kernel: ata11.00: device reported invalid CHS sector 0
kernel: ata11.00: device reported invalid CHS sector 0
kernel: ata11.00: device reported invalid CHS sector 0
kernel: ata11.00: device reported invalid CHS sector 0
kernel: ata11.00: device reported invalid CHS sector 0
kernel: ata11.00: device reported invalid CHS sector 0
kernel: ata11.00: device reported invalid CHS sector 0
kernel: ata11.00: device reported invalid CHS sector 0
kernel: ata11.00: device reported invalid CHS sector 0
kernel: ata11.00: device reported invalid CHS sector 0
kernel: ata11.00: device reported invalid CHS sector 0
kernel: ata11: EH complete
kernel: sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 tries: 1

--=20
You are receiving this mail because:
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
