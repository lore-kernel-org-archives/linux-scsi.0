From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH] scsi: cxlflash: Change return type for fault handler
Date: Wed, 13 Jun 2018 18:23:47 -0500
Message-ID: <20180613232347.GA3851@p8tul1-build.aus.stglabs.ibm.com>
References: <20180611194204.GA18687@jordon-HP-15-Notebook-PC>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180611194204.GA18687@jordon-HP-15-Notebook-PC>
Sender: linux-kernel-owner@vger.kernel.org
To: Souptick Joarder <jrdr.linux@gmail.com>
Cc: willy@infradead.org, manoj@linux.vnet.ibm.com, ukrishn@linux.vnet.ibm.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, sabyasachi.linux@gmail.com, brajeswar.linux@gmail.com
List-Id: linux-scsi@vger.kernel.org

On Tue, Jun 12, 2018 at 01:12:04AM +0530, Souptick Joarder wrote:
> Use new return type vm_fault_t for fault handler. For
> now, this is just documenting that the function returns
> a VM_FAULT value rather than an errno. Once all instances
> are converted, vm_fault_t will become a distinct type.
> 
> Ref-> commit 1c8f422059ae ("mm: change return type to vm_fault_t")
> 
> Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>

This looks fine to me.

FYI that there is another handler for this driver in a series
destined for 4.18 and currently in next/master.

Acked-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
