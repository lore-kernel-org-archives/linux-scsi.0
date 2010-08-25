From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCHSET 2.6.36-rc2] block, fs: replace HARDBARRIER with
 FLUSH/FUA
Date: Wed, 25 Aug 2010 12:03:03 -0400
Message-ID: <20100825160302.GC8509@redhat.com>
References: <1282751267-3530-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59455 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753431Ab0HYQD3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Aug 2010 12:03:29 -0400
Content-Disposition: inline
In-Reply-To: <1282751267-3530-1-git-send-email-tj@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: jaxboe@fusionio.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de, James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com, hare@suse.de, neilb@suse.de, rusty@rustcorp.com.au, mst@redhat.com, jeremy@goop.org, k-ueda@ct.jp.nec.com

On Wed, Aug 25 2010 at 11:47am -0400,
Tejun Heo <tj@kernel.org> wrote:

> Hello,
> 
> This patchset is combination of the following three patchset.
> 
>  [1] block: replace barrier with sequenced flush
>  [2] block: convert to REQ_FLUSH/FUA
>  [3] replace barriers with explicit flush / FUA usage
> 
> Changes from the previous postings are,
> 
> * Rebased on top of 2.6.36-rc2 (502adf5778f4151dcba3f64dd6ed322151f3712c)

Awesome, thanks!

> * dm conversion is excluded for now.
...
> I've audited all make_request drivers and after this patchset only
> blktrace, dm, drbd and xen need more work.  I'll work on blktrace and
> dm

OK, once you have the DM patch refreshed I'll jump in with further
changes (SCSI error differentiation in mpath) and more careful review of
the DM changes (both bio-based and request-based).

Thanks again!
Mike
