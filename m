From: Varun Prakash <varun@chelsio.com>
Subject: Re: [RFC 24/34] iscsi-target: validate conn operational parameters
Date: Wed, 2 Mar 2016 17:48:19 +0530
Message-ID: <20160302121818.GB1795@chelsio.com>
References: <cover.1455467089.git.varun@chelsio.com>
 <940698fdb1ca47d8c392fa687f971842d215d083.1455467089.git.varun@chelsio.com>
 <20160301150318.GJ9738@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160301150318.GJ9738@infradead.org>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>, "roland@kernel.org" <roland@kernel.org>, SWise OGC <swise@opengridcomputing.com>, Indranil Choudhury <indranil@chelsio.com>, Karen Xie <kxie@chelsio.com>, Hariprasad S <hariprasad@chelsio.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Mar 01, 2016 at 08:33:18PM +0530, Christoph Hellwig wrote:
> On Sun, Feb 14, 2016 at 11:15:31PM +0530, Varun Prakash wrote:
> > call validate params function if registered
> > by transport driver before starting negotiation,
> > so that transport driver can validate and update
> > the value of parameters.
> 
> Should go together with the introduction of the method.

Ok, I will update it in v2 series. 
