From: margitsw@t-online.de (Margit Schubert-While)
Subject: Re: 2.5.70 Adaptec error messages
Date: Thu, 05 Jun 2003 19:03:50 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <5.1.0.14.2.20030605185519.05514098@pop.t-online.de>
References: <5.1.0.14.2.20030605181315.00aed370@pop.t-online.de>
 <5.1.0.14.2.20030605162325.055137f0@pop.t-online.de>
 <5.1.0.14.2.20030605162325.055137f0@pop.t-online.de>
 <5.1.0.14.2.20030605181315.00aed370@pop.t-online.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout08.sul.t-online.com ([194.25.134.20]:14720 "EHLO
	mailout08.sul.t-online.com") by vger.kernel.org with ESMTP
	id S264769AbTFEQuV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Jun 2003 12:50:21 -0400
In-Reply-To: <1597600000.1054831258@aslan.btc.adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: linux-scsi@vger.kernel.org

At 10:40 05.06.2003 -0600, Justin wrote:
> > At 10:01 05.06.2003 -0600, Justin wrote:
> >> Someone is fetching the device serial number without setting the
> >> cmd underflow to 0.  The response length is variable, so telling
> >> the adapter to fail the command when the returned result is less
> >> than the allocated buffer size is counter productive.
> >
> > Hmm, doesn't happen with 2.4.21rc + Justin's driver.
> > Which, for me, would imply the kernel - right ?
> > If so, I will post at linux-kernel.
> > If not, educate me :-)
> >
> > Margit
>
>It is not the driver's fault unless the semantics of the underflow
>field in the SCSI command structure have changed.

I quite agree. I was trying to get at WHO is calling you with an incorrect
parameter. Is it somwhere else in 2.5 or is it possibly a user-space program
(although it doesn't appear with 2.4, so IMHO not likely) ??

Margit

