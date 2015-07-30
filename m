From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 5/8] pm80xx: Remove unnecessary phy disconnect while link
 error
Date: Thu, 30 Jul 2015 12:08:09 +0200
Message-ID: <55B9F789.20309@redhat.com>
References: <1438151240-4097-1-git-send-email-Viswas.G@pmcs.com>
 <1438151240-4097-6-git-send-email-Viswas.G@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38332 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527AbbG3KIM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Jul 2015 06:08:12 -0400
In-Reply-To: <1438151240-4097-6-git-send-email-Viswas.G@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Viswas.G@pmcs.com, linux-scsi@vger.kernel.org
Cc: xjtuwjp@gmail.com, JBottomley@parallels.com, Suresh.Thiagarajan@pmcs.com

On 29.7.2015 08:27, Viswas.G@pmcs.com wrote:
> From: Viswas G <Viswas.G@pmcs.com>
> 
> If the link error happens, we don't need to disconnect the phy,
> which will remove the drive. Instead acknowledging the controller
> and logging the error will be enough.
> 
> Signed-off-by: Viswas G <Viswas.G@pmcs.com>
> Signed-off-by: Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com> 
Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas


