From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch 09/28] SCSI: Fix obvious typo "spin_lock_irqrestore()"
	in gdth.c
Date: Fri, 11 May 2007 09:25:58 -0500
Message-ID: <1178893558.3692.22.camel@mulgrave.il.steeleye.com>
References: <200705110600.l4B60qNO008142@shell0.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:49960 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756421AbXEKO0D (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 May 2007 10:26:03 -0400
In-Reply-To: <200705110600.l4B60qNO008142@shell0.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: linux-scsi@vger.kernel.org, rpjday@mindspring.com, achim_leubner@adaptec.com

On Thu, 2007-05-10 at 23:00 -0700, akpm@linux-foundation.org wrote:
> From: "Robert P. J. Day" <rpjday@mindspring.com>
> 
> Fix misspelled "spin_lock_irqrestore" to read "spin_unlock_irqrestore"
> instead.
> 
> Presumably, GDTH_RTC doesn't get used a lot.

I can't actually find a way to get the driver compiled with GDTH_RTC.

Achim, Is it dead code and therefore can it be removed?

James


