From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFC-v2 10/12] iser-target: Add logic for verbs
Date: Tue, 02 Apr 2013 15:31:39 -0700
Message-ID: <1364941899.3898.196.camel@haakon2.linux-iscsi.org>
References: <1363996536-30644-1-git-send-email-nab@linux-iscsi.org>
	 <1363996536-30644-11-git-send-email-nab@linux-iscsi.org>
	 <CAJZOPZLHqhq4AbK0oWCJCtH5_xxwb7MW12AgqBRH4=mTOh2Qtw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:57497 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933636Ab3DBWbl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Apr 2013 18:31:41 -0400
In-Reply-To: <CAJZOPZLHqhq4AbK0oWCJCtH5_xxwb7MW12AgqBRH4=mTOh2Qtw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Or Gerlitz <or.gerlitz@gmail.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Roland Dreier <roland@kernel.org>, Or Gerlitz <ogerlitz@mellanox.com>, Alexander Nezhinsky <alexandern@mellanox.com>

On Wed, 2013-04-03 at 00:13 +0300, Or Gerlitz wrote:
> On Sat, Mar 23, 2013 at 1:55 AM, Nicholas A. Bellinger
> <nab@linux-iscsi.org> wrote:
> 
> +       device->dev_mr = ib_get_dma_mr(device->dev_pd,
> +                               IB_ACCESS_LOCAL_WRITE |
> +                               IB_ACCESS_REMOTE_WRITE |
> +                               IB_ACCESS_REMOTE_READ);
> 
> 
> remove IB_ACCESS_REMOTE_yyy access  flags, you're not letting anyone
> do remote rdma to this memory region

Droping IB_ACCESS_REMOTE_yyy access for RFC-v3.

Thanks Or!


