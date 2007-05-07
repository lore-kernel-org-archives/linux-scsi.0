From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch 08/30] drivers/scsi/megaraid.c: Replacing yield() with
	a better alternative
Date: Mon, 07 May 2007 14:36:02 -0500
Message-ID: <1178566562.3729.38.camel@mulgrave.il.steeleye.com>
References: <200704260735.l3Q7ZDV9024229@shell0.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:43144 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S966301AbXEGTgg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 May 2007 15:36:36 -0400
In-Reply-To: <200704260735.l3Q7ZDV9024229@shell0.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: linux-scsi@vger.kernel.org, amol@verismonetworks.com, "Patro, Sumant" <Sumant.Patro@lsi.com>

On Thu, 2007-04-26 at 00:35 -0700, akpm@linux-foundation.org wrote:
> From: Amol Lad <amol@verismonetworks.com>
> 
> For this driver cond_resched() seems to be a better alternative
> 
> Signed-off-by: Amol Lad <amol@verismonetworks.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Needs ack by maintainer ... cc'd

James


