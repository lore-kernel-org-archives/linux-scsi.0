From: Javier Marcet <javier@marcet.info>
Subject: Re: PATCH: BLIST flag for non-lockable devices
Date: Mon, 28 Jun 2004 01:10:07 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040627231007.GA12853@marcet.info>
References: <20040623191400.GC1387@us.ibm.com> <Pine.LNX.4.44L0.0406251209580.1147-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www.marcet.info ([213.60.130.45]:37074 "EHLO mail.marcet.info")
	by vger.kernel.org with ESMTP id S264538AbUF0XKJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 Jun 2004 19:10:09 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0406251209580.1147-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Matthew Wheeler <matt@yurisko.net>, Mike Anderson <andmike@us.ibm.com>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

* Alan Stern <stern@rowland.harvard.edu> [040625 18:14]:

>> Since SCSI already has the device list it would seem like we would
>> possibly add a new flag like was done for mode sense. As this is not a
>> transport issue I would assume we would not want to add flags in
>> usb/storage, but handle it in the mid-layer as a SCSI protocol
>> non-compliance.

>Here is a patch that implements this suggestion.  It's rather similar to 
>the one that Javier Marcet wrote back in January, in

>http://marc.theaimsgroup.com/?l=linux-usb-users&m=107345268526718&w=2

>Matthew, does this patch work for your digital camera?

For me, as you probably guessed, this is fine. It works very well with
my iRiver.

Yet I wonder why the INQUIRY_36 flag? Isn't it the default? Or you just
try to skip the try & failure over longer inquiries since you already
know these devices' length?

No complaints no my side anyway. Push it upstream when you see it fit :)


-- 
The entire CHINESE WOMEN'S VOLLEYBALL TEAM all share ONE personality --
and have since BIRTH!!

Javier Marcet <javier@marcet.info>
