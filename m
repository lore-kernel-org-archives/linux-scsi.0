From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 00/14] megaraid_sas: Updates for scsi-next
Date: Wed, 23 Aug 2017 23:19:33 -0400
Message-ID: <yq18ti9abzu.fsf@oracle.com>
References: <1503488828-2242-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:30941 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751112AbdHXDUb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Aug 2017 23:20:31 -0400
In-Reply-To: <1503488828-2242-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
        (Shivasharan S.'s message of "Wed, 23 Aug 2017 04:46:54 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, hch@lst.de


Shivasharan,

> Shivasharan S (14):
>   megaraid_sas: mismatch of allocated MFI frame size and length exposed
>     in MFI MPT pass through command
>   megaraid_sas: set minimum value of resetwaittime to be 1 secs
>   megaraid_sas: Use synchronize_irq in target reset case
>   megaraid_sas: Call megasas_complete_cmd_dpc_fusion every 1 second
>     while there are pending commands
>   megaraid_sas: Do not re-fire shutdown DCMD after OCR
>   megaraid_sas: Fix endianness issues in DCMD handling
>   megaraid_sas: Check valid aen class range to avoid kernel panic
>   megaraid_sas: Use SMID for Task abort case only
>   megaraid_sas: use vmalloc for crash dump buffers and driver's local
>     RAID map
>   megaraid_sas: Return pended IOCTLs with cmd_status
>     MFI_STAT_WRONG_STATE in case adapter is dead
>   megaraid_sas: replace internal FALSE/TRUE definitions with false/true
>   megaraid_sas: modified few prints in OCR and IOC INIT path
>   megaraid_sas: call megasas_dump_frame with correct IO frame size
>   megaraid_sas: driver version upgrade

Applied to 4.14/scsi-queue. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
