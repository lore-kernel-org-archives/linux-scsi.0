From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 0/4] Fastboot revisited: Asynchronous function calls
Date: Mon, 5 Jan 2009 13:13:50 -0800
Message-ID: <20090105131350.66408a4f@infradead.org>
References: <20090104092430.7ffd2c41@infradead.org>
	<alpine.LFD.2.00.0901041009060.3179@localhost.localdomain>
	<20090104103104.6fdda9f2@infradead.org>
	<alpine.LFD.2.00.0901041038570.3179@localhost.localdomain>
	<20090104110559.306186c4@infradead.org>
	<20090105162125.093b4adf@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20090105162125.093b4adf@lxorguk.ukuu.org.uk>
Sender: linux-ide-owner@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, mingo@elte.hu, fweisbec@gmail.com, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org, akpm@linux-foundation.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 5 Jan 2009 16:21:25 +0000
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > Right now I don't think I have time for it (this is going to take
> > time.. there's so many weird things with serial ports that it's
> > bound to break stuff in the beginning etc)
> 
> I can't duplicate this. Can you check you don't have
> 
> config SERIAL_8250_DETECT_IRQ
>         bool "Autodetect IRQ on standard ports (unsafe)"
>         depends on SERIAL_8250_EXTENDED
>         help
>           Say Y here if you want the kernel to try to guess which IRQ
>           to use for your serial port.
> 
>           This is considered unsafe; it is far better to configure the
> IRQ in a boot script using the setserial command.
> 
>           If unsure, say N.
> 
> 
> enabled
> 
ok I had that enabled somehow....
retesting now


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
