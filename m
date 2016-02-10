From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] lpfc: Remove redundant code block in lpfc_scsi_cmd_iocb_cmpl
Date: Wed, 10 Feb 2016 12:37:02 -0500
Message-ID: <yq1fux0a2m9.fsf@sermon.lab.mkp.net>
References: <1453302520-10499-1-git-send-email-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1453302520-10499-1-git-send-email-jthumshirn@suse.de> (Johannes
	Thumshirn's message of "Wed, 20 Jan 2016 16:08:40 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Johannes" == Johannes Thumshirn <jthumshirn@suse.de> writes:

Johannes> This removes a redundant code block that will either be
Johannes> executed if the ENABLE_FCP_RING_POLLING flag is set in
Johannes> phba->cfg_poll or not. The code is just duplicated in both
Johannes> cases, hence we unify it again.

James and Dick: Ping!

https://patchwork.kernel.org/patch/8072451/

-- 
Martin K. Petersen	Oracle Linux Engineering
