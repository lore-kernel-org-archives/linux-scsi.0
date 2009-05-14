From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 4/5] mvsas: correct bit map usage
Date: Thu, 14 May 2009 00:37:16 -0400
Message-ID: <4A0B9FFC.2070300@garzik.org>
References: <20090511172419.GA9720@Andy.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:40229 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751565AbZENEhS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 May 2009 00:37:18 -0400
In-Reply-To: <20090511172419.GA9720@Andy.marvell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ayan@marvell.com
Cc: linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com

Andy Yan wrote:
>>From dc94fa636af60eaebc9aaeb80c1b78b52edeea57 Mon Sep 17 00:00:00 2001
> From: Andy Yan <ayan@marvell.com>
> Date: Mon, 11 May 2009 21:56:31 +0800
> Subject: [PATCH 4/5] mvsas: correct bit map usage
> 
> Utilize DECLARE_BITMAP to define the tags array.
> 
> Signed-off-by: Ying Chu <jasonchu@marvell.com>
> Signed-off-by: Andy Yan <ayan@marvell.com>
> Signed-off-by: Ke Wei <kewei@marvell.com>

Acked-by: Jeff Garzik <jgarzik@redhat.com>


