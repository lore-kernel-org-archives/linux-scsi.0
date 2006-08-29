From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Conversion to generic boolean
Date: Tue, 29 Aug 2006 13:48:20 +0100
Message-ID: <1156855700.6271.104.camel@localhost.localdomain>
References: <44EFBEFA.2010707@student.ltu.se>
	 <20060828093202.GC8980@infradead.org>
	 <Pine.LNX.4.61.0608281255100.14305@yvahk01.tjqt.qr>
	 <44F2DEDC.3020608@student.ltu.se> <1156792540.2367.2.camel@entropy>
	 <20060829114143.GB4076@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:30173 "EHLO
	lxorguk.ukuu.org.uk") by vger.kernel.org with ESMTP
	id S1751370AbWH2M10 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Aug 2006 08:27:26 -0400
In-Reply-To: <20060829114143.GB4076@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Nicholas Miell <nmiell@comcast.net>, Richard Knutsson <ricknu-0@student.ltu.se>, Jan Engelhardt <jengelh@linux01.gwdg.de>, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Ar Maw, 2006-08-29 am 12:41 +0100, ysgrifennodd Christoph Hellwig:
> gcc lets you happily assign any integer value to bool/_Bool, so unless
> you write sparse support for actually checking things there's not the
> slightest advantage in value range checking.

Not the case: gcc allows you to assign 0 or 1 to an _Bool type object.
When you are "assigning" integers you are merely seeing implicit casting
before the assignment.

Try   int a = 4; _Bool b = a; int c = b; printf("%d\n", c);

Alan

