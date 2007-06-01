From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2/3] 2.6.22-rc3: known regressions v2
Date: Fri, 1 Jun 2007 09:01:15 -0700
Message-ID: <20070601090115.3271a397.akpm@linux-foundation.org>
References: <465FED20.3090206@googlemail.com>
	<46600F27.1090202@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <46600F27.1090202@googlemail.com>
Sender: sparclinux-owner@vger.kernel.org
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, linux-pcmcia@lists.infradead.org, Robert de Rooy <robert.de.rooy@gmail.com>, Alan Cox <alan@redhat.com>, Tejun Heo <htejun@gmail.com>, linux-ide@vger.kernel.org, Jeff Garzik <jeff@garzik.org>, Gregor Jasny <gjasny@googlemail.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@SteelEye.com>, Mark Salyzyn <aacraid@adaptec.com>, Yinghai Lu <yhlu.kernel@gmail.com>, Vivek Goyal <vgoyal@in.ibm.com>, sparclinux@vger.kernel.org, David Miller <davem@davemloft.net>, Mikael Pettersson <mikpe@it.uu.se>
List-Id: linux-scsi@vger.kernel.org

On Fri, 01 Jun 2007 14:20:55 +0200 Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:

> SCSI
> 
> Subject    : aacraid: adapter kernel panic'd fffffffd (kexec)
> References : http://lkml.org/lkml/2007/5/29/491
> Submitter  : Yinghai Lu <yhlu.kernel@gmail.com>
> Handled-By : Salyzyn, Mark <mark_salyzyn@adaptec.com>
>              Vivek Goyal <vgoyal@in.ibm.com>
> Status     : problem is being debugged

Mark's aacraid-fix-shutdown-handler-to-also-disable-interrupts.patch is
known to fix this, so we can move this to "known regressions with patches"
