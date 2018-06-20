From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH v2] scsi: cxlflash: Change return type for fault handler
Date: Wed, 20 Jun 2018 15:12:37 -0500
Message-ID: <20180620201237.GA19354@p8tul1-build.aus.stglabs.ibm.com>
References: <20180620182507.GA21775@jordon-HP-15-Notebook-PC>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180620182507.GA21775@jordon-HP-15-Notebook-PC>
Sender: linux-kernel-owner@vger.kernel.org
To: Souptick Joarder <jrdr.linux@gmail.com>
Cc: willy@infradead.org, manoj@linux.vnet.ibm.com, ukrishn@linux.vnet.ibm.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Jun 20, 2018 at 11:55:07PM +0530, Souptick Joarder wrote:
> Use new return type vm_fault_t for fault handler. For
> now, this is just documenting that the function returns
> a VM_FAULT value rather than an errno. Once all instances
> are converted, vm_fault_t will become a distinct type.
> 
> Ref-> commit 1c8f422059ae ("mm: change return type to vm_fault_t")
> 
> Previously, VM_FAULT_NOPAGE was returned without verifying
> return value of vm_insert_pfn. The new inline vmf_insert_pfn()
> will address this issue by returning correct VM_FAULT_* type
> from fault handler.
> 
> Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>

Looks good.

Acked-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
