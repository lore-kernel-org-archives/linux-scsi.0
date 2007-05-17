From: "Satyam Sharma" <satyam.sharma@gmail.com>
Subject: Re: [PATCH] SCSI: Let users disable SCSI_WAIT_SCAN to be built
Date: Thu, 17 May 2007 22:32:30 +0530
Message-ID: <a781481a0705171002m61bdb9e9ka53c38cbe698265e@mail.gmail.com>
References: <1179073116.3723.45.camel@mulgrave.il.steeleye.com>
	 <1179153096.3703.23.camel@mulgrave.il.steeleye.com>
	 <a781481a0705141741u4c2f442dk76c68f757cadc38d@mail.gmail.com>
	 <17841.simon.1179228389@5ec7c279.invalid>
	 <20070515120228.GI10562@parisc-linux.org>
	 <4649E03A.1090004@simon.arlott.org.uk>
	 <20070515172905.GJ10562@parisc-linux.org>
	 <tkrat.99c0f1a1898aa67f@s5r6.in-berlin.de>
	 <464B1886.1060502@s5r6.in-berlin.de>
	 <1179410407.3785.16.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.224]:33430 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754649AbXEQRCb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 May 2007 13:02:31 -0400
Received: by wr-out-0506.google.com with SMTP id 76so687238wra
        for <linux-scsi@vger.kernel.org>; Thu, 17 May 2007 10:02:31 -0700 (PDT)
In-Reply-To: <1179410407.3785.16.camel@mulgrave.il.steeleye.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-scsi@vger.kernel.org, Simon Arlott <simon@fire.lp0.eu>, Dave Jones <davej@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, kernel-packagers@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>

On 5/17/07, James Bottomley <James.Bottomley@steeleye.com> wrote:
> [...]
> Please don't bother ... I really want a more considered way of fixing
> this.  If everyone decides the best way is exposing this to the user,
> then this is the way to do it ... however, I still don't consider this
> argument made out yet.

Neither do I, considering that the user can switch async scanning on
at any later time with the scan=async module option. The absence
of the async scan wait module will only screw things up for him later.

But then I don't consider an argument made out yet for doing this
via a separate module in the first place. scsi_wait_scan just does
_not_ want/deserve/need to be a module.

Of course, whining is useless, and discussions on lkml tend to be
most constructive / progressive only over code, so I'll try and see
if I can learn enough of the code in there to fix a patch to do the
async scan waiting thing using some other mechanism; this
module thing seems just horribly wrong/unnecessary.
