From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [RFC] ib_srpt: initial .40-rc1 drivers/infiniband/ulp/srpt merge
Date: Wed, 18 May 2011 20:02:51 +0200
Message-ID: <BANLkTimQXU0u5gtRzXsnsB=sCF-bvpY+Ag@mail.gmail.com>
References: <1305682604-21383-1-git-send-email-nab@linux-iscsi.org>
 <BANLkTi=e+v7PLcSc8GNov-TOXFF7rurXew@mail.gmail.com> <20110518170556.GB2595@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110518170556.GB2595@obsidianresearch.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-rmda <linux-rdma@vger.kernel.org>, Roland Dreier <roland@purestorage.com>, Vu Pham <vu@mellanox.com>, David Dillow <dillowda@ornl.gov>, James Bottomley <James.Bottomley@hansenpartnership.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, May 18, 2011 at 7:05 PM, Jason Gunthorpe
<jgunthorpe@obsidianresearch.com> wrote:
> On Wed, May 18, 2011 at 06:59:36PM +0200, Bart Van Assche wrote:
>
>> As far as I know InfiniBand HCAs have either one or two ports. If
>> there are two ports present, at most one is active at any time.
>
> This is not true, many installations run dual rail IB with a desire
> for both ports to be active and handling traffic at once. Not sure how
> this translates to SRPT, but a good goal would be for a SRPT target to
> be available on both HCA ports and support APM between them, at the
> discretion of the client.

Thanks for the feedback. I'm still wondering though about the
usefulness of disabling / enabling SRPT per HCA port. For the use
cases I know about SRP communication over all target ports will be
enabled as soon as target configuration has finished and more
fine-grained access configuration will occur by allowing/disallowing
certain initiators to log in.

Bart.
