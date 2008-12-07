From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH] remove ide-scsi
Date: Sun, 07 Dec 2008 03:19:03 +0300
Message-ID: <493B1677.5090705@ru.mvista.com>
References: <20081203103856S.fujita.tomonori@lab.ntt.co.jp>	<200812061551.08525.bzolnier@gmail.com>	<20081206120001.3580b9e3@tuna>	<200812062241.35601.bzolnier@gmail.com>	<20081206222423.04aada70@lxorguk.ukuu.org.uk>	<493B022B.3050406@ru.mvista.com> <20081206230227.07b00e2f@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from h155.mvista.com ([63.81.120.155]:9287 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753417AbYLGATM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 6 Dec 2008 19:19:12 -0500
In-Reply-To: <20081206230227.07b00e2f@lxorguk.ukuu.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, =?ISO-8859-1?Q?Dan_?= =?ISO-8859-1?Q?No=E9?= <dpn@isomerica.net>, James Bottomley <James.Bottomley@hansenpartnership.com>, Christoph Hellwig <hch@infradead.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, osst@riede.org



Alan Cox wrote:
>>    Oh, yes. SCSI emulation is just what Linux embedded world is asking 
>> for...
>>     
>
> Well ATAPI is SCSI emulation (its a sort of pidgin SCSI admittedly).
>
> I'm actually seeing two strands of requests (including from embedded)
>
> - CF only small "dumb as president" type driver that is written to be as
> compact as possible and preferably considers IRQs as optional
>   

   IDE core seems much closer to the "dumb" driver (not that it's 
actually that dumb :-) at this point. The only thing it lacks for "being 
dumb enough" is the polled mode support... The idea of creating yet 
another driver framework just for dumb CF doesn't appeal to me. And 
liabat iscertainly an overkill. If I only had time to look into adding 
the polled mode support now... and a project needing that (well, Octeon 
did but I wasn't involved and it had a standalone driver at that time)...
   Actually, embedded world is much more diverse in its IDE 
implementations/requirements (you can still encounter a full fledged 
UltraDMA/133 PATA contoller embedded within a modern SoC), even to the 
point of complete perversions. I know of a flash device which claims to 
be IDE compatible (and is indeed registrer level compatible) but only 
supports certain standard commands, but implements internal paritioning 
scheme with reads/writes done by vendor specific commands (not even 
using the standard IDE command execution protocol, IIRC :-).

> Alan
>   

WBR, Sergei


