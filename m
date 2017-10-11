From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 05/10] mpt3sas: Fix IO error occurs on pulling out a drive
 from RAID1 volume created on two SATA drive
Date: Wed, 11 Oct 2017 17:37:42 +0200
Message-ID: <80dc6c6d-1d8a-8c60-b2e8-637a8cd997db@redhat.com>
References: <1507641083-20207-1-git-send-email-Sreekanth.Reddy@broadcom.com>
 <1507641083-20207-6-git-send-email-Sreekanth.Reddy@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1507641083-20207-6-git-send-email-Sreekanth.Reddy@broadcom.com>
Content-Language: en-MW
Sender: linux-kernel-owner@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@broadcom.com>, linux-scsi@vger.kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, Sathya.Prakash@broadcom.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 10/10/2017 03:11 PM, Sreekanth Reddy wrote:
> Whenever IO for raid volume fails with IOCStatus
>  "MPI2_IOCSTATUS_SCSI_IOC_TERMINATED"and SCSIStatus equal to
>  "(MPI2_SCSI_STATE_TERMINATED | MPI2_SCSI_STATE_NO_SCSI_STATUS)"
>  then return the IO to SML with "DID_RESET"
>  (i.e. retry the IO infinite times) host bytes.
>
> Earlier driver is returning the IO with "DID_SOFT_ERROR"
>  that reties the IO quickly for five times but still
>  firmware needed some more time and hence IOs were failing.
>
> Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@broadcom.com>

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
Tomas
