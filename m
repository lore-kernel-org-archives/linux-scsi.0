From: Vasily Averin <vvs@sw.ru>
Subject: Re: megaraid_mbox: garbage in file
Date: Sat, 06 May 2006 03:43:35 +0400
Message-ID: <445BE327.4030104@sw.ru>
References: <445A4C8F.5030204@sw.ru>	 <1146783568.22932.105.camel@mulgrave.il.steeleye.com>	 <445AE4A5.8070202@sw.ru>	 <1146844763.9848.17.camel@mulgrave.il.steeleye.com>  <445B96B9.20100@sw.ru> <1146859509.9848.110.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.233.200]:35202 "EHLO relay.sw.ru")
	by vger.kernel.org with ESMTP id S1751226AbWEEXkZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 May 2006 19:40:25 -0400
In-Reply-To: <1146859509.9848.110.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org, Neela.Kolli@engenio.com, Atul Mukker <Atul.Mukker@lsil.com>, Seokmann.Ju@lsil.com, sreenib@lsil.com, devel@openvz.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

James Bottomley wrote:
> On Fri, 2006-05-05 at 22:17 +0400, Vasily Averin wrote:
>> megaraid mailbox: status:0x0 cmd:0xa7 id:0x25 sec:0x1a
>>                 lba:0x33f624ac addr:0xffffffff ld:128 sg:4
>> scsi cmnd: 0x28 0x00 0x33 0xf6 0x24 0xac 0x00 0x00 0x1a 0x00
>> mbox request_buffer eafde340 use_sg 4
>> mbox sg0: page 077a0474 off 0 addr 1fd575000 len 4096 virt ff15a000
>>                 first 03020100 page->flags 40020101
>> mbox sg1: page 077b5738 off 0 addr 1fdede000 len 4096 virt ff141000
>>                 first 03020100 page->flags 40020101
>> mbox sg2: page 077ad500 off 0 addr 1fdb40000 len 4096 virt ff056000
>>                 first 03020100 page->flags 40020101
>> mbox sg3: page 030d46e8 off 1024 addr 5e6a400 len 1024 virt 07e6a400
>>                 first 03020100 page->flags 20001004
>=20
> The odd thing about this is that the highmem addresses shouldn't have=
 a
> virtual mapping (since nothing should have called kmap on them).

You are right, in the other my experiments highmem pages usually have v=
irt=3D0 and
I cannot find who is kmapped these pages.

I'll investigate this issue later: first =DD=C1 all I'll try to reprodu=
ce this issue
on 2.6.16 kernel.

Thank you,
	Vasily Averin

SWsoft Virtuozzo/OpenVZ Linux kernel team

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
