From: Matthias Andree <ma@dt.e-technik.uni-dortmund.de>
Subject: Re: [BK PATCH] SCSI -rc1 fixes
Date: Mon, 15 Nov 2004 00:54:14 +0100
Message-ID: <m3hdnsvvfd.fsf@merlin.emma.line.org>
References: <1100467267.23710.7.camel@mulgrave> <4197E4B7.3050008@pobox.com>
	<1100473795.23649.26.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from krusty.dt.e-technik.Uni-Dortmund.DE ([129.217.163.1]:15845 "EHLO
	mail.dt.e-technik.uni-dortmund.de") by vger.kernel.org with ESMTP
	id S261341AbUKNXyW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Nov 2004 18:54:22 -0500
In-Reply-To: <1100473795.23649.26.camel@mulgrave> (James Bottomley's message
	of "14 Nov 2004 17:09:49 -0600")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

James Bottomley <James.Bottomley@SteelEye.com> writes:

> On Sun, 2004-11-14 at 17:05, Jeff Garzik wrote:
>> thankyou thankyou :)
>
> I've only been away for *two* weeks .... that's not a very long time
> compared with a linux kernel -rc cycle ...

With like 2,400 change sets since v2.6.9...

Still wondering about SuSE's hwscan issue. Has someone managed to figure
if it uses some ioctl that chokes the sym2 driver or if it hacks the
hardware?

-- 
Matthias Andree
