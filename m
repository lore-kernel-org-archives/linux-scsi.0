From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFC 00/34] Chelsio iSCSI target offload driver
Date: Thu, 25 Feb 2016 23:29:37 -0800
Message-ID: <1456471777.32369.91.camel@haakon3.risingtidesystems.com>
References: <cover.1455467089.git.varun@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:45517 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319AbcBZH3k (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Feb 2016 02:29:40 -0500
In-Reply-To: <cover.1455467089.git.varun@chelsio.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Varun Prakash <varun@chelsio.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, roland@kernel.org, davem@davemloft.net, dledford@redhat.com, swise@opengridcomputing.com, indranil@chelsio.com, kxie@chelsio.com, hariprasad@chelsio.com

Hi Varun & Co,

Apologies for the delayed follow up here.

On Sun, 2016-02-14 at 23:00 +0530, Varun Prakash wrote:
> This RFC series is for Chelsio iSCSI target offload
> driver(cxgbit.ko).
> 
> cxgbit.ko registers with iSCSI target transport
> and offloads multiple CPU intensive tasks to
> Chelsio T5 adapters.
> 
> Chelsio T5 adapter series has following offload
> features for iSCSI -
> -TCP/IP offload.
> -iSCSI PDU recovery by reassembling TCP segments.
> -Header and Data Digest offload.
> -iSCSI segmentation offload(ISO).
> -Direct Data Placement(DDP).
> 
> Please review this series.
> 

After spending time over the last weeks to understand how cxgbit.ko
offloads work in patches #27-34, I think overall the new driver is in
very good shape.

Wrt to the patches to existing iscsi-target code in patches #13-26, I
need more time over the next days to consider the changes and/or better
alternatives, along with Sagi's earlier comments.  AFAICT it's mostly
smaller items, but it would be worth the discussion to see if/where some
larger improvements to existing iscsi-target code can be made beyond the
initial merge.

That said, this series has been added as-is to
target-pending/for-next-merge, to be picked up for the first round of
linux-next integration for drivers/net/ethernet/chelsio/ vs. DaveM's net
tree, and 0-day build testing.

Let's plan a RFC-v2 follow up sometime next week to address individual
comments, and to git squash patches #27-34 into a single merge-able
commit.

Thank you,

--nab

