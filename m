From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: aic7xxx: remove really aiclib.c
Date: Tue, 30 Jan 2018 21:51:52 -0500
Message-ID: <yq17eryg2pj.fsf@oracle.com>
References: <1517124234-23425-1-git-send-email-clabbe@baylibre.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1517124234-23425-1-git-send-email-clabbe@baylibre.com> (Corentin
        Labbe's message of "Sun, 28 Jan 2018 07:23:54 +0000")
Sender: linux-kernel-owner@vger.kernel.org
To: Corentin Labbe <clabbe@baylibre.com>
Cc: hare@suse.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Corentin,

> aiclib.c is unused (and contain no code) since commit 1ff927306e08
> ("[SCSI] aic7xxx: remove aiclib.c")
> 13 years later, finish the cleaning by remove it from tree.

Applied to 4.16/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
