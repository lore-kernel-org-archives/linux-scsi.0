From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v4 40/43] hpsa: cleanup reset
Date: Fri, 17 Apr 2015 15:51:40 +0200
Message-ID: <55310FEC.6070803@redhat.com>
References: <20150416134224.30238.66082.stgit@brunhilda> <20150416135019.30238.99446.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965516AbbDQNwI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Apr 2015 09:52:08 -0400
In-Reply-To: <20150416135019.30238.99446.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.combrace@pmcs.com
Cc: linux-scsi@vger.kernel.org

On 04/16/2015 03:50 PM, Don Brace wrote:
> From: Webb Scales <webbnh@hp.com>
>
> Synchronize completion the reset with completion of outstanding commands
>
> Extending the newly-added synchronous abort functionality,
> now also synchronize resets with the completion of outstanding commands.
> Rename the wait queue to reflect the fact that it's being used for both
> types of waits.  Also, don't complete commands which are terminated
> due to a reset operation.
>
> fix for controller lockup during reset
>
> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
> Signed-off-by: Webb Scales <webbnh@hp.com>
> Signed-off-by: Don Brace <don.brace@pmcs.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas

