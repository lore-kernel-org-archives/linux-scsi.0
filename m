From: Dave Dillow <dillowda@ornl.gov>
Subject: Re: srp_transport: Fix atttribute registration race
Date: Mon, 14 Nov 2011 17:17:54 -0500
Message-ID: <20111114221754.GA7702@ornl.gov>
References: <201110211857.23622.bvanassche@acm.org> <1320053608.8283.29.camel@dabdike> <CAO+b5-oxshsL7Dm7vhv4zC8m0P4dG3iNzxU9sdbi5cBkAnTpMQ@mail.gmail.com> <045e01cca1bb$3dee1070$b9ca3150$@systemfabricworks.com> <20111113215523.GA6117@ornl.gov> <CAJZOPZ+N2OLLHdKAFk=xkXGzFEdisaGsDBf6ra56pcT6zO_8qQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.ccs.ornl.gov ([160.91.199.39]:58780 "EHLO
	smtp2.ccs.ornl.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754627Ab1KNWR4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Nov 2011 17:17:56 -0500
Content-Disposition: inline
In-Reply-To: <CAJZOPZ+N2OLLHdKAFk=xkXGzFEdisaGsDBf6ra56pcT6zO_8qQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Or Gerlitz <or.gerlitz@gmail.com>
Cc: Bill Boas <bboas@systemfabricworks.com>, Bart Van Assche <bvanassche@acm.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Fujita Tomonori <fujita.tomonori@lab.ntt.co.jp>, Brian King <brking@linux.vnet.ibm.com>, Roland Dreier <roland@purestorage.com>

On Mon, Nov 14, 2011 at 04:43:32PM -0500, Or Gerlitz wrote:
> On Sun, Nov 13, 2011 at 11:55 PM, Dave Dillow <dillowda@ornl.gov> wrote:
> > SRP uses RDMA, so you cannot use UC mode.
> 
> per the IB spec, RDMA write is supported for UC

Yeah, I read that as UD for some reason...
