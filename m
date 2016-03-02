From: Varun Prakash <varun@chelsio.com>
Subject: Re: [RFC 21/34] iscsi-target: release transport driver resources
Date: Wed, 2 Mar 2016 17:45:44 +0530
Message-ID: <20160302121543.GA1795@chelsio.com>
References: <cover.1455467089.git.varun@chelsio.com>
 <26d1bde8e55db6d2f77a354b379bec78bb7b7322.1455467089.git.varun@chelsio.com>
 <20160301145953.GG9738@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160301145953.GG9738@infradead.org>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>, "roland@kernel.org" <roland@kernel.org>, SWise OGC <swise@opengridcomputing.com>, Indranil Choudhury <indranil@chelsio.com>, Karen Xie <kxie@chelsio.com>, Hariprasad S <hariprasad@chelsio.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Mar 01, 2016 at 08:29:53PM +0530, Christoph Hellwig wrote:
> On Sun, Feb 14, 2016 at 11:12:15PM +0530, Varun Prakash wrote:
> > transport driver may allocate resources for an
> > iSCSI cmd, to free that resources iscsi target
> > must call release function registered by transport
> > driver.
> > 
> > ISCSI_TCP_CXGB4 frees DDP resource associated
> > with a WRITE cmd in the callback function.
> 
> This should go with the patch introducing the method.

Ok, I will update it in v2 series.
