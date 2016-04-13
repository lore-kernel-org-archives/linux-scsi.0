From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 0/4] Decouple X86_32 dependency from the
 ISA Kconfig option
Date: Wed, 13 Apr 2016 16:38:38 +0200
Message-ID: <20160413143838.GD5867@gmail.com>
References: <cover.1460379702.git.vilhelm.gray@gmail.com>
 <20160413072602.GA7629@gmail.com> <20160413121515.GA23870@sophia>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <alsa-devel-bounces@alsa-project.org>
Content-Disposition: inline
In-Reply-To: <20160413121515.GA23870@sophia>
List-Unsubscribe: <http://mailman.alsa-project.org/mailman/options/alsa-devel>,
 <mailto:alsa-devel-request@alsa-project.org?subject=unsubscribe>
List-Archive: <http://mailman.alsa-project.org/pipermail/alsa-devel/>
List-Post: <mailto:alsa-devel@alsa-project.org>
List-Help: <mailto:alsa-devel-request@alsa-project.org?subject=help>
List-Subscribe: <http://mailman.alsa-project.org/mailman/listinfo/alsa-devel>,
 <mailto:alsa-devel-request@alsa-project.org?subject=subscribe>
Errors-To: alsa-devel-bounces@alsa-project.org
Sender: alsa-devel-bounces@alsa-project.org
To: William Breathitt Gray <vilhelm.gray@gmail.com>
Cc: alsa-devel@alsa-project.org, linux-scsi@vger.kernel.org, gregkh@linuxfoundation.org, x86@kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de
List-Id: linux-scsi@vger.kernel.org


* William Breathitt Gray <vilhelm.gray@gmail.com> wrote:

> On Wed, Apr 13, 2016 at 09:26:02AM +0200, Ingo Molnar wrote:
> >What's the practical motivation of this? What exact hardware is this for?
> >
> >Thanks,
> >
> >	Ingo
> 
> The PC/104 bus is equivalent to the ISA bus regarding software
> communication. Many small form factor systems have a PC/104 bus where
> PC/104 cards may be stacked. Nowadays, these systems are commonly
> running 64-bit processors such as the Intel Atom.
> 
> I would like to utilize the ISA bus driver to support these PC/104
> devices (see http://lkml.org/lkml/2016/4/7/418), but the ISA
> configuration option has an arbitrary X86_32 dependency. Decoupling the
> X86_32 dependency from the ISA configuration option will allow these
> PC/104 drivers to build for 64-bit architectures.
> 
> The existing kernel drivers which I intend to utilize the ISA bus driver
> in a X86_64 architecture for PC/104 support are the ACCES 104-DIO-48E
> GPIO driver, the ACCES 104-IDI-48 GPIO driver, the ACCES 104-IDIO-16
> GPIO driver, and the Apex Embedded Systems STX104 DAC driver. I have
> several more PC/104 devices for which I wish to write drivers, but I
> would like to resolve this ISA bus driver situation before submitting
> new code.

Ah, ok, so it's for enabling real hardware, not just a cleanup, right? You might 
want to put that info into the boilerplate mail or so.

I'm perfectly fine with all the patches that touch x86 code:

  Acked-by: Ingo Molnar <mingo@kernel.org>

I suppose you'd like to have these in the driver tree, all in one place?

Thanks,

	Ingo
