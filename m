From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: tcmu: Simplify 'tcmu_update_uio_info()'
Date: Tue, 18 Jun 2019 21:10:40 -0400
Message-ID: <yq1blyuxtv3.fsf@oracle.com>
References: <20190616070220.24189-1-christophe.jaillet@wanadoo.fr>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190616070220.24189-1-christophe.jaillet@wanadoo.fr>
        (Christophe JAILLET's message of "Sun, 16 Jun 2019 09:02:20 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Christophe,

> Use 'kasprintf()' instead of:
>    - snprintf(NULL, 0...
>    - kmalloc(...
>    - snprintf(...
>
> This is less verbose and saves 7 bytes (i.e. the space for '/(null)') if
> 'udev->dev_config' is NULL.

Applied to 5.3/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
