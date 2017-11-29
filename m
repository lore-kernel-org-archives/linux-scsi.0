From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: wd719x: make card_types static const, shrinks object size
Date: Wed, 29 Nov 2017 00:12:34 -0500
Message-ID: <yq17eu9hdml.fsf@oracle.com>
References: <20171128181234.24330-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171128181234.24330-1-colin.king@canonical.com> (Colin King's
        message of "Tue, 28 Nov 2017 18:12:34 +0000")
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Colin,

> Don't populate the read-only array card_types on the stack but instead
> make it static and constify it. Makes the object code smaller by over
> 110 bytes:

Applied to 4.16/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
