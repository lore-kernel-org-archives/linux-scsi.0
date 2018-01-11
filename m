From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 00/14] megaraid_sas: driver updates
Date: Wed, 10 Jan 2018 23:21:36 -0500
Message-ID: <yq17espt48f.fsf@oracle.com>
References: <1515158869-26693-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:57162 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753486AbeAKEVl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Jan 2018 23:21:41 -0500
In-Reply-To: <1515158869-26693-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
        (Shivasharan S.'s message of "Fri, 5 Jan 2018 05:27:35 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Cc: linux-scsi@vger.kernel.org, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com


Shivasharan,

> Shivasharan S (14):
>   megaraid_sas: zero out IOC INIT and stream detection memory
>   megaraid_sas: memset IOC INIT frame using correct size
>   megaraid_sas: Return the DCMD status from megasas_get_seq_num
>   megaraid_sas: Reset ldio_outstanding in megasas_resume
>   megaraid_sas: Error handling for invalid ldcount provided by firmware
>     in RAID map
>   megaraid_sas: unload flag should be set after scsi_remove_host is
>     called
>   megaraid_sas: Avoid firing DCMDs while OCR is in progress
>   megaraid_sas: Use megasas_wait_for_adapter_operational to detect
>     controller state in IOCTL path
>   megaraid_sas: Update LD map after populating drv_map driver map copy
>   megaraid_sas: Selectively apply stream detection based on IO type
>   megaraid_sas: Expose fw_cmds_outstanding through sysfs
>   megaraid_sas: re-work DCMD refire code
>   megaraid_sas: NVME passthru command support
>   megaraid_sas: driver version upgrade

Applied to 1-12,14 to 4.16/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
