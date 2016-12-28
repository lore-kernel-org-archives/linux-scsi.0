From: IW News <news@imagedworld.com>
Subject: Fwd: Fwd: SAS disk from RAID card (no RAID mode) problems
Date: Wed, 28 Dec 2016 18:16:21 +0100
Message-ID: <0a5c11db-f1cc-53ed-018b-8a0a3069f919@imagedworld.com>
References: <cf8d3da2-12b7-8f36-bca2-503db9ff0fe5@imagedworld.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hathor.lunarpages.com ([74.50.26.40]:54708 "EHLO
        hathor.lunarpages.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751059AbcL1RQY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Dec 2016 12:16:24 -0500
Received: from 171.pool80-103-211.dynamic.orange.es ([80.103.211.171]:47684 helo=[192.168.123.100])
        by hathor.lunarpages.com with esmtpa (Exim 4.87)
        (envelope-from <news@imagedworld.com>)
        id 1cMHpo-003C2e-9g
        for linux-scsi@vger.kernel.org; Wed, 28 Dec 2016 09:16:16 -0800
In-Reply-To: <cf8d3da2-12b7-8f36-bca2-503db9ff0fe5@imagedworld.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi again,

Can anyone point me to another mailing list or Github branch where to 
look for help?
Thank you.

Iñigo.


-------- Forwarded Message --------
Subject: 	SAS disk from RAID card (no RAID mode) problems
Date: 	Fri, 23 Dec 2016 19:59:23 +0100
From: 	IW News <news@imagedworld.com>
To: 	linux-scsi@vger.kernel.org



Hello,

First message here.

After looking for a solution without any luck I have found this list. I
hope someone can help me with this.

I have an ASUS P6T Deluxe with a MARVELL 88SE63xx SAS RAID controller.
There are to identical 400GB SAS SSD drives attached to it. One of them
has a Windows 10 installation, the other one Linux.
Grub is installed on the second disk.

Windows works as expected, but I have problems with the Linux
installation: the desktop environment freezes for some second once in a
while. This occurs with Mint Cinnamon, OpenSuSe KDE, Ubuntu and Manjaro
KDE. All of them are current installations. I'm now working in up to
date Manjaro KDE (kernel 4.9.0).
When the temporary freezes occur the mouse pointer moves, some windows
are updated correctly, other do not and DE stops working.
When this happens always I have a system log like this:

______________________________________________________
23/12/16 8:29    kernel    sas: Enter sas_scsi_recover_host busy: 6
failed: 6
23/12/16 8:29    kernel    sas: trying to find task 0xffff8bda8d2bd900
23/12/16 8:29    kernel    sas: sas_scsi_find_task: aborting task
0xffff8bda8d2bd900
23/12/16 8:29    kernel    sas: task done but aborted
23/12/16 8:29    kernel    sas: sas_scsi_find_task: task
0xffff8bda8d2bd900 is done
23/12/16 8:29    kernel    sas: sas_eh_handle_sas_errors: task
0xffff8bda8d2bd900 is done
23/12/16 8:29    kernel    sas: trying to find task 0xffff8bda8d2bce00
23/12/16 8:29    kernel    sas: sas_scsi_find_task: aborting task
0xffff8bda8d2bce00
23/12/16 8:29    kernel    sas: task done but aborted
23/12/16 8:29    kernel    sas: sas_scsi_find_task: task
0xffff8bda8d2bce00 is done
23/12/16 8:29    kernel    sas: sas_eh_handle_sas_errors: task
0xffff8bda8d2bce00 is done
23/12/16 8:29    kernel    sas: trying to find task 0xffff8bda8d2bd700
23/12/16 8:29    kernel    sas: sas_scsi_find_task: aborting task
0xffff8bda8d2bd700
23/12/16 8:29    kernel    sas: task done but aborted
23/12/16 8:29    kernel    sas: sas_scsi_find_task: task
0xffff8bda8d2bd700 is done
23/12/16 8:29    kernel    sas: sas_eh_handle_sas_errors: task
0xffff8bda8d2bd700 is done
23/12/16 8:29    kernel    sas: trying to find task 0xffff8bda8d2bde00
23/12/16 8:29    kernel    sas: sas_scsi_find_task: aborting task
0xffff8bda8d2bde00
23/12/16 8:29    kernel    sas: task done but aborted
23/12/16 8:29    kernel    sas: sas_scsi_find_task: task
0xffff8bda8d2bde00 is done
23/12/16 8:29    kernel    sas: sas_eh_handle_sas_errors: task
0xffff8bda8d2bde00 is done
23/12/16 8:29    kernel    sas: trying to find task 0xffff8bda8d2bdc00
23/12/16 8:29    kernel    sas: sas_scsi_find_task: aborting task
0xffff8bda8d2bdc00
23/12/16 8:29    kernel    sas: task done but aborted
23/12/16 8:29    kernel    sas: sas_scsi_find_task: task
0xffff8bda8d2bdc00 is done
23/12/16 8:29    kernel    sas: sas_eh_handle_sas_errors: task
0xffff8bda8d2bdc00 is done
23/12/16 8:29    kernel    sas: trying to find task 0xffff8bdcb0298800
23/12/16 8:29    kernel    sas: sas_scsi_find_task: aborting task
0xffff8bdcb0298800
23/12/16 8:29    kernel    sas: task done but aborted
23/12/16 8:29    kernel    sas: sas_scsi_find_task: task
0xffff8bdcb0298800 is done
23/12/16 8:29    kernel    sas: sas_eh_handle_sas_errors: task
0xffff8bdcb0298800 is done
23/12/16 8:29    kernel    sas: --- Exit sas_scsi_recover_host: busy: 0
failed: 6 tries: 1
23/12/16 8:29    kernel    drivers/scsi/mvsas/mv_sas.c 1694:reuse same
slot, retry command.
23/12/16 8:29    kernel    drivers/scsi/mvsas/mv_sas.c 1694:reuse same
slot, retry command.
23/12/16 8:29    kernel    drivers/scsi/mvsas/mv_sas.c 1694:reuse same
slot, retry command.
23/12/16 8:29    kernel    sas: Enter sas_scsi_recover_host busy: 2
failed: 2
23/12/16 8:29    kernel    sas: trying to find task 0xffff8bdb9453ae00
23/12/16 8:29    kernel    sas: sas_scsi_find_task: aborting task
0xffff8bdb9453ae00
23/12/16 8:29    kernel    sas: task done but aborted
23/12/16 8:29    kernel    sas: sas_scsi_find_task: task
0xffff8bdb9453ae00 is done
23/12/16 8:29    kernel    sas: sas_eh_handle_sas_errors: task
0xffff8bdb9453ae00 is done
23/12/16 8:29    kernel    sas: trying to find task 0xffff8bdb9453b000
23/12/16 8:29    kernel    sas: sas_scsi_find_task: aborting task
0xffff8bdb9453b000
23/12/16 8:29    kernel    sas: task done but aborted
23/12/16 8:29    kernel    sas: sas_scsi_find_task: task
0xffff8bdb9453b000 is done
23/12/16 8:29    kernel    sas: sas_eh_handle_sas_errors: task
0xffff8bdb9453b000 is done
23/12/16 8:29    kernel    sas: --- Exit sas_scsi_recover_host: busy: 0
failed: 2 tries: 1
__________________________________________________________________________________________


Sometimes shorter sometimes larger.
It looks like a controller/drive/cable problem?
Any thoughts?

Thanks in advance.

