From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Problem with USB-to-SATA adapters (was: AS2105-based enclosure
 size issues with >2TB HDDs)
Date: Tue, 26 Aug 2014 12:59:18 -0700
Message-ID: <1409083158.3812.66.camel@jarvis.lan>
References: <87801b450dee41dda169a3aa2dd2baf6@serv030.corp.eldorado.org.br>
	 <1408972618.10300.35.camel@linux-fkkt.site>
	 <201408261939.s7QJdg4B013031@hobgoblin.ariadne.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:50721 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753824AbaHZT7U (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Aug 2014 15:59:20 -0400
In-Reply-To: <201408261939.s7QJdg4B013031@hobgoblin.ariadne.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Dale R. Worley" <worley@alum.mit.edu>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, 2014-08-26 at 15:39 -0400, Dale R. Worley wrote:
> This is almost certainly a form of the problem reported in
> "AS2105-based enclosure size issues with >2TB HDDs".  I'm repeating my
> original message here so linux-usb can see it, and so it can be
> connected to the older thread.  I'll address it in another message.

Did you try read capacity 16 on it?  What happened?  (the AS2105 rejects
read capacity 16, so there's no reliable way to deduce the capacity of
drives over 2TB).

James


