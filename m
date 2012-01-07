From: Rob Evers <revers@redhat.com>
Subject: Re: [PATCH] delay transition requeues for 2 seconds - alua
Date: Sat, 07 Jan 2012 10:06:55 -0500
Message-ID: <4F085F8F.2080006@redhat.com>
References: <1325618414-26992-1-git-send-email-revers@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46431 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751070Ab2AGPG5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 7 Jan 2012 10:06:57 -0500
In-Reply-To: <1325618414-26992-1-git-send-email-revers@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org

On 01/03/2012 02:20 PM, Rob Evers wrote:
> From: Rob Evers<revers@redhat.com>
>
> When alua targets are transitioning, the scsi midlayer retry mechanism
> continuously retries the scsi commands that are returning with not ready
> transitioning status.  The target is not capable of handling the
> commands for time on the order of several seconds during these transistions.
>
> This patch delays the device queue for 2 seconds, which is in the same
> order of aas transition time.
>
> Also, handle all other cases where ADD_TO_MLQUEUE_DELAY could be returned
> instead of ADD_TO_MLQUEUE as if ADD_TO_MLQUEUE were being returned.
>
> Problem found by array partner testing
>
> change MLQUEUE_DEV_DLY_RTY to MLQUEUE_DELAYED_RETRY

Hi James,

I noticed this didn't get included yet.

If you are planning to include this, please hold off.
I misunderstood the testing status initially and we
need to collect more information.  It may take some
time.

Rob

