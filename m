From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v7 0/8] mpt3sas: some bug fixes patches
Date: Tue, 06 Nov 2018 20:45:52 -0500
Message-ID: <yq1o9b13bjj.fsf@oracle.com>
References: <1540992219-20291-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1540992219-20291-1-git-send-email-suganath-prabu.subramani@broadcom.com>
        (Suganath Prabu's message of "Wed, 31 Oct 2018 18:53:31 +0530")
Sender: linux-kernel-owner@vger.kernel.org
To: Suganath Prabu <suganath-prabu.subramani@broadcom.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com
List-Id: linux-scsi@vger.kernel.org


Suganath,

> Suganath Prabu (8):
>   mpt3sas: Added new #define variable IOC_OPERATIONAL_WAIT_COUNT
>   mpt3sas: Separate out mpt3sas_wait_for_ioc
>   mpt3sas: Refactor mpt3sas_wait_for_ioc function
>   mpt3sas: Call sas_remove_host before removing the target devices
>   mpt3sas: Fix Sync cache command failure during driver unload
>   mpt3sas: Don't modify EEDPTagMode field setting on SAS3.5 HBA devices
>   mpt3sas: Fix driver modifying persistent data in Manufacturing page11
>   mpt3sas: Bump driver version to 27.100.00.00.

Applied to 4.21/scsi-queue. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
