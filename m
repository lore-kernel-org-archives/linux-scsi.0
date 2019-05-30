From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: lpfc: Use *_pool_zalloc rather than *_pool_alloc
Date: Wed, 29 May 2019 22:06:28 -0400
Message-ID: <yq1v9xsy9uj.fsf@oracle.com>
References: <1559161113889-196429735-0-diffsplit-thomas@m3y3r.de>
        <1559161113901-1017843021-1-diffsplit-thomas@m3y3r.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1559161113901-1017843021-1-diffsplit-thomas@m3y3r.de> (Thomas
        Meyer's message of "Wed, 29 May 2019 22:21:36 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Meyer <thomas@m3y3r.de>
Cc: james.smart@broadcom.com, dick.kennedy@broadcom.com, jejb@linux.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Thomas,

> Use *_pool_zalloc rather than *_pool_alloc followed by memset with 0.

Applied to 5.3/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
