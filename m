From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 3/5] mvsas: bug fix, null pointer may be used
Date: Thu, 14 May 2009 00:36:04 -0400
Message-ID: <4A0B9FB4.5050205@garzik.org>
References: <20090511172216.GC9698@Andy.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:40216 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751423AbZENEgF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 May 2009 00:36:05 -0400
In-Reply-To: <20090511172216.GC9698@Andy.marvell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ayan@marvell.com
Cc: linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com

Andy Yan wrote:
>>From d4529158b4e32d68b41a052c9b66de7243e0c4ce Mon Sep 17 00:00:00 2001
> From: Andy Yan <ayan@marvell.com>
> Date: Mon, 11 May 2009 21:49:52 +0800
> Subject: [PATCH 3/5] mvsas: bug fix, null pointer may be used
> 
> Null pointer check to avoid corruption.
> 
> Signed-off-by: Ying Chu <jasonchu@marvell.com>
> Signed-off-by: Andy Yan <ayan@marvell.com>
> Signed-off-by: Ke Wei <kewei@marvell.com>

Acked-by: Jeff Garzik <jgarzik@redhat.com>


