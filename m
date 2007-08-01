From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 82] drivers/scsi/zorro7xx.c: kmalloc + memset
	conversion to kzalloc
Date: Wed, 01 Aug 2007 11:11:21 -0500
Message-ID: <1185984681.3468.78.camel@localhost.localdomain>
References: <200707311845.48807.m.kozlowski@tuxland.pl>
	 <200708010021.34147.m.kozlowski@tuxland.pl>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <200708010021.34147.m.kozlowski@tuxland.pl>
Sender: kernel-janitors-owner@vger.kernel.org
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2007-08-01 at 00:21 +0200, Mariusz Kozlowski wrote:
> [PATCH 82] ...

Please no.  This should be a simple mechanical substitution.  I don't
need to collect acks from everyone.  This is a nice point to do a
conversion like this, so I'll sort out the mismerges.

Please assure me you have a good methodology for doing the replacement
and a reasonable one for testing and then send either one patch for the
entirety of SCSI to me, or one patch for the entirety of the kernel to
Andrew and we'll see if we can get it through the process.

James


