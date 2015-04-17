From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v4 23/43] hpsa: clean up driver init
Date: Fri, 17 Apr 2015 15:39:35 +0200
Message-ID: <55310D17.9010705@redhat.com>
References: <20150416134224.30238.66082.stgit@brunhilda> <20150416134848.30238.82165.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34585 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932173AbbDQNkB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Apr 2015 09:40:01 -0400
In-Reply-To: <20150416134848.30238.82165.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.combrace@pmcs.com
Cc: linux-scsi@vger.kernel.org

On 04/16/2015 03:48 PM, Don Brace wrote:
> From: Robert Elliott <elliott@hp.com>
>
> Improve initialization error handling in hpsa_init_one
> Clean up style and indent issues
> Rename functions for consistency
> Improve error messaging on allocations
> Fix return status from hpsa_put_ctlr_into_performant_mode
> Correct free order in hpsa_init_one using new function
>    hpsa_free_performant_mode
> Prevent inadvertent use of null pointers by nulling out the parent structures
>    and zeroing out associated size variables.
>
> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
> Signed-off-by: Robert Elliott <elliott@hp.com>
> Signed-off-by: Don Brace <don.brace@pmcs.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas

