From: Varun Prakash <varun@chelsio.com>
Subject: Re: [PATCH] cxgb4i: Add a missing call to neigh_release
Date: Wed, 30 Nov 2016 16:49:32 +0530
Message-ID: <20161130111931.GA1703@chelsio.com>
References: <20161119174214.20241-1-lambert.quentin@gmail.com>
 <yq1inr6nsfq.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yq1inr6nsfq.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Quentin Lambert <lambert.quentin@gmail.com>, Karen Xie <kxie@chelsio.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Nov 29, 2016 at 10:18:09PM +0530, Martin K. Petersen wrote:
> >>>>> "Quentin" == Quentin Lambert <lambert.quentin@gmail.com> writes:
> 
> Quentin> Most error branches following the call to dst_neigh_lookup
> Quentin> contain a call to neigh_release. This patch add these calls
> Quentin> where they are missing.
> 
> Varun: Please review!
> 
Looks good.

Acked-by: Varun Prakash <varun@chelsio.com>
