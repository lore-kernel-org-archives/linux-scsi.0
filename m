From: Eddie Williams <Eddie.Williams@steeleye.com>
Subject: Re: Patch:  allow devices to restrict start on add
Date: Thu, 22 May 2003 16:36:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200305221636.36387.Eddie.Williams@Steeleye.com>
References: <200305221140.59633.Eddie.Williams@Steeleye.com> <3ECD1747.6060901@rogers.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:46597 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263245AbTEVUcF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 May 2003 16:32:05 -0400
Received: from aslan (aslan.sc.steeleye.com [172.17.6.51])
	by hancock.sc.steeleye.com (8.11.6/linuxconf) with ESMTP id h4MKjAI18064
	for <linux-scsi@vger.kernel.org>; Thu, 22 May 2003 16:45:10 -0400
In-Reply-To: <3ECD1747.6060901@rogers.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Thursday 22 May 2003 02:30 pm, Luben Tuikov wrote:
> Eddie Williams wrote:
> > When a SCSI disk is added and it returns a NOT READY the SD driver is
> > automatically sending a START_UNIT command to spin the device up.  While
> > this may be the desired behavior for many if not most devices not all
> > devices either want or need this.
>
> Eddie,
>
> Could you please report what the ASC is when NOT READY is
> returned in this particular situation? (ASCQ should be 0)

Sense_Key=2 Not Ready
ASC: 0x04, ASQ: 0x02 Logical Unit Not Ready, Initializing Command Required

>
> Maybe the ASC can be used for fine graining (and thus generalizing a rule),
> rather than just adding another entry to the black list.

I had already mentioned to the vendor that returning 3 would avoid the start 
unit but this hardware has been doing this for a long time so with the 
concern of breaking something else my suggestion was not accepted.


Eddie

