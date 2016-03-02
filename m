From: Varun Prakash <varun@chelsio.com>
Subject: Re: [RFC 14/34] iscsi-target: export symbols
Date: Wed, 2 Mar 2016 17:30:45 +0530
Message-ID: <20160302120044.GB1755@chelsio.com>
References: <cover.1455467089.git.varun@chelsio.com>
 <4e5a7630ec492ff510404fb1ad0f011634518d04.1455467089.git.varun@chelsio.com>
 <20160301144921.GC9738@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160301144921.GC9738@infradead.org>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>, "roland@kernel.org" <roland@kernel.org>, SWise OGC <swise@opengridcomputing.com>, Indranil Choudhury <indranil@chelsio.com>, Karen Xie <kxie@chelsio.com>, Hariprasad S <hariprasad@chelsio.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Mar 01, 2016 at 08:19:21PM +0530, Christoph Hellwig wrote:
> This looks like pretty random exports and not something like a well
> defined interface to me :(

I have exported functions which works on iscsi-target data structures
and can be reused by offload drivers.
