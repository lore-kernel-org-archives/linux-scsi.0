From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: mvumi: fix warning Using plain integer as NULL pointer
Date: Mon, 08 Apr 2019 21:34:05 -0400
Message-ID: <yq1mul0otbm.fsf@oracle.com>
References: <20190406175331.GA22504@hari-Inspiron-1545>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190406175331.GA22504@hari-Inspiron-1545> (Hariprasad Kelam's
        message of "Sat, 6 Apr 2019 23:23:31 +0530")
Sender: linux-kernel-owner@vger.kernel.org
To: Hariprasad Kelam <hariprasad.kelam@gmail.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Hi Hariprasad,

> Changed "0 to NULL" to avoid below sparse warnings
>
> drivers/scsi/mvumi.c:755:58: warning: Using plain integer as NULL
> pointer
> drivers/scsi/mvumi.c:1797:48: warning: Using plain integer as NULL
> pointer
> drivers/scsi/mvumi.c:2142:50: warning: Using plain integer as NULL
> pointer

This has already been fixed up in 7512ddef6307. In the future, please
make sure to submit patches against my for-next branch.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
