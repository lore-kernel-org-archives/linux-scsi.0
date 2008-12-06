From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] remove ide-scsi
Date: Sat, 06 Dec 2008 18:50:16 -0500
Message-ID: <493B0FB8.1010408@garzik.org>
References: <20081203103856S.fujita.tomonori@lab.ntt.co.jp> <493B022B.3050406@ru.mvista.com> <493B0A8E.7000506@garzik.org> <200812070045.42160.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:47014 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753479AbYLFXub (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 6 Dec 2008 18:50:31 -0500
In-Reply-To: <200812070045.42160.bzolnier@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, =?ISO-8859-1?Q?Dan_No=E9?= <dpn@isomerica.net>, James Bottomley <James.Bottomley@hansenpartnership.com>, Christoph Hellwig <hch@infradead.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, osst@riede.org

Bartlomiej Zolnierkiewicz wrote:
> Given five years this is too-less-too-late by my book.  Especially given
> that you are still talking about the "goal" not the actual "code"...

As noted in other reply, libata has been actively moving in that 
direction, by intentionally isolating the SCSI pieces from the rest of 
the code, and by working to get the prerequisites upstream (e.g. block 
layer timeouts).

	Jeff


