From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: scsi_transport_spi make two const arrays static, shrinks object size
Date: Thu, 15 Feb 2018 18:21:02 -0500
Message-ID: <yq1o9kplu01.fsf@oracle.com>
References: <20180214223543.23237-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180214223543.23237-1-colin.king@canonical.com> (Colin King's
        message of "Wed, 14 Feb 2018 22:35:43 +0000")
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Colin,

> Don't populate the const read-only arrays spi_test_unit_ready and
> spi_test_unit_ready on the stack but instead make them static. Makes the
> object code smaller by over 100 bytes:

Applied to 4.17/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
