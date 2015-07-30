From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 6/8] pm80xx: Add PORT RECOVERY TIMEOUT support
Date: Thu, 30 Jul 2015 12:08:35 +0200
Message-ID: <55B9F7A3.6090403@redhat.com>
References: <1438151240-4097-1-git-send-email-Viswas.G@pmcs.com>
 <1438151240-4097-7-git-send-email-Viswas.G@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33284 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527AbbG3KIh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Jul 2015 06:08:37 -0400
In-Reply-To: <1438151240-4097-7-git-send-email-Viswas.G@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Viswas.G@pmcs.com, linux-scsi@vger.kernel.org
Cc: xjtuwjp@gmail.com, JBottomley@parallels.com, Suresh.Thiagarajan@pmcs.com

On 29.7.2015 08:27, Viswas.G@pmcs.com wrote:
> From: Viswas G <Viswas.G@pmcs.com>
> 
> PORT RECOVERY TIMEOUT is the maximum time between the controller's
> detection of the PHY down until the receipt of the ID_Frame (from the
> same remote SAS port). If the time expires before the ID_FRAME is
> received, the port is considered INVALID and can be removed. The
> IOP_EVENT_PORT_RECOVERY_TIMER_TMO event is reported following the
> IOP_EVENT_ PHY_DOWN event when the PHY/port does not recover after
> Port Recovery Time.
> 
> Signed-off-by: Viswas G <Viswas.G@pmcs.com>
> Signed-off-by: Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com> 

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas

