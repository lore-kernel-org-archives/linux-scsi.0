From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] lpfc: fix build issue if NVME_FC_TARGET is not defined
Date: Wed, 17 May 2017 20:23:31 -0400
Message-ID: <yq1tw4j6mik.fsf@oracle.com>
References: <20170517035229.1145-1-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170517035229.1145-1-jsmart2021@gmail.com> (James Smart's
        message of "Tue, 16 May 2017 20:52:29 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>
Cc: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, sfr@canb.auug.org.au, martin.petersen@oracle.com, linux-kernel@vger.kernel.org, linux-next@vger.kernel.org, hare@suse.com, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>
List-Id: linux-scsi@vger.kernel.org


James,

> fix build issue if NVME_FC_TARGET is not defined. noop the code.
> The code will never be invoked if target mode is not enabled.

Applied to 4.12/scsi-fixes. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
