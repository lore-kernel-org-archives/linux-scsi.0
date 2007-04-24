From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH]: Rewritten ESP driver, porters needed!
Date: Tue, 24 Apr 2007 13:45:27 +0100
Message-ID: <20070424124527.GA30023@infradead.org>
References: <20070423.151322.111205472.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:51637 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161750AbXDXMp3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Apr 2007 08:45:29 -0400
Content-Disposition: inline
In-Reply-To: <20070423.151322.111205472.davem@davemloft.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: linux-scsi@vger.kernel.org, jskov@cygnus.co.uk, weisd3458@uni.edu, tymm@computer.org, tsbogend@alpha.franken.de, flo@rfc822.org, airlied@linux.ie, ralf@linux-mips.org, sparclinux@vger.kernel.org

Oh, btw - there is a problem with the generic code beeing esp.ko -
we already have drivers/char/esp.c which buids into esp.ko for
ISA platforms, which have a bit of overlap with ESP-using platforms.
Maybe the driver should become esp_scsi.c/.ko or ncr_esp or
ncr53x9x?
