From: Javier Marcet <javier@marcet.info>
Subject: Re: PATCH: BLIST flag for non-lockable devices
Date: Mon, 28 Jun 2004 22:24:49 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040628202448.GB27359@marcet.info>
References: <20040627231007.GA12853@marcet.info> <Pine.LNX.4.44L0.0406281150180.1598-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www.marcet.info ([213.60.130.45]:54200 "EHLO mail.marcet.info")
	by vger.kernel.org with ESMTP id S265170AbUF1UYy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Jun 2004 16:24:54 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0406281150180.1598-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Matthew Wheeler <matt@yurisko.net>, Mike Anderson <andmike@us.ibm.com>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

* Alan Stern <stern@rowland.harvard.edu> [040628 17:54]:

>> Yet I wonder why the INQUIRY_36 flag? Isn't it the default? Or you just
>> try to skip the try & failure over longer inquiries since you already
>> know these devices' length?

>It's true that using a 36-byte INQUIRY command is the default.  However
>the BLIST_INQUIRY_36 flag means more than that: It means also that there 
>should _not_ be an INQUIRY command longer than 36 bytes, even if the 
>device says it has extra data available.

I see.

>I've been adding this flag to all the blacklist entries for USB devices,

Yes, I realized that upon first look at the blacklist.

>just for safety.  With most of them it's not needed.  But I have seen an
>example of a device which said that it had 37 bytes of INQUIRY data and
>then crashed when it received a command asking for all 37 bytes.

Ditto then, it works without a hitch -I only wish USB 1.1 was faster
though, but it's not something at hour hands, sigh-, better being safe
with that flag anyway.

Thanks for your help and time Alan (et all other who helped) :)


-- 
The problem with the gene pool is that there is no lifeguard.

Javier Marcet <javier@marcet.info>
