From: Dave Dillow <dillowda@ornl.gov>
Subject: Re: srp_transport: Fix atttribute registration race
Date: Sun, 13 Nov 2011 16:55:23 -0500
Message-ID: <20111113215523.GA6117@ornl.gov>
References: <201110211857.23622.bvanassche@acm.org> <1320053608.8283.29.camel@dabdike> <CAO+b5-oxshsL7Dm7vhv4zC8m0P4dG3iNzxU9sdbi5cBkAnTpMQ@mail.gmail.com> <045e01cca1bb$3dee1070$b9ca3150$@systemfabricworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.ccs.ornl.gov ([160.91.199.38]:40040 "EHLO
	smtp1.ccs.ornl.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548Ab1KMWOb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Nov 2011 17:14:31 -0500
Content-Disposition: inline
In-Reply-To: <045e01cca1bb$3dee1070$b9ca3150$@systemfabricworks.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bill Boas <bboas@systemfabricworks.com>
Cc: 'Bart Van Assche' <bvanassche@acm.org>, 'James Bottomley' <James.Bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, 'Fujita Tomonori' <fujita.tomonori@lab.ntt.co.jp>, 'Brian King' <brking@linux.vnet.ibm.com>, 'Roland Dreier' <roland@purestorage.com>

On Sat, Nov 12, 2011 at 11:18:04PM -0500, Bill Boas wrote:
> Bart, James, Dave,
> 
> At SC we are running a video streaming demo across a 7000 mile fiber
> distance using IB extension boxes from Bay Microsystems at 40 Gbps. The
> video streaming app uses SRP to transmit the streams across this long
> distance link. Performance is not all what we would have hoped. We think
> that because SRP uses RC mode between initiator and target that it is the RC
> behavior over this distance that is impacting performance. Are any of you
> aware of an SRP implementation that uses UC mode.

SRP uses RDMA, so you cannot use UC mode.

Your problem sounds a lot like issues we saw when starting to run over
100m+ optical cables; IIRC it required increasing the credits available
the link. You should contact Jason Gunthorpe or Makia Minnich. Makia was
involved in that investigation at ORNL, but Jason may also be able to tell
you off the top of his head.

Dave

