From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Subject: Re: [PATCH 1/2] scsi: devinfo: BLIST_TRY_VPD_PAGES for SanDisk
 Cruzer Blade
Date: Tue, 2 Jul 2019 20:09:19 -0300
Message-ID: <20190702230919.GB19791@continental>
References: <20190618013146.21961-1-marcos.souza.org@gmail.com>
 <20190618013146.21961-2-marcos.souza.org@gmail.com>
 <yq1r27quuod.fsf@oracle.com>
 <20190619094540.GA26980@continental>
 <20190619120346.GC26980@continental>
 <yq14l4kro9l.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yq14l4kro9l.fsf@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jun 20, 2019 at 04:32:38PM -0400, Martin K. Petersen wrote:
> 
> Marcos,
> 
> > My first idea was to add a vendor:product mapping at SCSI layer, but
> > so far I haven't found one, so I added the model/vendor found by
> > INQUIRY. Would it be better to check for prod:vendor (as values,
> > instead of the description)?
> 
> Your patch is functionally fine. I'm just trying to establish how risky
> it is for me to pick it up.

I've tried to find any official document about Cruzer Blade devices, stating
that all of them have at least SPC-3 to support VPD, but no luck so far :(

So feel free to ignore the patch if you think it's too risky.

Thanks,
Marcos

> 
> -- 
> Martin K. Petersen	Oracle Linux Engineering
