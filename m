From: Masanori Goto <gotom@sanori.org>
Subject: Re: [PATCH 097/493] scsi: remove use of __devexit_p
Date: Fri, 23 Nov 2012 20:27:14 +0900
Message-ID: <CALZLnaErqPjtqbH5SROWjs-iAngXNFFr-f41K_a=9Akp4Aaudg@mail.gmail.com>
References: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
 <1353349642-3677-97-git-send-email-wfp5p@virginia.edu> <Pine.LNX.4.64.1211230000500.11581@axis700.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:64430 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207Ab2KWL1g (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Nov 2012 06:27:36 -0500
Received: by mail-la0-f46.google.com with SMTP id p5so4253385lag.19
        for <linux-scsi@vger.kernel.org>; Fri, 23 Nov 2012 03:27:34 -0800 (PST)
In-Reply-To: <Pine.LNX.4.64.1211230000500.11581@axis700.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Bill Pemberton <wfp5p@virginia.edu>, gregkh@linuxfoundation.org, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, Matthew Wilcox <matthew@wil.cx>, Russell King <linux@arm.linux.org.uk>, Oliver Neukum <oliver@neukum.org>, Ali Akcaagac <aliakc@web.de>, Jamie Lenehan <lenehan@twibble.org>, Neela Syam Kolli <megaraidlinux@lsi.com>, YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>, Michael Reed <mdr@sgi.com>, Willem Riede <osst@riede.org>, =?ISO-8859-1?Q?Kai_M=E4kisara?= <Kai.Makisara@kolumbus.fi>, Kurt Garloff <garloff@suse.de>, Arvind Kumar <arvindkumar@vmware.com>, VMware PV-Drivers <pv-drivers@vmware.com>, linux-scsi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, dc395x@twibble.org, iss_storagedev@hp.com, osst-users@lists.sourceforge.net

2012/11/23 Guennadi Liakhovetski <g.liakhovetski@gmx.de>:
> On Mon, 19 Nov 2012, Bill Pemberton wrote:
>
>> CONFIG_HOTPLUG is going away as an option so __devexit_p is no longer
>> needed.
>
>>  drivers/scsi/tmscsim.c                    | 2 +-
>
> Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Acked-by: GOTO Masanori <gotom@debian.or.jp>

Regards,
-- gotom

>
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
>
