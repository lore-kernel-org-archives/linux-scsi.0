From: Masanori Goto <gotom@sanori.org>
Subject: Re: [PATCH 425/493] scsi: remove use of __devexit
Date: Fri, 23 Nov 2012 20:27:42 +0900
Message-ID: <CALZLnaFcLwhNnvr5Hpia7tJkyJYmH-aj5GfHJxF8OS=uDkxoFQ@mail.gmail.com>
References: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
 <1353349642-3677-425-git-send-email-wfp5p@virginia.edu> <Pine.LNX.4.64.1211230845540.14984@axis700.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:59625 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134Ab2KWL2D (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Nov 2012 06:28:03 -0500
Received: by mail-lb0-f174.google.com with SMTP id gi11so4134581lbb.19
        for <linux-scsi@vger.kernel.org>; Fri, 23 Nov 2012 03:28:02 -0800 (PST)
In-Reply-To: <Pine.LNX.4.64.1211230845540.14984@axis700.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Bill Pemberton <wfp5p@virginia.edu>, gregkh@linuxfoundation.org, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, Matthew Wilcox <matthew@wil.cx>, Russell King <linux@arm.linux.org.uk>, Oliver Neukum <oliver@neukum.org>, Ali Akcaagac <aliakc@web.de>, Jamie Lenehan <lenehan@twibble.org>, Neela Syam Kolli <megaraidlinux@lsi.com>, YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>, Michael Reed <mdr@sgi.com>, Kurt Garloff <garloff@suse.de>, linux-scsi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, dc395x@twibble.org, iss_storagedev@hp.com

2012/11/23 Guennadi Liakhovetski <g.liakhovetski@gmx.de>:
> On Mon, 19 Nov 2012, Bill Pemberton wrote:
>
>> CONFIG_HOTPLUG is going away as an option so __devexit is no
>> longer needed.
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
