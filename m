From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH] remove ide-scsi
Date: Wed, 10 Dec 2008 20:46:34 +0300
Message-ID: <4940007A.6060603@ru.mvista.com>
References: <20081203103856S.fujita.tomonori@lab.ntt.co.jp> <200812061551.08525.bzolnier@gmail.com> <20081206120001.3580b9e3@tuna> <200812062241.35601.bzolnier@gmail.com> <20081206222423.04aada70@lxorguk.ukuu.org.uk> <493B022B.3050406@ru.mvista.com> <20081206230227.07b00e2f@lxorguk.ukuu.org.uk> <20081209214128.GT25548@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20081209214128.GT25548@parisc-linux.org>
Sender: linux-ide-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Dan No? <dpn@isomerica.net>, James Bottomley <James.Bottomley@hansenpartnership.com>, Christoph Hellwig <hch@infradead.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, osst@riede.org
List-Id: linux-scsi@vger.kernel.org

Hello.

Matthew Wilcox wrote:

>>Well ATAPI is SCSI emulation (its a sort of pidgin SCSI admittedly).

> I'm told (by people who work with embedded people) that first the
> customer says "Oh, I don't need the block layer, I just need MTD", so
> they disable CONFIG_BLOCK, then the customer says "Oh, I need to support
> USB storage", so they re-enable CONFIG_BLOCK, add CONFIG_SCSI and scsi
> disk support and usb-storage.

    That depends. And that is still not the same as SCSI subsys + SCSI disk 
driver + libata SCSI emulation.

> OK, there is now 'ub' so you can do this without SCSI, but still ...

>>I'm actually seeing two strands of requests (including from embedded)
>>
>>- CF only small "dumb as president" type driver that is written to be as

> Just six weeks until you can't make that joke any more ...

    You're frightening me... What's going to happen after these 6 weeks?

MBR, Sergei
