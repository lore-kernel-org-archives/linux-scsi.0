From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] drivers/scsi/fnic/fnic_trace.c: Use vzalloc
Date: Fri, 07 Dec 2018 21:29:46 -0500
Message-ID: <yq17egkoin9.fsf@oracle.com>
References: <5bec5342.1c69fb81.b02fa.ace9@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5bec5342.1c69fb81.b02fa.ace9@mx.google.com> (Sabyasachi Gupta's
        message of "Wed, 14 Nov 2018 22:24:21 +0530")
Sender: linux-kernel-owner@vger.kernel.org
To: Sabyasachi Gupta <sabyasachi.linux@gmail.com>
Cc: satishkh@cisco.com, sebaddel@cisco.com, kartilak@cisco.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, jrdr.linux@gmail.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, brajeswar.linux@gmail.com
List-Id: linux-scsi@vger.kernel.org


Sabyasachi,

> Replaced vmalloc + memset with vzalloc

Applied to 4.21/scsi-queue, thanks.

-- 
Martin K. Petersen	Oracle Linux Engineering
