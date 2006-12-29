From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: Problem with Linux aic94xx driver
Date: Fri, 29 Dec 2006 13:07:48 -0800 (PST)
Message-ID: <572581.27408.qm@web31808.mail.mud.yahoo.com>
References: <yojbqlm8lhx.fsf@erling.phys.ntnu.no>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31808.mail.mud.yahoo.com ([68.142.207.71]:41302 "HELO
	web31808.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S965158AbWL2VHt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Dec 2006 16:07:49 -0500
In-Reply-To: <yojbqlm8lhx.fsf@erling.phys.ntnu.no>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: terje.rosten@ntnu.no, linux-scsi <linux-scsi@vger.kernel.org>

--- Terje Rosten <terje.rosten@ntnu.no> wrote:
> * Luben Tuikov
> | 
> | In my SAS Stack, I _do not_ have that switch statement in that
> | function.  Apparently you are using "libsas", which is based on an
> | early, early version of my code, which bottomley and his gang of SAS
> | experts appropriated to "maintain".  And as your problem shows has
> | been "fixed" in many ways.
> | 
> | You should complain to them -- I've CC-ed the linux-scsi mailing
> | list.
> 
> Ok, anyway I gave up on the AIC-9410 card, the shop recommended a
> 3ware 9550SX card:
> 
>  http://www.3ware.com/products/serial_ata2-9000.asp
> 
> and indeed it works like a charm with a nice CLI utility as bonus.

Terje,

Sorry to hear that, and I'm glad that you found a solution
which works for you.

   Luben

