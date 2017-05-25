From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 00/31] SCSI patches for kernel v4.13.
Date: Wed, 24 May 2017 22:04:55 -0400
Message-ID: <yq1o9uhsnco.fsf@oracle.com>
References: <20170524003420.5381-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170524003420.5381-1-bart.vanassche@sandisk.com> (Bart Van
        Assche's message of "Tue, 23 May 2017 17:33:49 -0700")
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Bart,

> This patch series consists of the bug fixes I came up with during the
> past two months. Please consider these patches for kernel v4.13.

No major objections from me. Although you may have to slice and dice the
series differently so we can get the block bits queued through Jens and
then do the rest as a stage 2 merge.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
