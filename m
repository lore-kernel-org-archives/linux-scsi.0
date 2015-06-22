From: Markus Rathgeb <maggu2810@gmail.com>
Subject: Re: [PATCH] USB: storage: add "no SYNCHRONIZE CACHE" quirk
Date: Mon, 22 Jun 2015 20:44:43 +0200
Message-ID: <CAOcK=COj7=akJUhsg2Pfr5aeh_tC9dEL3rZK1yKuvTN0KyJB1A@mail.gmail.com>
References: <1434994588.2237.90.camel@HansenPartnership.com>
	<Pine.LNX.4.44L0.1506221340180.1799-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:33417 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950AbbFVSop (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Jun 2015 14:44:45 -0400
In-Reply-To: <Pine.LNX.4.44L0.1506221340180.1799-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Greg KH <greg@kroah.com>, James Bottomley <JBottomley@parallels.com>, Jun Itou <itou_jun@infoseek.jp>, Matt <vickm78@hotmail.com>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, USB list <linux-usb@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>

>> > Maybe your patch will be acceptable, though.  We'll have to hear from
>> > Markus and Matt.
>>
>> We'll probably have to take this to fsdevel as well ... they might have
>> opinions about whether the FS wants to be informed about flush failure.

So, it is okay to wait for the end of that discussion before I start
further testing or should I test the patch above?
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
