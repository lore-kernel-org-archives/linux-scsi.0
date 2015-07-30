From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 7/8] pm80xx: Handling Invalid SSP Response frame
Date: Thu, 30 Jul 2015 12:09:25 +0200
Message-ID: <55B9F7D5.6000500@redhat.com>
References: <1438151240-4097-1-git-send-email-Viswas.G@pmcs.com>
 <1438151240-4097-8-git-send-email-Viswas.G@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40747 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754373AbbG3KJ1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Jul 2015 06:09:27 -0400
In-Reply-To: <1438151240-4097-8-git-send-email-Viswas.G@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Viswas.G@pmcs.com, linux-scsi@vger.kernel.org
Cc: xjtuwjp@gmail.com, JBottomley@parallels.com, Suresh.Thiagarajan@pmcs.com

On 29.7.2015 08:27, Viswas.G@pmcs.com wrote:
> From: Viswas G <Viswas.G@pmcs.com>
> 
> The request has to be retried incase if the length of the SSP
> Response IU is invalid.
> 
> Signed-off-by: Viswas G <Viswas.G@pmcs.com>
> Signed-off-by: Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com> 
Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas


