From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Question on oddball use of SCSI
Date: 22 Oct 2002 17:58:08 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1035305888.31873.99.camel@irongate.swansea.linux.org.uk>
References: <EA37C22921B7D611AF5200508B949B5A4594F8@atlanta_nt2.atlanta.glenayre.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <EA37C22921B7D611AF5200508B949B5A4594F8@atlanta_nt2.atlanta.glenayre.com>
List-Id: linux-scsi@vger.kernel.org
To: "Plotky, Jon" <Jon.Plotky@Glenayre.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

On Tue, 2002-10-22 at 17:33, Plotky, Jon wrote:
> I'm running RedHat 7.2 on an Intel Langley computer.  The box has a SCSI
> host adapter and a special purpose I/O card on the same PCI bus.  I want to
> set up data transfers directly from the SCSI host adapter to the I/O card's
> memory, without passing the data through the host CPU.  The idea is to use
> standard Linux I/O system calls, but give the buffer address of the I/O card
> on the PCI bus instead of a user space memory address.

If you mmap the pci space and use O_DIRECT I/O or scsi generic then
current kernels ought to do this ok. There are -lots- of chipset issues
but it sounds like you have a controlled environment. 

You will want a recent kernel (eg 7.2 latest errata)

