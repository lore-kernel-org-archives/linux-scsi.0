From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [PATCH 3/5] Use mutex instead of semaphore in the SCSI Tape
 driver
Date: Mon, 30 Jul 2007 19:27:20 +0300 (EEST)
Message-ID: <Pine.LNX.4.64.0707301925410.5391@kai.makisara.local>
References: <20070729212909.GC3432@traven> <20070729213815.GF3432@traven>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emh05.mail.saunalahti.fi ([62.142.5.111]:47351 "EHLO
	emh05.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966724AbXG3Q1Z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jul 2007 12:27:25 -0400
In-Reply-To: <20070729213815.GF3432@traven>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org

On Sun, 29 Jul 2007, Matthias Kaehlcke wrote:

> The SCSI Tape driver uses a semaphore as mutex. Use the mutex API
> instead of the (binary) semaphore.
> 
> Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
> 
Signed-off-by: Kai Makisara <kai.makisara@kolumbus.fi>

Thanks.

-- 
Kai
