From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 2/5] mvsas: bug fix of dead lock
Date: Thu, 14 May 2009 00:33:45 -0400
Message-ID: <4A0B9F29.2010802@garzik.org>
References: <20090511172054.GB9698@Andy.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:47600 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235AbZENEdq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 May 2009 00:33:46 -0400
In-Reply-To: <20090511172054.GB9698@Andy.marvell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ayan@marvell.com
Cc: linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com

Andy Yan wrote:
>>From fda3efb9dfb8d2b1ff5ef12ee7473ec0c1e8368e Mon Sep 17 00:00:00 2001
> From: Andy Yan <ayan@marvell.com>
> Date: Mon, 11 May 2009 20:05:26 +0800
> Subject: [PATCH 2/5] mvsas: bug fix of dead lock
>  
> TMF task should be issued with Interrupt Disabled, or Deadlock may take place.
> Clean-up unused parameters and conditonal lock.
> 
> Signed-off-by: Ying Chu <jasonchu@marvell.com>
> Signed-off-by: Andy Yan <ayan@marvell.com>
> Signed-off-by: Ke Wei <kewei@marvell.com>

Acked-by: Jeff Garzik <jgarzik@redhat.com>


