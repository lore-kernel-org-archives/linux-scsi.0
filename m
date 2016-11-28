From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v2] scsi: aic94xx: Add a missing call to kfree
Date: Mon, 28 Nov 2016 14:48:32 +0100
Message-ID: <bc5d29b1-5004-3a12-432a-4c72bb5edae2@redhat.com>
References: <20161125122351.8226-1-lambert.quentin@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20161125122351.8226-1-lambert.quentin@gmail.com>
Sender: kernel-janitors-owner@vger.kernel.org
To: 20161119174038.20083-1-lambert.quentin@gmail.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Cc: Quentin Lambert <lambert.quentin@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On 25.11.2016 13:23, Quentin Lambert wrote:
> Most error branches following the call to kzalloc contain
> a call to kfree. This patch add these calls where they are
> missing and set the relevant pointers to NULL.
>
> This issue was found with Hector.
>
> Signed-off-by: Quentin Lambert <lambert.quentin@gmail.com>

Looks good,
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
Tomas

