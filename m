From: "Plotky, Jon" <Jon.Plotky@Glenayre.com>
Subject: Question on oddball use of SCSI
Date: Tue, 22 Oct 2002 12:33:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <EA37C22921B7D611AF5200508B949B5A4594F8@atlanta_nt2.atlanta.glenayre.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

I'm hoping someone on this list is willing to answer a question for me.
I've searched the list archives and Linux newsgroups and haven't found an
answer.  I'm just learning about the Linux SCSI system, and would like to
know that what I'm trying to do is feasible before diving into work on it.
 
The question is whether the SCSI subsystem will support direct DMA of data
to an I/O card on the PCI bus?
 
I'm running RedHat 7.2 on an Intel Langley computer.  The box has a SCSI
host adapter and a special purpose I/O card on the same PCI bus.  I want to
set up data transfers directly from the SCSI host adapter to the I/O card's
memory, without passing the data through the host CPU.  The idea is to use
standard Linux I/O system calls, but give the buffer address of the I/O card
on the PCI bus instead of a user space memory address.

The hd devices will be accessed directly, not through a filesystem.
 
Any comments you can give me will be greatly appreciated.  Thanks in advance
for your time.
 
Regards,
 
Jon Plotky

