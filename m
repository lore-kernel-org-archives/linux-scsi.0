From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 5/5 v2] mvsas: optimization of code
Date: Thu, 14 May 2009 14:19:11 -0400
Message-ID: <4A0C609F.7080109@garzik.org>
References: <20090514212640.GA17959@Andy.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:37424 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952AbZENSTN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 May 2009 14:19:13 -0400
In-Reply-To: <20090514212640.GA17959@Andy.marvell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ayan@marvell.com
Cc: linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com

Andy Yan wrote:
>>From 698781e21a8595159a84a8c91b6bfa26d1a99108 Mon Sep 17 00:00:00 2001
> From: root <root@hat001.(none)>
> Date: Mon, 11 May 2009 22:19:25 +0800
> Subject: [PATCH5/5 v2] mvsas: optimization of code
> 
> remove all the cast from void *
> 
> Signed-off-by: Ying Chu <jasonchu@marvell.com>
> Signed-off-by: Andy Yan <ayan@marvell.com>
> Signed-off-by: Ke Wei <kewei@marvell.com

Acked-by: Jeff Garzik <jgarzik@redhat.com>

Though you accidentally dropped the description, "use sticky field to 
improve performance"

