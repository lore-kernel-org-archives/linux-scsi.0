From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 01/10] mpt3sas: Processing of Cable Exception events
Date: Wed, 11 Oct 2017 17:17:06 +0200
Message-ID: <83a5efbd-88f4-01bc-13eb-1bf0a638ed58@redhat.com>
References: <1507641083-20207-1-git-send-email-Sreekanth.Reddy@broadcom.com>
 <1507641083-20207-2-git-send-email-Sreekanth.Reddy@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1507641083-20207-2-git-send-email-Sreekanth.Reddy@broadcom.com>
Content-Language: en-MW
Sender: linux-kernel-owner@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@broadcom.com>, linux-scsi@vger.kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, JBottomley@Parallels.com, Sathya.Prakash@broadcom.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 10/10/2017 03:11 PM, Sreekanth Reddy wrote:
> Earlier Active Cable Exception event with reason code
> "Cable Degraded (0x02))" was added only for Active Cable,
> Now this event is extended to Passive cable too.
> So re-arranged display message accordingly.
>
> Also added Cable Exception Event even for SAS3008 & SAS3108 HBAs
> (i.e. MPI 2.5 spec supporting HBAs) earlier this event was
> enabled only for MPI 2.6 spec supporting HBA devices.
>
> Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@broadcom.com>

Signed-off-by: Tomas Henzl <thenzl@redhat.com>

Tomas
