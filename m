From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH v1 2/3] libiscsi, iser: Adjust data_length to include
 protection information
Date: Tue, 10 Jun 2014 13:19:35 -0500
Message-ID: <53974C37.60206@cs.wisc.edu>
References: <1402223228-23768-1-git-send-email-sagig@mellanox.com> <1402223228-23768-3-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:37409 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750740AbaFJST4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Jun 2014 14:19:56 -0400
In-Reply-To: <1402223228-23768-3-git-send-email-sagig@mellanox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>
Cc: martin.petersen@oracle.com, nab@linux-iscsi.org, roland@kernel.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-rdma@vger.kernel.org

On 06/08/2014 05:27 AM, Sagi Grimberg wrote:
> In case protection information exists over the wire
> iscsi header data_length is required to include it.
> Use protection information aware scsi helpers to set
> the correct transfer length.
> 
> In order to avoid breakage, remove iser transfer length
> checks for each task as they are not always true and
> somewhat redundant anyway.
> 
> Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
> ---
>  drivers/infiniband/ulp/iser/iser_initiator.c |   34 +++++++------------------
>  drivers/scsi/libiscsi.c                      |   18 +++++++-------


Looks ok to me now. Thanks.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>

Not sure, if I am supposed to do a acked-by for the libiscsi.c change,
but if so

Acked-by: Mike Christie <michaelc@cs.wisc.edu>
