From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 7/9] ib_srpt: Convert srp_max_rdma_size into per port
 configfs attribute
Date: Mon, 24 Oct 2011 11:27:18 -0700
Message-ID: <1319480838.17450.4.camel@haakon2.linux-iscsi.org>
References: <1319434422-15354-1-git-send-email-nab@linux-iscsi.org>
	 <1319434422-15354-8-git-send-email-nab@linux-iscsi.org>
	 <CAO+b5-q+SPZNv-c8Qnho3pzj6xqjTEu9cMAJGeCEr6qquHLScw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <CAO+b5-q+SPZNv-c8Qnho3pzj6xqjTEu9cMAJGeCEr6qquHLScw@mail.gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-rdma <linux-rdma@vger.kernel.org>, Roland Dreier <roland@purestorage.com>, Christoph Hellwig <hch@lst.de>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2011-10-24 at 18:34 +0200, Bart Van Assche wrote:
> On Mon, Oct 24, 2011 at 7:33 AM, Nicholas A. Bellinger
> <nab@linux-iscsi.org> wrote:
> > This patch converts the srp_max_rdma_size module parameter into a per
> > endpoint configfs attribute.  This includes adding the necessary bits
> > for show + store attributes w/ min/max bounds checking, and updating
> > srpt_get_ioc() to accept a struct srpt_port parameter.
> >
> > [ ... ]
> >
> > -static void srpt_get_ioc(struct srpt_device *sdev, u32 slot,
> > +static void srpt_get_ioc(struct srpt_port *sport, u32 slot,
> >                         struct ib_dm_mad *mad)
> 
> The SRP spec says that there should be only one value for
> iocp->rdma_size per I/O controller. This patch breaks that rule. I'm
> not sure it's a good idea to introduce such behavior changes.
> 

Hi Bart,

This is something that Roland asked me to persue, so i'll have to defer
to his judgment if he want's to kick this back out to a module parameter
or not.

--nab
