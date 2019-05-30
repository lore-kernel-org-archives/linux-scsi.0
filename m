From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] message/fusion/mptbase.c: Use kmemdup instead of memcpy and kmalloc
Date: Wed, 29 May 2019 22:33:36 -0400
Message-ID: <yq1tvdcwu0v.fsf@oracle.com>
References: <20190522160149.GA19160@bharath12345-Inspiron-5559>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190522160149.GA19160@bharath12345-Inspiron-5559> (Bharath
        Vedartham's message of "Wed, 22 May 2019 21:31:49 +0530")
Sender: linux-kernel-owner@vger.kernel.org
To: Bharath Vedartham <linux.bhar@gmail.com>
Cc: sathya.prakash@broadcom.com, suganath-prabu.subramani@broadcom.com, joe@perches.com, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Bharath,

> Replace kmalloc + memcpy with kmemdup.

Applied to 5.3/scsi-queue. Thanks.

-- 
Martin K. Petersen	Oracle Linux Engineering
