From: "jack_wang" <jack_wang@usish.com>
Subject: Re: Re: mvsas errors in 2.6.36
Date: Sat, 4 Dec 2010 20:33:38 +0800
Message-ID: <201012042033380623575@usish.com>
References: <201010290650.32892.thomas@fjellstrom.ca>,
 <4CF95394.7010400@redhat.com>,
 <201012041550372348573@usish.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: thomas <thomas@fjellstrom.ca>
Cc: David Milburn <dmilburn@redhat.com>, Andre Tomt <andre@tomt.net>, Linux Kernel List <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


Here is what I get with that returning 0 rather than -1 as you requested:
[19107.040031] sas: command 0xffff88011c77f9c0, task 0xffff88022ae51600, timed out: BLK_EH_NOT_HANDLED
[19107.040062] sas: Enter sas_scsi_recover_host
[19107.040072] sas: trying to find task 0xffff88022ae51600
[19107.040079] sas: sas_scsi_find_task: aborting task 0xffff88022ae51600
[19107.040089] drivers/scsi/mvsas/mv_sas.c 1703:<7>mv_abort_task() mvi=ffff880224040000 task=ffff88022ae51600 slot=ffff880224066680 slot_idx=x4
[19107.040101] sas: sas_scsi_find_task: task 0xffff88022ae51600 is aborted
[19107.040107] sas: sas_eh_handle_sas_errors: task 0xffff88022ae51600 is aborted
[19107.040113] sas: sas_ata_task_done: SAS error 8d
[19107.040124] ata21: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
[19107.040860] ata21: status=0x01 { Error }
[19107.040866] ata21: error=0x04 { DriveStatusError }
[19107.040886] sas: --- Exit sas_scsi_recover_host
[19318.000085] sas: command 0xffff8801250291c0, task 0xffff88018a8e5b80, timed out: BLK_EH_NOT_HANDLED
[19318.000125] sas: Enter sas_scsi_recover_host
[19318.000135] sas: trying to find task 0xffff88018a8e5b80
[19318.000141] sas: sas_scsi_find_task: aborting task 0xffff88018a8e5b80
[19318.000152] drivers/scsi/mvsas/mv_sas.c 1703:<7>mv_abort_task() mvi=ffff880224040000 task=ffff88018a8e5b80 slot=ffff8802240666d8 slot_idx=x5
[19318.000163] sas: sas_scsi_find_task: task 0xffff88018a8e5b80 is aborted
[19318.000169] sas: sas_eh_handle_sas_errors: task 0xffff88018a8e5b80 is aborted
[19318.000175] sas: sas_ata_task_done: SAS error 8d
[19318.000185] ata24: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
[19318.000896] ata24: status=0x01 { Error }
[19318.000902] ata24: error=0x04 { DriveStatusError }
[19318.000922] sas: --- Exit sas_scsi_recover_host



[Jack] Do all the drives discoverd? There are still commands timeout, maybe the disks need more time to response, or something
wrong with the driver, I'm not sure.
