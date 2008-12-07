From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] remove ide-scsi
Date: Sun, 7 Dec 2008 11:40:40 +0000
Message-ID: <20081207114040.24bedc8c@lxorguk.ukuu.org.uk>
References: <20081203103856S.fujita.tomonori@lab.ntt.co.jp>
	<200812061551.08525.bzolnier@gmail.com>
	<20081206120001.3580b9e3@tuna>
	<200812062241.35601.bzolnier@gmail.com>
	<20081206222423.04aada70@lxorguk.ukuu.org.uk>
	<493B022B.3050406@ru.mvista.com>
	<20081206230227.07b00e2f@lxorguk.ukuu.org.uk>
	<493B0867.5020700@ru.mvista.com>
	<20081206233235.2a3f1602@lxorguk.ukuu.org.uk>
	<493B13E6.3010807@ru.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40374 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753505AbYLGLku (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Dec 2008 06:40:50 -0500
In-Reply-To: <493B13E6.3010807@ru.mvista.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Dan =?ISO-8859-14?B?Tm/p?= <dpn@isomerica.net>, James Bottomley <James.Bottomley@hansenpartnership.com>, Christoph Hellwig <hch@infradead.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, osst@riede.org

> > Because the chunks of scsi midlayer we inherit (actually nowdays mostly
> > block) are the pieces you need anyway to do multiple command queues,
> >   
> 
>    Er, what does this term mean? Several queues per device or a tagged 
> queue?

Anything beyond issuing one command at a time. The moment you get errors
with multiple command queues you really need the rest of the block
supporting logic (small bits of which are still in scsi).

>    So, you're just presenting SCSI emulation as a "lesser evil". But 5 
> years seems a long enough term to unbind all that stuff from SCSI.

It's being done bit by bit. I wasn't aware it was a race, I always
thought that being correct, logical, testable and evolutionary bisectable
steps was more important somehow.

Alan
