From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: Conversion to generic boolean
Date: Mon, 28 Aug 2006 12:58:13 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0608281255100.14305@yvahk01.tjqt.qr>
References: <44EFBEFA.2010707@student.ltu.se> <20060828093202.GC8980@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailer.gwdg.de ([134.76.10.26]:13457 "EHLO mailer.gwdg.de")
	by vger.kernel.org with ESMTP id S964803AbWH1LBE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Aug 2006 07:01:04 -0400
In-Reply-To: <20060828093202.GC8980@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Richard Knutsson <ricknu-0@student.ltu.se>, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org


>> Just would like to ask if you want patches for:
>
>Total NACK to any of this boolean ididocy.  I very much hope you didn't
>get the impression you actually have a chance to get this merged.
>
>> * (Most importent, may introduce bugs if left alone)
>> Fixing boolean checking, ex:
>> if (bool == FALSE)
>> to
>> if (!bool)
>
>this one of course makes sense, but please do it without introducing
>any boolean type.  Getting rid of all the TRUE/FALSE defines and converting
>all scsi drivers to classic C integer as boolean semantics would be
>very welcome janitorial work.

I don't get it. You object to the 'idiocy' 
(http://lkml.org/lkml/2006/7/27/281), but find the x==FALSE -> !x 
a good thing?


Jan Engelhardt
-- 
