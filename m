From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch 20/30] drivers/scsi/gdth.c: kmalloc + memset conversion
	to kzalloc
Date: Fri, 10 Aug 2007 21:00:55 -0400
Message-ID: <1186794055.6334.16.camel@localhost.localdomain>
References: <200708102150.l7ALokrZ011378@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:45224 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756226AbXHKBA6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Aug 2007 21:00:58 -0400
In-Reply-To: <200708102150.l7ALokrZ011378@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: linux-scsi@vger.kernel.org, m.kozlowski@tuxland.pl

On Fri, 2007-08-10 at 14:50 -0700, akpm@linux-foundation.org wrote:
> From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
> 
>  drivers/scsi/gdth.c | 189401 -> 189342 (-59 bytes)
>  drivers/scsi/gdth.o | 331028 -> 330324 (-704 bytes)

For the second time of asking, could I just have a single patch doing
this globally for the entirety of SCSI with reasonable assurance of
mechanical checking.

There's no real need to collect maintainer acks for something as trivial
as this.

James


