From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: PATCH: exclude certain commands from emulated SCSI hosts
Date: 22 Apr 2003 14:41:00 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1051040463.1768.82.camel@mulgrave>
References: <UTC200304221930.h3MJUxI21015.aeb@smtp.cwi.nl>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:10758 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263384AbTDVT3m (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Apr 2003 15:29:42 -0400
In-Reply-To: <UTC200304221930.h3MJUxI21015.aeb@smtp.cwi.nl>
List-Id: linux-scsi@vger.kernel.org
To: Andries.Brouwer@cwi.nl
Cc: stern@rowland.harvard.edu, afafc@rnl.ist.utl.pt, Alan Cox <alan@lxorguk.ukuu.org.uk>, greg@kroah.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-usb-devel@lists.sourceforge.net, mdharm-scsi@one-eyed-alien.net, mike@hingston.demon.co.uk, steliam@popies.net, torvalds@transmeta.com, usb-storage@one-eyed-alien.net

On Tue, 2003-04-22 at 14:30, Andries.Brouwer@cwi.nl wrote:
> That is a pity, because my 4 was arrived at by careful experimentation.
> It may mean that there is no uniform length that works.
> And no amount of filtering will work, unless we decide
> not to use MODE_SENSE at all.

Well, actually, we could do the filter in the same place that converts
the MODE SENSE(6) to MODE SENSE(10) (drivers/usb/storage/protocol.c). 
If it just returns an error when len < 8 we will drop through to the 255
byte request quickly which, on the 2.4 evidence, should work.

> But let us first confirm the theory.

Agreed.

James


