From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] ATA convert GSI to irq on ia64
Date: Thu, 08 Feb 2007 20:19:45 -0500
Message-ID: <45CBCC31.7070909@garzik.org>
References: <1170920422.15989.354.camel@ymzhang>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1170920422.15989.354.camel@ymzhang>
Sender: linux-ide-owner@vger.kernel.org
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Zhang, Yanmin wrote:
> If an ATA drive uses legacy mode, ata driver will choose 14 and 15 as the
> fixed irq number. On ia64 platform, such numbers are GSI and should be converted
> to irq vector.
> 
> Below patch against kernel 2.6.20 fixes it.
> 
> Signed-off-by: Zhang Yanmin <yanmin.zhang@intel.com>

IA64 should create its own libata-portmap.h, rather than modifying the 
one in asm-generic with arch-specific choices.

powerpc is a current example of this (and currently the only 
non-asm-generic user) found in kernel 2.6.20.

	Jeff



