From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFC-v2 01/12] iscsi: Resolve iscsi_proto.h naming conflicts
	with drivers/target/iscsi
Date: Mon, 14 Mar 2011 16:52:36 -0700
Message-ID: <1300146756.28255.211.camel@haakon2.linux-iscsi.org>
References: <1300103829-10337-1-git-send-email-nab@linux-iscsi.org>
	 <1300103829-10337-2-git-send-email-nab@linux-iscsi.org>
	 <20110314145930.GB28480@lst.de>
	 <1300138856.28255.133.camel@haakon2.linux-iscsi.org>
	 <4D7E930A.1010503@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4D7E930A.1010503@cs.wisc.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Boaz Harrosh <bharrosh@panasas.com>, Stephen Rothwell <sfr@canb.auug.org.au>, Douglas Gilbert <dgilbert@interlog.com>, Open iSCSI <open-iscsi@googlegroups.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2011-03-14 at 17:13 -0500, Mike Christie wrote:
> On 03/14/2011 04:40 PM, Nicholas A. Bellinger wrote:
> > On Mon, 2011-03-14 at 15:59 +0100, Christoph Hellwig wrote:
> >> On Mon, Mar 14, 2011 at 04:56:58AM -0700, Nicholas A. Bellinger wrote:
> >>> From: Nicholas Bellinger<nab@linux-iscsi.org>
> >>>
> >>> This patch renames the following iscsi_proto.h structures to avoid
> >>> namespace issues with drivers/target/iscsi/iscsi_target_core.h:
> >>>
> >>> *) struct iscsi_cmd ->  struct iscsi_scsi_cmd
> >>
> >> This name is not overly descriptive.  Using _req/_rsp uniformly would make a
> >> lot more sense.
> >>
> >
> > Mmmm, fair point here..  I don't have a strong preference so I will
> > defer to Mike and Hannes on this (open-iscsi CC'ed).  Guys is this OK
> > with you..?
> >
> 
> Ok with me.

OK, I will go ahead and convert these libiscsi PDU definitions to
iscsi_scsi_req and iscsi_scsi_rsp and update patch #1 of the series for
RFC-v3.

Thanks Mike!

--nab
