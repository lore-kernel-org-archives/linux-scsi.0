From: Ishikawa <ishikawa@yk.rim.or.jp>
Subject: Re: aic7xxx woes in 2.5
Date: Sun, 15 Dec 2002 22:48:13 +0900
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DFC881D.EAC669A8@yk.rim.or.jp>
References: <3DFC059A.9AA3F75F@digeo.com> <3DFC1BD2.F2F347C9@yk.rim.or.jp> <3DFC25A2.B497FA6@digeo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from yk.rim.or.jp (really [127.0.0.1]) by yk.rim.or.jp
	via smail with esmtp
	id <m18NZ7u-000Gy1C@standard.erephon> (Debian Smail3.2.0.114)
	for <linux-scsi@vger.kernel.org>; Sun, 15 Dec 2002 22:48:14 +0900 (JST)
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@digeo.com>
Cc: linux-scsi@vger.kernel.org

Hi,

> I expect it supports everything.  It is a 1998-vintage Intel
> ad450nx server - these things cost $70,000 in their day.  It
> is built like a battleship.  See
> http://images.google.com/images?hl=en&lr=&ie=ISO-8859-1&q=ad450nx
> 
> But that error is a scsi bus error, not a PCI bus error.
> 
> > ...
> > > scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.5
> > >         <Adaptec 29160 Ultra160 SCSI adapter>
> > >         aic7892: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs
> > >
> >
> > I noticed that you have many disks.
> > Are they in external enclosure?
> 
> They are internal.
> 
> > If not, is the power-supply in your
> > PC box spec'ed to supply enough power?
> 
> It has four power supplies and approximately 13 fans ;)

I agree that you have ample reason to suspect
driver problem, not hardware! :-)

I tried to locate my old posting, but somehow could not find
it in my local folder, but if I recall correctly
mine is certainly the PCI parity error which appeared
somewhere after the PCI_COMMAND_PARITY line in the
startup message below.

> scsi: host order: sym53c8xx:tmscsim
> sym53c8xx: at PCI bus 0, device 12, function 0
> sym53c8xx: setting PCI_COMMAND_PARITY...(fix-up)
> sym53c8xx: 53c895 detected with Tekram NVRAM
> sym53c895-0: rev 0x1 on pci bus 0 device 12 function 0 irq 10
> sym53c895-0: Tekram format NVRAM, ID 7, Fast-40, Parity Checking
> sym53c895-0: SCSI bus mode change from 80 to 80.
> scsi0 : sym53c8xx-1.7.3c-20010512
> sym53c895-0-<4,*>: FAST-20 WIDE SCSI 40.0 MB/s (50.0 ns, offset 15)
> sym53c895-0-<6,*>: FAST-20 WIDE SCSI 40.0 MBu (50.0 ns, offset 31)

Again, possibly the high(er) speed of I/O might
affect the electrical cable condition, but
given the hardware you have, I trust that
you have high-quality cable and terminator, and
so maybe someone who is familiar with the driver code
can help us here.


 


-- 
int main(void){int j=2002;/*(c)2002 cishikawa. */
char t[] ="<CI> @abcdefghijklmnopqrstuvwxyz.,\n\"";
char *i ="h>qtCIuqivb,gCwe\np@.ietCIuqi\"tqkvv is>dnamz";
while(*i)((j+=strchr(t,*i++)-(int)t),(j%=sizeof t-1),
(putchar(t[j])));return 0;}/* under GPL */
