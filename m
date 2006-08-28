From: Bernd Petrovitsch <bernd@firmix.at>
Subject: Re: Conversion to generic boolean
Date: Mon, 28 Aug 2006 13:11:54 +0200
Message-ID: <1156763514.22346.7.camel@tara.firmix.at>
References: <44EFBEFA.2010707@student.ltu.se>
	 <20060828093202.GC8980@infradead.org>
	 <Pine.LNX.4.61.0608281255100.14305@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.firmix.at ([62.141.48.66]:19152 "EHLO ns.firmix.at")
	by vger.kernel.org with ESMTP id S964780AbWH1LQ3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Aug 2006 07:16:29 -0400
In-Reply-To: <Pine.LNX.4.61.0608281255100.14305@yvahk01.tjqt.qr>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Christoph Hellwig <hch@infradead.org>, Richard Knutsson <ricknu-0@student.ltu.se>, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, 2006-08-28 at 12:58 +0200, Jan Engelhardt wrote:
> >> Just would like to ask if you want patches for:
> >
> >Total NACK to any of this boolean ididocy.  I very much hope you didn't
> >get the impression you actually have a chance to get this merged.
> >
> >> * (Most importent, may introduce bugs if left alone)
> >> Fixing boolean checking, ex:
> >> if (bool == FALSE)
> >> to
> >> if (!bool)
> >
> >this one of course makes sense, but please do it without introducing
> >any boolean type.  Getting rid of all the TRUE/FALSE defines and converting
> >all scsi drivers to classic C integer as boolean semantics would be
> >very welcome janitorial work.
> 
> I don't get it. You object to the 'idiocy' 
> (http://lkml.org/lkml/2006/7/27/281), but find the x==FALSE -> !x 
> a good thing?

If the "if (x == FALSE) { ... }" would be a good thing, why don't we
write "if ((x == FALSE) == TRUE) { ... }"?

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services

