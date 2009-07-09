From: Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: mptsas, msi and the dl585 g2
Date: Thu, 9 Jul 2009 14:12:36 -0700
Message-ID: <86802c440907091412n3157775ft4c025aab595923ad@mail.gmail.com>
References: <20090630180300.GA9971@ldl.fc.hp.com> <4A4A5B01.9040200@kernel.org>
	 <20090703225708.GA30664@ldl.fc.hp.com> <4A4FADDC.30606@kernel.org>
	 <20090709185945.GG2613@ldl.fc.hp.com> <4A564263.5010305@kernel.org>
	 <4A564634.1020708@kernel.org> <4A564990.3060202@kernel.org>
	 <1247172044.3898.147.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756371AbZGIVTP@vger.kernel.org>
In-Reply-To: <1247172044.3898.147.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: dann frazier <dannf@hp.com>, linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jul 9, 2009 at 1:40 PM, James
Bottomley<James.Bottomley@hansenpartnership.com> wrote:
> On Thu, 2009-07-09 at 12:48 -0700, Yinghai Lu wrote:
>> [ =A0 =A04.333140] =A0 PREFETCH window: 0x00000000d9f00000-0x0000000=
0d9ffffff
>> are all directed to one 8132 PCI-X bridge.
>>
>> the the IOAPIC for 9, 10, 11... falling that range...
>>
>> we need one better to allocate range for that pci-x bridge to aovide=
 ioapic BAR allocated...
>>
>> anyway your BIOS sucks.
>
> It's a sad and very annoying fact of life that most BIOSs suck. =A0If=
 they
> didn't suck, our bios handling code wouldn't be a nasty mess of
> exceptions, work arounds and quirks.
>
> Can we fix this so that both the DL585 and the opteron multi root stu=
ff
> can work? =A0There's a large population of DL585's out there, so we c=
an't
> release 2.6.32 like this ... and I'd rather not have to choose betwee=
n
> breaking the DL585's and breaking the Sun Opterons.

sure. will send out one patch after get some sanity test here.

YH
