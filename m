From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch 3/3] scsi: wd33c93 needs <asm/irq.h>
Date: Fri, 20 Jul 2007 11:48:57 -0500
Message-ID: <1184950138.3455.42.camel@localhost.localdomain>
References: <20070720164043.523003359@mail.of.borg>
	 <20070720164324.097994947@mail.of.borg>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-mips-bounce@linux-mips.org>
In-Reply-To: <20070720164324.097994947@mail.of.borg>
Sender: linux-mips-bounce@linux-mips.org
Errors-to: linux-mips-bounce@linux-mips.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-mips@linux-mips.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2007-07-20 at 18:40 +0200, Geert Uytterhoeven wrote:
> plain text document attachment (m68k-wd33c93-needs-asm-irq.diff)
> wd33c93 SCSI needs <asm/irq.h> on m68k
> 
> drivers/scsi/wd33c93.c: In function 'wd33c93_host_reset':
> drivers/scsi/wd33c93.c:1582: error: implicit declaration of function 'disable_irq'
> drivers/scsi/wd33c93.c:1603: error: implicit declaration of function 'enable_irq'
> 
> The driver still compiles on MIPS (CONFIG_SGIWD93_SCSI=y)

That's fixed here, isn't it:

http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commit;h=078dda95c521b1c78d1b5da69ac90d581abc9951

(sorry about the lack of descriptive subject line)

James
