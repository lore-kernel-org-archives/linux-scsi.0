From: Himanshu Jha <himanshujha199640@gmail.com>
Subject: Re: [PATCH] scsi: megaraid: Use zeroing memory allocator than
 allocator/memset
Date: Thu, 4 Jan 2018 17:09:29 +0530
Message-ID: <20180104113928.GA29414@himanshu-Vostro-3559>
References: <1514648877-7234-1-git-send-email-himanshujha199640@gmail.com>
 <c5c7c47e09294ac851265c887ab23fe9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <c5c7c47e09294ac851265c887ab23fe9@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Shivasharan Srikanteshwara <shivasharan.srikanteshwara@broadcom.com>
Cc: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, Kashyap Desai <kashyap.desai@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>, "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, mcgrof@kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Shivashran,

On Thu, Jan 04, 2018 at 04:52:54PM +0530, Shivasharan Srikanteshwara wrote:
> > -----Original Message-----
> > From: Himanshu Jha [mailto:himanshujha199640@gmail.com]
> > Sent: Saturday, December 30, 2017 9:18 PM
> > To: martin.petersen@oracle.com; jejb@linux.vnet.ibm.com
> > Cc: kashyap.desai@broadcom.com; sumit.saxena@broadcom.com;
> > shivasharan.srikanteshwara@broadcom.com;
> > megaraidlinux.pdl@broadcom.com; linux-scsi@vger.kernel.org; linux-
> > kernel@vger.kernel.org; mcgrof@kernel.org; Himanshu Jha
> > <himanshujha199640@gmail.com>
> > Subject: [PATCH] scsi: megaraid: Use zeroing memory allocator than
> > allocator/memset
> >
> > Use pci_zalloc_consistent for allocating zeroed memory and remove
> > unnecessary memset function.
> >
> > Done using Coccinelle.
> > Generated-by: scripts/coccinelle/api/alloc/kzalloc-simple.cocci
> > 0-day tested with no failures.
> >
> > Suggested-by: Luis R. Rodriguez <mcgrof@kernel.org>
> > Signed-off-by: Himanshu Jha <himanshujha199640@gmail.com>
> > ---
> >  drivers/scsi/megaraid/megaraid_sas_base.c   | 19 ++++++-------------
> >  drivers/scsi/megaraid/megaraid_sas_fusion.c |  5 ++---
> >  2 files changed, 8 insertions(+), 16 deletions(-)
> >
> 
> Hi Himanshu,
> I can see one more allocation done in megasas_get_seq_num() that could
> make use of these changes.

Yes, I missed that case! Thanks for pointing that out.

> Also, there is a driver update patchset that I am planning to post today.
> Adding this patch first might require additional rebasing of this
> patchset.
> Would you be ok if I send a separate patch for this along with the change
> mentioned above once my patch series gets committed?
> That would save me some rebasing effort. :-)

Yeah, sure! I have no objections for it. But this patch was not in the
patchseries that I sent a while ago https://lkml.org/lkml/2017/12/30/77

Thanks
Himanshu Jha
