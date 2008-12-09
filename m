From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] remove ide-scsi
Date: Tue, 9 Dec 2008 14:41:29 -0700
Message-ID: <20081209214128.GT25548@parisc-linux.org>
References: <20081203103856S.fujita.tomonori@lab.ntt.co.jp> <200812061551.08525.bzolnier@gmail.com> <20081206120001.3580b9e3@tuna> <200812062241.35601.bzolnier@gmail.com> <20081206222423.04aada70@lxorguk.ukuu.org.uk> <493B022B.3050406@ru.mvista.com> <20081206230227.07b00e2f@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20081206230227.07b00e2f@lxorguk.ukuu.org.uk>
Sender: linux-ide-owner@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Dan No? <dpn@isomerica.net>, James Bottomley <James.Bottomley@hansenpartnership.com>, Christoph Hellwig <hch@infradead.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, osst@riede.org
List-Id: linux-scsi@vger.kernel.org

On Sat, Dec 06, 2008 at 11:02:27PM +0000, Alan Cox wrote:
> >    Oh, yes. SCSI emulation is just what Linux embedded world is asking 
> > for...
> 
> Well ATAPI is SCSI emulation (its a sort of pidgin SCSI admittedly).

I'm told (by people who work with embedded people) that first the
customer says "Oh, I don't need the block layer, I just need MTD", so
they disable CONFIG_BLOCK, then the customer says "Oh, I need to support
USB storage", so they re-enable CONFIG_BLOCK, add CONFIG_SCSI and scsi
disk support and usb-storage.

OK, there is now 'ub' so you can do this without SCSI, but still ...

> I'm actually seeing two strands of requests (including from embedded)
> 
> - CF only small "dumb as president" type driver that is written to be as

Just six weeks until you can't make that joke any more ...

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
