From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 00/19] megaraid_sas: Updates for scsi-next
Date: Mon, 23 Oct 2017 04:26:55 -0400
Message-ID: <yq1h8uql168.fsf@oracle.com>
References: <1508406546-25944-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41847 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751121AbdJWI1A (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Oct 2017 04:27:00 -0400
In-Reply-To: <1508406546-25944-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
        (Shivasharan S.'s message of "Thu, 19 Oct 2017 02:48:47 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Cc: linux-scsi@vger.kernel.org, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com


Shivasharan,

>   megaraid_sas: use adapter_type for all gen controllers
>   megaraid_sas: Add support for Crusader controllers
>   megaraid_sas: replace instance->ctrl_context checks with
>     instance->adapter_type
>   megaraid_sas: Remove redundant checks for ctrl_context
>   megaraid_sas: replace is_ventura with adapter_type checks
>   megaraid_sas: reduce size of fusion_context and use kmalloc for
>     allocation
>   megaraid_sas: Create separate functions to allocate ctrl memory
>   megaraid_sas: Create separate functions for allocating and freeing
>     controller DMA buffers
>   megaraid_sas: Pre-allocate frequently used DMA buffers
>   megaraid_sas: remove instance->ctrl_info
>   megaraid_sas: Move initialization of instance parameters inside newly
>     created function megasas_init_ctrl_params
>   megaraid_sas: Move controller memory allocations and DMA mask settings
>     from probe to megasas_init_fw
>   megaraid_sas: Update current host time to FW during IOC Init
>   megaraid_sas: Resize MFA frame used for IOC INIT to 4k
>   megaraid_sas: Incorrect processing of IOCTL frames for SMP/STP
>     commands
>   megaraid_sas: Retry with reduced queue depth when alloc fails for
>     higher QD
>   megaraid_sas: Do not limit queue_depth to 1k in non-RDPQ mode
>   megaraid_sas: Add support for 64bit consistent DMA
>   megaraid_sas: driver version upgrade

Nice cleanup in general. Applied to 4.15/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
