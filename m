From: Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [patch 3/3] scsi: wd33c93 needs <asm/irq.h>
Date: Fri, 20 Jul 2007 18:31:32 +0100
Message-ID: <20070720173132.GB19424@linux-mips.org>
References: <20070720164043.523003359@mail.of.borg> <20070720164324.097994947@mail.of.borg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ftp.linux-mips.org ([194.74.144.162]:36254 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762994AbXGTRbi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Jul 2007 13:31:38 -0400
Received: from localhost.localdomain ([127.0.0.1]:46492 "EHLO
	dl5rb.ham-radio-op.net") by ftp.linux-mips.org with ESMTP
	id S20023031AbXGTRbg (ORCPT <rfc822;linux-scsi@vger.kernel.org>
	+ 2 others); Fri, 20 Jul 2007 18:31:36 +0100
Content-Disposition: inline
In-Reply-To: <20070720164324.097994947@mail.of.borg>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org, "James E.J. Bottomley" <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, linux-mips@linux-mips.org

On Fri, Jul 20, 2007 at 06:40:46PM +0200, Geert Uytterhoeven wrote:

> --- a/drivers/scsi/wd33c93.c
> +++ b/drivers/scsi/wd33c93.c
> @@ -89,6 +89,8 @@
>  #include <scsi/scsi_device.h>
>  #include <scsi/scsi_host.h>
>  
> +#include <asm/irq.h>

These days that should probably be <linux/irq.h>.

  Ralf
