From: Randall Huang <ihhuang@abmail.org>
Subject: Re: [PATCH] scsi: associate bio write hint with WRITE CDB
Date: Fri, 4 Jan 2019 13:22:51 +0800
Message-ID: <20190104052251.GA205256@google.com>
References: <20181226041504.66283-1-huangrandall@google.com>
 <20190103075133.GA5141@infradead.org>
 <20190103094755.GA96532@google.com>
 <e5bc96cd-1b48-3b7e-706f-4cbbd1a040a4@interlog.com>
 <6152b478ea77dacf57eef6f758ba795f756cd3da.camel@redhat.com>
 <yq1ef9t81fh.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yq1ef9t81fh.fsf@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, huangrandall@google.com
List-Id: linux-scsi@vger.kernel.org

On Thu, Jan 03, 2019 at 11:57:38PM -0500, Martin K. Petersen wrote:
> 
> Ewan,
> 
> > SBC-5 says that support for the grouping function is indicated by the
> > GROUP_SUP bit in the Extended Inquiry VPD page (86h).  I'm not sure
> > how many devices actually support that page though.  Probably most
> > don't.
> 
> Several devices support it, albeit for various different purposes. It's
> one of these wonderful features whose interpretation was left outside
> the scope of the spec for a long time.
> 
> So even though we absolutely and positively need to make setting GROUP
> NUMBER conditional on GROUP_SUP being reported, we also need additional
> information from the storage about how the field should be interpreted.
> 
> The official way to report hinting is for the device to implement the IO
> Advice Hints Grouping mode page. I wrote some code to support that but
> no vendors that I know of ended up actually shipping an implementation.
> A few implemented my older I/O class proposal but didn't ship that
> either despite really convincing performance results.
> 
> If Randall has access to a device which implements hinting, I'd love to
> know more.
I am working on Android phone.
The idea is to enable write hint for Turbo write UFS feature.
Turbo write feature in UFS 3.x is under discussion in JEDEC JC-64. 
This patch is the under-lying framework for supporting this feature.
> 
> -- 
> Martin K. Petersen	Oracle Linux Engineering
