From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Problem with USB-to-SATA adapters (was: AS2105-based enclosure
 size issues with >2TB HDDs)
Date: Wed, 27 Aug 2014 13:01:55 -0700
Message-ID: <1409169715.10098.1.camel@jarvis.lan>
References: <87801b450dee41dda169a3aa2dd2baf6@serv030.corp.eldorado.org.br>
	 <1408972618.10300.35.camel@linux-fkkt.site>
	 <201408261939.s7QJdg4B013031@hobgoblin.ariadne.com>
	 <1409083158.3812.66.camel@jarvis.lan>
	 <201408271921.s7RJLnRw009577@hobgoblin.ariadne.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:57640 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964967AbaH0UB4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Aug 2014 16:01:56 -0400
In-Reply-To: <201408271921.s7RJLnRw009577@hobgoblin.ariadne.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Dale R. Worley" <worley@alum.mit.edu>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, 2014-08-27 at 15:21 -0400, Dale R. Worley wrote:
> > From: James Bottomley <James.Bottomley@HansenPartnership.com>
> 
> > Did you try read capacity 16 on it?  What happened?  (the AS2105 rejects
> > read capacity 16, so there's no reliable way to deduce the capacity of
> > drives over 2TB).
> 
> OK, I had to track down which package contains sg_readcap.
> 
> The adapter that fails gives this output:
> 
>     # sg_readcap --16 /dev/sdb
>     bad field in READ CAPACITY (16) cdb including unsupported service action

OK, so that's definitely the tame taxonomy.

James


