From: Satyam Sharma <satyam@infradead.org>
Subject: Re: [PATCH 3/5] Use mutex instead of semaphore in the SCSI Tape
 driver
Date: Mon, 30 Jul 2007 08:59:35 +0530 (IST)
Message-ID: <alpine.LFD.0.999.0707300858140.10861@enigma.security.iitk.ac.in>
References: <20070729212909.GC3432@traven> <20070729213815.GF3432@traven>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:52580 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759914AbXG3DRR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Jul 2007 23:17:17 -0400
In-Reply-To: <20070729213815.GF3432@traven>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Cc: Kai.Makisara@kolumbus.fi, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org



On Sun, 29 Jul 2007, Matthias Kaehlcke wrote:

> The SCSI Tape driver uses a semaphore as mutex. Use the mutex API
> instead of the (binary) semaphore.
> 
> Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

Reviewed-by: Satyam Sharma <satyam@infradead.org>
