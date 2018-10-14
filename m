From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: move bus (PCI, PCMCIA, EISA, rapdio) config to drivers/
Date: Sun, 14 Oct 2018 08:23:10 +0200 (CEST)
Message-ID: <alpine.DEB.2.21.1810140822540.1438@nanos.tec.linutronix.de>
References: <20181013151016.31674-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181013151016.31674-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>, Matt Porter <mporter@kernel.crashing.org>, Alexandre Bounine <alex.bou9@gmail.com>, Dominik Brodowski <linux@dominikbrodowski.net>, linux-kbuild@vger.kernel.org, linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
List-Id: linux-scsi@vger.kernel.org

On Sat, 13 Oct 2018, Christoph Hellwig wrote:

> Hi all,
> 
> currently every architecture that wants to provide on of the common
> periphal busses needs to add some boilerplate code and include the
> right Kconfig files.   This series instead just selects the presence
> (when needed) and then handles everything in the bus-specific
> Kconfig file under drivers/.

Nice cleanup.

Acked-by: Thomas Gleixner <tglx@linutronix.de>
