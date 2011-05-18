From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [RFC] ib_srpt: initial .40-rc1 drivers/infiniband/ulp/srpt merge
Date: Wed, 18 May 2011 18:59:36 +0200
Message-ID: <BANLkTi=e+v7PLcSc8GNov-TOXFF7rurXew@mail.gmail.com>
References: <1305682604-21383-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1305682604-21383-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-rmda <linux-rdma@vger.kernel.org>, Roland Dreier <roland@purestorage.com>, Vu Pham <vu@mellanox.com>, David Dillow <dillowda@ornl.gov>, James Bottomley <James.Bottomley@hansenpartnership.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, May 18, 2011 at 3:36 AM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
> ib_srpt: Convert se_wwn endpoint reference to struct srpt_port->port_wwn
> http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=commitdiff;h=4e544a210acb227df1bb4ca5086e65bdf4e648ea

Why has that change been implemented ? As far as I know InfiniBand
HCAs have either one or two ports. If there are two ports present, at
most one is active at any time. I don't see the point of making
individual ports visible and configurable in configfs on the target
instead of the HCA. If a user enables one port of a HCA but not the
other, that could result in some really strange and hard to diagnose
failures if the IB subnet manager decides to switch over to the other
port. Or am I missing something ?

Bart.
