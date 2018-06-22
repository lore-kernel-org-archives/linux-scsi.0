From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] scsi: cxlflash: Change return type for fault handler
Date: Thu, 21 Jun 2018 22:58:28 -0400
Message-ID: <yq1o9g3a5nv.fsf@oracle.com>
References: <20180620182507.GA21775@jordon-HP-15-Notebook-PC>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180620182507.GA21775@jordon-HP-15-Notebook-PC> (Souptick
        Joarder's message of "Wed, 20 Jun 2018 23:55:07 +0530")
Sender: linux-kernel-owner@vger.kernel.org
To: Souptick Joarder <jrdr.linux@gmail.com>
Cc: willy@infradead.org, manoj@linux.vnet.ibm.com, mrochs@linux.vnet.ibm.com, ukrishn@linux.vnet.ibm.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Souptick,

> Use new return type vm_fault_t for fault handler. For
> now, this is just documenting that the function returns
> a VM_FAULT value rather than an errno. Once all instances
> are converted, vm_fault_t will become a distinct type.

Applied to 4.19/scsi-queue, thanks.

-- 
Martin K. Petersen	Oracle Linux Engineering
