From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v4 32/43] hpsa: skip free_irq calls if irqs are not allocated
Date: Fri, 17 Apr 2015 15:44:45 +0200
Message-ID: <55310E4D.20604@redhat.com>
References: <20150416134224.30238.66082.stgit@brunhilda> <20150416134936.30238.72827.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42725 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933012AbbDQNpM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Apr 2015 09:45:12 -0400
In-Reply-To: <20150416134936.30238.72827.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.combrace@pmcs.com
Cc: linux-scsi@vger.kernel.org

On 04/16/2015 03:49 PM, Don Brace wrote:
> From: Robert Elliott <elliott@hp.com>
>
> If try_soft_reset fails to re-allocate irqs, the error exit
> starts with free_irq calls, which generate kernel WARN
> messages since they were already freed a few lines earlier.
>
> Jump to the next exit label to skip the free_irq calls.
>
> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
> Signed-off-by: Robert Elliott <elliott@hp.com>
> Signed-off-by: Don Brace <don.brace@pmcs.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas


