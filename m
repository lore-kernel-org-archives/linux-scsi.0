From: "Maciej Rutecki" <maciej.rutecki@gmail.com>
Subject: Re: [Re: Linux 2.6.26-rc2] Write protect on on
Date: Sat, 14 Jun 2008 09:02:07 +0200
Message-ID: <8db1092f0806140002x70629f05xdbefbe1c1c80d77@mail.gmail.com>
References: <8db1092f0806130957r22bf02a4pd5138f67f4ac56dd@mail.gmail.com>
	 <Pine.LNX.4.44L0.0806131312340.2166-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.173]:33672 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839AbYFNHCH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 14 Jun 2008 03:02:07 -0400
Received: by wf-out-1314.google.com with SMTP id 27so4430109wfd.4
        for <linux-scsi@vger.kernel.org>; Sat, 14 Jun 2008 00:02:07 -0700 (PDT)
In-Reply-To: <Pine.LNX.4.44L0.0806131312340.2166-100000@iolanthe.rowland.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jens Axboe <jens.axboe@oracle.com>, Boaz Harrosh <bharrosh@panasas.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

2008/6/13 Alan Stern <stern@rowland.harvard.edu>:

[...]

>
> That patch wasn't meant to help; it wasn't complete.  It was meant to
> stimulate conversation -- and clearly it failed.
>
> Below is a complete patch.  It's very ugly and isn't likely to get
> accepted, but maybe it will convince people to start talking about the
> problem.  Maybe it will offend people's sensibilities so that they will
> just _have_ to chime in, if only to complain about how bad the patch
> is...

[...]

Tested with 2.6.26-rc2 and works fine. Thanks.

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
