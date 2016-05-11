From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 1/6] mpt3sas: Update MPI header to 2.00.42
Date: Wed, 11 May 2016 15:59:20 +0200
Message-ID: <57333AB8.2020808@redhat.com>
References: <1462525171-6877-1-git-send-email-chaitra.basappa@broadcom.com>
 <1462525171-6877-2-git-send-email-chaitra.basappa@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1462525171-6877-2-git-send-email-chaitra.basappa@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chaitra P B <chaitra.basappa@broadcom.com>, jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@broadcom.com, suganath-prabu.subramani@broadcom.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 6.5.2016 10:59, Chaitra P B wrote:
> Updated MPI version and MPI header files.
>
> ChangeList:
> * Added SATADeviceWaitTime to SAS IO Unit Page 4
> * Added EEDPObservedValue added to SCSI IO Reply message
> * Added MPI2_EVENT_ACTIVE_CABLE_EXCEPTION and
>   MPI26_EVENT_DATA_ACTIVE_CABLE_EXCEPT
>
> Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas
