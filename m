From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH 13/32] aha1542.c: convert to accessors and !use_sg
 cleanup
Date: Fri, 9 Nov 2007 18:30:48 -0800
Message-ID: <20071109183048.a714e766.randy.dunlap@oracle.com>
References: <47164306.6090702@panasas.com>
	<47164C07.1070301@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:40420 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754431AbXKJDIb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Nov 2007 22:08:31 -0500
In-Reply-To: <47164C07.1070301@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <jens.axboe@oracle.com>, FUJITA Tomonori <tomof@acm.org>, Matthew Wilcox <matthew@wil.cx>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Russell King <rmk@arm.linux.org.uk>, Alan Stern <stern@rowland.harvard.edu>, "David S. Miller" <davem@davemloft.net>, Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>, Benny Halevy <bhalevy@panasas.com>, Pete Wyckoff <pw@osc.edu>

On Wed, 17 Oct 2007 19:53:11 +0200 Boaz Harrosh wrote:

> 
>  - convert to accessors and !use_sg cleanup
> 
> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> ---

Tested-by: Randy Dunlap <randy.dunlap@oracle.com> // aha152x_cs

>  drivers/scsi/aha1542.c |   46 ++++++++++------------------------------------
>  1 files changed, 10 insertions(+), 36 deletions(-)


---
~Randy
