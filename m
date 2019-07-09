From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [GIT PULL] first round of SCSI updates for the 5.2+ merge window
Date: Tue, 09 Jul 2019 15:39:16 -0400
Message-ID: <yq1lfx7c80r.fsf@oracle.com>
References: <1562699693.3362.93.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1562699693.3362.93.camel@HansenPartnership.com> (James
        Bottomley's message of "Tue, 09 Jul 2019 12:14:53 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


James,

> This is mostly update of the usual drivers: qla2xxx, hpsa, lpfc, ufs,
> mpt3sas, ibmvscsi, megaraid_sas, bnx2fc and hisi_sas as well as the
> removal of the osst driver (I heard from Willem privately that he would
> like the driver removed because all his test hardware has
> failed).  Plus number of minor changes, spelling fixes and other
> trivia.

Looks like you forgot to pull in the scatterlist topic branch.

-- 
Martin K. Petersen	Oracle Linux Engineering
