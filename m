From: "Rodrigo Severo" <rodrigo@fabricadeideias.com>
Subject: Re: Adaptec 29320LPE errors on boot
Date: Wed, 5 Mar 2008 13:26:17 -0300
Message-ID: <a7108f870803050826j574197bcre980fbf0b8e5f5d9@mail.gmail.com>
References: <a7108f870803050742x6a960bf4sed894208a5fb3931@mail.gmail.com>
	 <1204732523.3047.27.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.184]:15685 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788AbYCEQ0U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Mar 2008 11:26:20 -0500
Received: by rv-out-0910.google.com with SMTP id k20so949118rvb.1
        for <linux-scsi@vger.kernel.org>; Wed, 05 Mar 2008 08:26:17 -0800 (PST)
In-Reply-To: <1204732523.3047.27.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On 3/5/08, James Bottomley <James.Bottomley@hansenpartnership.com> wrot=
e:
> On Wed, 2008-03-05 at 12:42 -0300, Rodrigo Severo wrote:
>  > I have this Adaptec 29320LPE SCSI board (used the aic79xx driver)
>  > which give several errors during boot time, just after it recogniz=
es
>  > the HDs connected to it.
>  >
>  > If I remove the SCSI HD there are no SCSI errors.
>  >
>  > The very first error messages have scrolled up and I don't know ho=
w to
>  > get to them (is there a way?)
>
>
> If you can get it to boot (say to a ramdisk with a shell) then dmesg
>  gives them ... otherwise you need a serial console.

I managed to get the first error messages:

Attempting to Queue an Abort message: CDB 0x3c 0xa 0x0 0x0 0x0 0x0 0x0 =
0xfc 0x0
scsi0: hwerrint, Discard Timer has timed out
scsi0: hwerrint, Illegal Opcode in sequencer program

then it gets to the messages I included in my previous message.

>  >  but here is the transcript of what I can
>  > see:
>  >
>  > scsi0: hwerrint, Sequencer Parity Error
>  > scsi0: hwerrint, Data-path Parity Error
>  > scsi0: hwerrint, Scratch or SCB Memory Parity Error
>  > scsi0: hwerrint, CIOBUS Parity Error
>
>
> That's a pretty comprehensive sequence of parity errors.  Assuming
>  they're the root cause rather than something caused by the first err=
or:
>  best case, you just need a better cable or termination;

I don't think so (please see my answer to Mark Salyzyn's message).

> worst case, your
>  card is actually hosed in its internal data path.

I also don't think so because I get this same exact error if I try
this SCSI board on three different motherboard models BUT there is one
fourth model where I don't get these errors. Some info on the "working
motherboard":

# lspci
00:00.0 RAM memory: nVidia Corporation MCP61 Memory Controller (rev a1)
00:01.0 ISA bridge: nVidia Corporation MCP61 LPC Bridge (rev a2)
00:01.1 SMBus: nVidia Corporation MCP61 SMBus (rev a2)
00:01.2 RAM memory: nVidia Corporation MCP61 Memory Controller (rev a2)
00:02.0 USB Controller: nVidia Corporation MCP61 USB Controller (rev a2=
)
00:04.0 PCI bridge: nVidia Corporation MCP61 PCI bridge (rev a1)
00:06.0 IDE interface: nVidia Corporation MCP61 IDE (rev a2)
00:08.0 IDE interface: nVidia Corporation MCP61 SATA Controller (rev a2=
)
00:09.0 PCI bridge: nVidia Corporation MCP61 PCI Express bridge (rev a2=
)
00:0b.0 PCI bridge: nVidia Corporation MCP61 PCI Express bridge (rev a2=
)
00:0c.0 PCI bridge: nVidia Corporation MCP61 PCI Express bridge (rev a2=
)
00:0d.0 VGA compatible controller: nVidia Corporation GeForce 6100
nForce 430 (rev a2)
00:18.0 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] HyperTransport Technology Configuration
00:18.1 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] Address Map
00:18.2 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] DRAM Controller
00:18.3 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] Miscellaneous Control
01:06.0 SCSI storage controller: Adaptec AHA-3960D / AIC-7899A U160/m (=
rev 01)
01:06.1 SCSI storage controller: Adaptec AHA-3960D / AIC-7899A U160/m (=
rev 01)
01:07.0 Ethernet controller: 3Com Corporation 3c905C-TX/TX-M [Tornado] =
(rev 78)
04:00.0 Ethernet controller: Attansic Technology Corp. L1 Gigabit
Ethernet Adapter (rev b0)

In face of this info on the varying behaviour on different
motherboards and of the info on my asnwer to Mark Salyzyn's message do
you still think this can be a cable/driver/terminator/adapter issue?

I ask because it seems unlikely to me but I don't have that much
experience on SCSI issues.


Regards,

Rodrigo Severo

--=20
-----------------------------------------------------------------------=
----------------
Rodrigo Severo

=46=E1brica de Id=E9ias
SBS Quadra 2 - Bloco S - Ed. Empire Center - Sala 1.301
Bras=EDlia - DF - CEP 70070-904
Tel. (61) 3321-1357       Fax (61) 3223-1712
-----------------------------------------------------------------------=
----------------
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
