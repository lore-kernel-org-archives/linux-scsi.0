From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [PATCH 64] drivers/scsi/qla2xxx/qla_init.c: mostly kmalloc + memset conversion to k[cz]alloc
Date: Tue, 31 Jul 2007 15:00:07 -0700
Message-ID: <20070731220007.GI8842@plap.qlogic.org>
References: <200707311845.48807.m.kozlowski@tuxland.pl> <200707312351.10536.m.kozlowski@tuxland.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200707312351.10536.m.kozlowski@tuxland.pl>
Sender: kernel-janitors-owner@vger.kernel.org
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-driver@qlogic.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 31 Jul 2007, Mariusz Kozlowski wrote:

> Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
> 
>  drivers/scsi/qla2xxx/qla_init.c | 107445 -> 107327 (-118 bytes)
>  drivers/scsi/qla2xxx/qla_init.o | 237540 -> 237424 (-116 bytes)
> 
>  drivers/scsi/qla2xxx/qla_init.c |   14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)

Acked-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
