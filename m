From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 6/6] mvsas: optimization of code
Date: Thu, 14 May 2009 14:20:07 -0400
Message-ID: <4A0C60D7.1050008@garzik.org>
References: <20090514213105.GB17959@Andy.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:56335 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752047AbZENSUI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 May 2009 14:20:08 -0400
In-Reply-To: <20090514213105.GB17959@Andy.marvell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ayan@marvell.com
Cc: linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com

Andy Yan wrote:
>>From e982ad0e48db5f18a81647927f1ca6e2fafe3e48 Mon Sep 17 00:00:00 2001
> From: Andy Yan <ayan@marvell.com>
> Date: Thu, 14 May 2009 20:41:21 -0400
> Subject: [PATCH 6/6] mvsas: optimization of code
> 
> remove all the cast from void * or to void *
> 
> Signed-off-by: Ying Chu <jasonchu@marvell.com>
> Signed-off-by: Andy Yan <ayan@marvell.com>
> Signed-off-by: Ke Wei <kewei@marvell.com

Acked-by: Jeff Garzik <jgarzik@redhat.com>

Though the email subject line should be "mvsas: remove casts to/from 
void*" as this is not an optimization

Thanks much for these revisions!!



