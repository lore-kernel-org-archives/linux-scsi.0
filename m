From: Eddie Wai <eddie.wai@broadcom.com>
Subject: Re: [PATCH v3 0/3] bnx2fc: fix memory leaks and NULL pointer
 dereferences
Date: Tue, 1 Apr 2014 11:53:36 -0700
Message-ID: <1396378416.32300.25.camel@lbirv-waie-lx2.broadcom.com>
References: <1396353502-30083-1-git-send-email-mlombard@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:59438 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbaDAS4F (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Apr 2014 14:56:05 -0400
In-Reply-To: <1396353502-30083-1-git-send-email-mlombard@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maurizio Lombardi <mlombard@redhat.com>
Cc: linux-scsi@vger.kernel.org, jbottomley@parallels.com, m.lombardi85@gmail.com

The patchset looks good.  Thanks.

Acked-by: Eddie Wai <eddie.wai@broadcom.com>

On Tue, 2014-04-01 at 13:58 +0200, Maurizio Lombardi wrote:
> PATCH 1/3 removes a unused variable from the bnx2fc_free_hash_table() function,
> 
> PATCH 2/3 fixes a memory leak and some NULL pointer dereferences in the bnx2fc_free_hash_table() function
> that may happen if bnx2fc_allocate_hash_table() fails.
> 
> PATCH 3/3 fixes a memory leak in the bnx2fc_allocate_hash_table() function.
> 
> Maurizio Lombardi (3):
>   bnx2fc: remove unused variable hash_table_size
>   bnx2fc: fix memory leak and potential NULL pointer dereference.
>   bnx2fc: fix memory leak in bnx2fc_allocate_hash_table()
> 
>  drivers/scsi/bnx2fc/bnx2fc_hwi.c | 64 +++++++++++++++++++++++-----------------
>  1 file changed, 37 insertions(+), 27 deletions(-)
> 


