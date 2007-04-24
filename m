From: David Miller <davem@davemloft.net>
Subject: Re: [RFC PATCH]: Rewritten ESP driver, porters needed!
Date: Tue, 24 Apr 2007 13:56:47 -0700 (PDT)
Message-ID: <20070424.135647.57445123.davem@davemloft.net>
References: <20070423.151322.111205472.davem@davemloft.net>
	<20070424124527.GA30023@infradead.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <20070424124527.GA30023@infradead.org>
Sender: sparclinux-owner@vger.kernel.org
To: hch@infradead.org
Cc: linux-scsi@vger.kernel.org, jskov@cygnus.co.uk, weisd3458@uni.edu, tymm@computer.org, tsbogend@alpha.franken.de, flo@rfc822.org, airlied@linux.ie, ralf@linux-mips.org, sparclinux@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Christoph Hellwig <hch@infradead.org>
Date: Tue, 24 Apr 2007 13:45:27 +0100

> Oh, btw - there is a problem with the generic code beeing esp.ko -
> we already have drivers/char/esp.c which buids into esp.ko for
> ISA platforms, which have a bit of overlap with ESP-using platforms.
> Maybe the driver should become esp_scsi.c/.ko or ncr_esp or
> ncr53x9x?

What really pisses me off about that one is that I created
esp.c years before that character driver got into the tree
but somehow they won out.

Anyways, what's done is done and I'll rename it to esp_scsi.

Thanks.
