From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: libfc: fix ELS request handling
Date: Tue, 28 Nov 2017 23:59:37 -0500
Message-ID: <yq1o9nlhe86.fsf@oracle.com>
References: <20171125183810.20035-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171125183810.20035-1-mwilck@suse.com> (Martin Wilck's message
        of "Sat, 25 Nov 2017 19:38:10 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Martin Wilck <mwilck@suse.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Martin Wilck <mwilck@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, Chad Dupuis <chad.dupuis@cavium.com>
List-Id: linux-scsi@vger.kernel.org


Martin,

> The modification of fc_lport_recv_els_req() in commit fcabb09e59a7
> (merged in 4.12-rc1) caused certain requests not to be handled at all.
> Fix that.

Applied to 4.15/scsi-fixes. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
