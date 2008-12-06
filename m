From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH] remove ide-scsi
Date: Sun, 07 Dec 2008 01:52:27 +0300
Message-ID: <493B022B.3050406@ru.mvista.com>
References: <20081203103856S.fujita.tomonori@lab.ntt.co.jp>	<200812061551.08525.bzolnier@gmail.com>	<20081206120001.3580b9e3@tuna>	<200812062241.35601.bzolnier@gmail.com> <20081206222423.04aada70@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from homer.mvista.com ([63.81.120.155]:8528 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752964AbYLFWwg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 6 Dec 2008 17:52:36 -0500
In-Reply-To: <20081206222423.04aada70@lxorguk.ukuu.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, =?ISO-8859-1?Q?Dan_?= =?ISO-8859-1?Q?No=E9?= <dpn@isomerica.net>, James Bottomley <James.Bottomley@hansenpartnership.com>, Christoph Hellwig <hch@infradead.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, osst@riede.org

Hello.

Alan Cox wrote:
>> I think that for the time being it is best to just proceed with the removal
>> and see if there are any users needing the driver (+ we should probably try
>> SCSI/libata/osst path first).
>>     
>
> Far better to just leave it there. It generally works for users so all
> you are doing is creating a regression with no possible benefit (other
> than encouraging people to move to libata so we can obsolete all of
> drivers/ide - which is what we really need to do and move the last few
> users over)
>   

   Oh, yes. SCSI emulation is just what Linux embedded world is asking 
for...

> Alan

MBR, Sergei


