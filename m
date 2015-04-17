From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v4 33/43] hpsa: cleanup for init_one step 2 in kdump
Date: Fri, 17 Apr 2015 15:45:00 +0200
Message-ID: <55310E5C.8010301@redhat.com>
References: <20150416134224.30238.66082.stgit@brunhilda> <20150416134941.30238.68476.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52164 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933012AbbDQNpD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Apr 2015 09:45:03 -0400
In-Reply-To: <20150416134941.30238.68476.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.combrace@pmcs.com
Cc: linux-scsi@vger.kernel.org

On 04/16/2015 03:49 PM, Don Brace wrote:
> From: Robert Elliott <elliott@hp.com>
>
> In hpsa_undo_allocations_after_kdump_soft_reset,
> the things allocated in hpsa_init_one step 2 -
> h->resubmit_wq and h->lockup_detected  need to
> be freed, in the right order.
>
> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
> Signed-off-by: Robert Elliott <elliott@hp.com>
> Signed-off-by: Don Brace <don.brace@pmcs.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas


