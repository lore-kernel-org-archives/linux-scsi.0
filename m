From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 6/9] [SCSI] aacraid: Reset irq affinity hints before releasing
 irq
Date: Wed, 27 May 2015 16:45:27 +0200
Message-ID: <5565D887.8050407@redhat.com>
References: <1431562378-8514-1-git-send-email-rajinikanth.pandurangan@pmcs.com> <1431562378-8514-7-git-send-email-rajinikanth.pandurangan@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45407 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751359AbbE0Opd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 May 2015 10:45:33 -0400
In-Reply-To: <1431562378-8514-7-git-send-email-rajinikanth.pandurangan@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: rajinikanth.pandurangan@pmcs.com, jbottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: aacraid@pmc-sierra.com, harry.yang@pmcs.com, rich.bono@pmcs.com, achim.leubner@pmcs.com, murthy.bhat@pmcs.com

On 05/14/2015 02:12 AM, rajinikanth.pandurangan@pmcs.com wrote:
> From: Rajinikanth Pandurangan <rajinikanth.pandurangan@pmcs.com>
> 
> Description:
>         Reset irq affinity hints before releasing IRQ
>         Removed duplicate code of IRQ acquire/release
> 
> Signed-off-by: Rajinikanth Pandurangan <rajinikanth.pandurangan@pmcs.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Cheers,
Tomas


