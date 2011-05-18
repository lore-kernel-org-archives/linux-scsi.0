From: Roland Dreier <roland@purestorage.com>
Subject: Re: [RFC] ib_srpt: initial .40-rc1 drivers/infiniband/ulp/srpt merge
Date: Wed, 18 May 2011 12:17:21 -0700
Message-ID: <BANLkTi==bZ0h3o5FNrg8PSJFp6F-zh5hTA@mail.gmail.com>
References: <1305682604-21383-1-git-send-email-nab@linux-iscsi.org>
 <BANLkTi=e+v7PLcSc8GNov-TOXFF7rurXew@mail.gmail.com> <20110518170556.GB2595@obsidianresearch.com>
 <BANLkTimQXU0u5gtRzXsnsB=sCF-bvpY+Ag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys010aog101.obsmtp.com ([74.125.245.70]:45283 "HELO
	na3sys010aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933451Ab1ERTRn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 May 2011 15:17:43 -0400
In-Reply-To: <BANLkTimQXU0u5gtRzXsnsB=sCF-bvpY+Ag@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-rmda <linux-rdma@vger.kernel.org>, Vu Pham <vu@mellanox.com>, David Dillow <dillowda@ornl.gov>, James Bottomley <James.Bottomley@hansenpartnership.com>

On Wed, May 18, 2011 at 11:02 AM, Bart Van Assche <bvanassche@acm.org> wrote:
> Thanks for the feedback. I'm still wondering though about the
> usefulness of disabling / enabling SRPT per HCA port. For the use
> cases I know about SRP communication over all target ports will be
> enabled as soon as target configuration has finished and more
> fine-grained access configuration will occur by allowing/disallowing
> certain initiators to log in.

I definitely think that allowing the flexibility to configure ports individually
is required.  It's easy to imagine a case with a separate front-end and
back-end networks on the two HCA ports (this would be a pretty normal
ethernet config), where only one port should be a target port.

It may not be how people do things now but it should at least be possible.

 - R.
