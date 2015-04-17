From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v4 35/43] hpsa: create workqueue after the driver is ready
 for use
Date: Fri, 17 Apr 2015 15:46:13 +0200
Message-ID: <55310EA5.4070303@redhat.com>
References: <20150416134224.30238.66082.stgit@brunhilda> <20150416134952.30238.81509.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37168 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932503AbbDQNqk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Apr 2015 09:46:40 -0400
In-Reply-To: <20150416134952.30238.81509.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.combrace@pmcs.com
Cc: linux-scsi@vger.kernel.org

On 04/16/2015 03:49 PM, Don Brace wrote:
> From: Robert Elliott <elliott@hp.com>
>
> Don't create the resubmit workqueue in hpsa_init_one until everything else
> is ready to use, so everything can be freed in reverse order of when they
> were allocated without risking freeing things while workqueue items are
> still active.
>
> Destroy the workqueue in the right order in
> hpsa_undo_allocations_after_kdump_soft_reset too.
>
> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
> Signed-off-by: Robert Elliott <elliott@hp.com>
> Signed-off-by: Don Brace <don.brace@pmcs.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas


