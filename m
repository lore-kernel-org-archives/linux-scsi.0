From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] remove ide-scsi
Date: Sat, 6 Dec 2008 23:02:27 +0000
Message-ID: <20081206230227.07b00e2f@lxorguk.ukuu.org.uk>
References: <20081203103856S.fujita.tomonori@lab.ntt.co.jp>
	<200812061551.08525.bzolnier@gmail.com>
	<20081206120001.3580b9e3@tuna>
	<200812062241.35601.bzolnier@gmail.com>
	<20081206222423.04aada70@lxorguk.ukuu.org.uk>
	<493B022B.3050406@ru.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <493B022B.3050406@ru.mvista.com>
Sender: linux-ide-owner@vger.kernel.org
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Dan =?ISO-8859-14?B?Tm/p?= <dpn@isomerica.net>, James Bottomley <James.Bottomley@hansenpartnership.com>, Christoph Hellwig <hch@infradead.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, osst@riede.org
List-Id: linux-scsi@vger.kernel.org

>    Oh, yes. SCSI emulation is just what Linux embedded world is asking 
> for...

Well ATAPI is SCSI emulation (its a sort of pidgin SCSI admittedly).

I'm actually seeing two strands of requests (including from embedded)

- CF only small "dumb as president" type driver that is written to be as
compact as possible and preferably considers IRQs as optional
- Full SATA and NCQ aware platform support.

although the former is growing quieter and it seems the CF formfactor is
just too clunky for embedded nowdays, especially with the horrendously
complex and pricy connector - and is being eliminated by MMC/SD and
friends.

Alan
