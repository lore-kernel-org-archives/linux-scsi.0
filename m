From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: pmcraid: Add missing resource releases
Date: Tue, 22 Nov 2016 17:03:16 -0500
Message-ID: <yq1mvgrw4t7.fsf@sermon.lab.mkp.net>
References: <20161119174318.20394-1-lambert.quentin@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161119174318.20394-1-lambert.quentin@gmail.com> (Quentin
        Lambert's message of "Sat, 19 Nov 2016 18:43:18 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Quentin Lambert <lambert.quentin@gmail.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Quentin" == Quentin Lambert <lambert.quentin@gmail.com> writes:

Quentin> Most error branches following the call to pmcraid_get_free_cmd
Quentin> contain a call to pmcraid_return_cmd. This patch add these
Quentin> calls where they are missing.

Quentin> Moreover, most error branches following the call to
Quentin> class_create contain a call to class_destroy. This patch add
Quentin> these calls where they are missing.

Applied to 4.10/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
