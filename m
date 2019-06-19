From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Subject: Re: [PATCH 1/2] scsi: devinfo: BLIST_TRY_VPD_PAGES for SanDisk
 Cruzer Blade
Date: Wed, 19 Jun 2019 09:03:52 -0300
Message-ID: <20190619120346.GC26980@continental>
References: <20190618013146.21961-1-marcos.souza.org@gmail.com>
 <20190618013146.21961-2-marcos.souza.org@gmail.com>
 <yq1r27quuod.fsf@oracle.com>
 <20190619094540.GA26980@continental>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190619094540.GA26980@continental>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jun 19, 2019 at 06:45:43AM -0300, Marcos Paulo de Souza wrote:
> On Tue, Jun 18, 2019 at 11:21:22PM -0400, Martin K. Petersen wrote:
> > 
> > Marcos,
> > 
> > > Currently, all USB devices skip VPD pages, even when the device
> > > supports them (SPC-3 and later), but some of them support VPD, like
> > > Cruzer Blade.
> > 
> > What's your confidence level wrt. all Cruzer Blades handling this
> > correctly? How many devices have you tested this change with?
> 
> I've tested three Cruzer Blades that I have at hand, and all  of them have VPD
> support, and also checked with a friend of mine that also have one. I can't say
> about "all others" but so far, 4/4 devices that I tested have VPD. (They were all
> SPC-3 or SPC-4 compliant).
> 

My first idea was to add a vendor:product mapping at SCSI layer, but so far I
haven't found one, so I added the model/vendor found by INQUIRY. Would it be
better to check for prod:vendor (as values, instead of the description)?

Thanks,
Marcos


> > 
> > -- 
> > Martin K. Petersen	Oracle Linux Engineering
