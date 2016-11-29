From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] scsi: aic94xx: Add a missing call to kfree
Date: Tue, 29 Nov 2016 11:14:23 -0500
Message-ID: <yq1oa0yp8kg.fsf@sermon.lab.mkp.net>
References: <20161125122351.8226-1-lambert.quentin@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20161125122351.8226-1-lambert.quentin@gmail.com> (Quentin
        Lambert's message of "Fri, 25 Nov 2016 13:23:51 +0100")
Sender: kernel-janitors-owner@vger.kernel.org
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, thenzl@redhat.com, 20161119174038.20083-1-lambert.quentin@gmail.com
List-Id: linux-scsi@vger.kernel.org

>>>>> "Quentin" == Quentin Lambert <lambert.quentin@gmail.com> writes:

Quentin> Most error branches following the call to kzalloc contain a
Quentin> call to kfree. This patch add these calls where they are
Quentin> missing and set the relevant pointers to NULL.

Applied to 4.10/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
