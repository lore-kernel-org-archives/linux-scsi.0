From: Varun Prakash <varun@chelsio.com>
Subject: Re: [PATCH v2 08/16] iscsi-target: add void (*iscsit_get_r2t_ttt)()
Date: Mon, 11 Apr 2016 23:38:39 +0530
Message-ID: <20160411180838.GB1758@chelsio.com>
References: <cover.1460204441.git.varun@chelsio.com>
 <2f71b7720d07231faa12ffba830681f1d7ac07da.1460204441.git.varun@chelsio.com>
 <570A92B0.9000109@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:49497 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbcDKSJF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Apr 2016 14:09:05 -0400
Content-Disposition: inline
In-Reply-To: <570A92B0.9000109@grimberg.me>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagi@grimberg.me>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, nab@linux-iscsi.org, swise@opengridcomputing.com, kxie@chelsio.com, indranil@chelsio.com

On Sun, Apr 10, 2016 at 08:51:44PM +0300, Sagi Grimberg wrote:
> 
> >Add void (*iscsit_get_r2t_ttt)() to
> >struct iscsit_transport, iscsi-target
> >uses this callback to get
> >r2t->targ_xfer_tag.
> 
> Your driver allocates ttt's? That looks like bad
> layering to me. This definitely deserves an explanation...

cxgbit.ko allocates ttt only for r2t pdus to do Direct Data
Placement of Data Out pdus, adapter uses the ttt value in
Data Out pdus to place data directly in the host buffers.
