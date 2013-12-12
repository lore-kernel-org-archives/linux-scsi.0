From: Peter Chang <dpf@google.com>
Subject: Re: Help with mpt2sas kernel message
Date: Thu, 12 Dec 2013 09:38:41 -0800
Message-ID: <CAF2xp_EbEkaR3+2ac8+yvLVyEw548890tknLDa5yGyRGfp88EQ@mail.gmail.com>
References: <20131212170459.GD13674@animx.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:59328 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674Ab3LLRjD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Dec 2013 12:39:03 -0500
Received: by mail-wg0-f48.google.com with SMTP id z12so771786wgg.3
        for <linux-scsi@vger.kernel.org>; Thu, 12 Dec 2013 09:39:02 -0800 (PST)
In-Reply-To: <20131212170459.GD13674@animx.eu.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

2013/12/12 Wakko Warner <wakko@animx.eu.org>:
> Kernel: vanilla 3.7.2.
>
> I have 2 mpt2sas controllers.  I'm running a md check on the 2 arrays that I
> have (one per card).  I'm seeing this in my kernel log (last 4 lines):
> 2013-12-10 19:52:10 kame kernel:[1558186.193904] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)

'all ncq IOs fail when one ncq io encounters an error'

> I'd also like to know which card mpt2sas0 is.  Is it the one that has the
> lower numbered pci bus?

it's the first controller enumerated on pci, so probably the lowest number.

\p
