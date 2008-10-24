From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [Re: Linux 2.6.28-rc1] scsi 4:0:0:0: timing out command, waited
 22s
Date: Fri, 24 Oct 2008 20:20:02 +0100
Message-ID: <20081024202002.169c8a37@lxorguk.ukuu.org.uk>
References: <8db1092f0810241057j51f0b70eo3cea4499422f0d38@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <8db1092f0810241057j51f0b70eo3cea4499422f0d38@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Maciej Rutecki <maciej.rutecki@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org, SCSI development list <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 24 Oct 2008 19:57:03 +0200
"Maciej Rutecki" <maciej.rutecki@gmail.com> wrote:

> During boot I have this message:
> 
> ata_piix 0000:00:1f.1: version 2.12
> ata_piix 0000:00:1f.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> ata_piix 0000:00:1f.1: setting latency timer to 64

Known bug - RC1 is broken
