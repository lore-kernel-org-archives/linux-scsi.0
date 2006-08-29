From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: Conversion to generic boolean
Date: Tue, 29 Aug 2006 15:56:31 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0608291556100.16457@yvahk01.tjqt.qr>
References: <44EFBEFA.2010707@student.ltu.se> <20060828093202.GC8980@infradead.org>
 <Pine.LNX.4.61.0608281255100.14305@yvahk01.tjqt.qr> <44F2DEDC.3020608@student.ltu.se>
 <1156792540.2367.2.camel@entropy> <20060829114143.GB4076@infradead.org>
 <Pine.LNX.4.61.0608291416370.8031@yvahk01.tjqt.qr> <44F44072.4020506@bigpond.net.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailer.gwdg.de ([134.76.10.26]:36328 "EHLO mailer.gwdg.de")
	by vger.kernel.org with ESMTP id S964980AbWH2OCS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Aug 2006 10:02:18 -0400
In-Reply-To: <44F44072.4020506@bigpond.net.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Peter Williams <pwil3058@bigpond.net.au>
Cc: Christoph Hellwig <hch@infradead.org>, Nicholas Miell <nmiell@comcast.net>, Richard Knutsson <ricknu-0@student.ltu.se>, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org


>> But, it coerces the rvalue into 0 or 1, which may be a gain.
>
> Actually, it's not coercion.  It's the result of evaluating the value as a
> boolean expression.

Don't be such a linguist :p



Jan Engelhardt
-- 
