From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: State Model for scsi device badness PATCH
Date: 20 Nov 2003 13:02:57 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1069354978.1770.221.camel@mulgrave>
References: <20031120190105.7456.qmail@web13007.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:25093 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262965AbTKTTUe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Nov 2003 14:20:34 -0500
In-Reply-To: <20031120190105.7456.qmail@web13007.mail.yahoo.com>
List-Id: linux-scsi@vger.kernel.org
To: Amit Patel <patelamitv@yahoo.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2003-11-20 at 13:01, Amit Patel wrote:
> I just walked through some of the code and I could
> work around the badness problem by not doing
> get_device if the scsi device is not in running state
> yet. I have attached the patch for scsi_lib.c where I
> do not call get_device if the state is not
> SDEV_RUNNING and similarly do not do put_device if you
> have not done get_device because of the device state.

Ah, I'm sorry, warning light goes off.

The patch is designed to operate on top of Mike Anderson's rework of our
device initialisation code.

http://marc.theaimsgroup.com/?l=linux-scsi&m=106810957502435&w=2

The get_device in the request function causes the badness without this
other patch.

Mike hasn't yet posted an update (hey, this is a hint, Mike) otherwise I
would already have folded it into the bugfixes tree.

James


