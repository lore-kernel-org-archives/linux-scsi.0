From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [RESEND] scsi: mvsas: fix misleading indentation
Date: Mon, 30 Nov 2015 20:55:59 -0500
Message-ID: <yq1oaebdj9s.fsf@sermon.lab.mkp.net>
References: <1448893937-5252-1-git-send-email-luisbg@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1448893937-5252-1-git-send-email-luisbg@osg.samsung.com> (Luis
	de Bethencourt's message of "Mon, 30 Nov 2015 14:32:17 +0000")
Sender: linux-kernel-owner@vger.kernel.org
To: Luis de Bethencourt <luisbg@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org, vinholikatti@gmail.com, JBottomley@odin.com, jthumshirn@suse.de, linux-scsi@vger.kernel.org, akpm@linux-foundation.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Luis" == Luis de Bethencourt <luisbg@osg.samsung.com> writes:

Luis> Fix a smatch warning: drivers/scsi/mvsas/mv_sas.c:740
Luis> mvs_task_prep() warn: curly braces intended?

Luis> The code is correct, the indention is misleading. When the device
Luis> is not ready we want to return SAS_PHY_DOWN. But current
Luis> indentation makes it look like we only do so in the else branch of
Luis> if (mvi_dev).

Applied to 4.5/scsi-queue.

Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
