From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: slow external firewire drive
Date: Thu, 27 Oct 2005 09:42:25 -0500
Message-ID: <1130424145.3369.4.camel@mulgrave>
References: <20051027015655.GC14010@toucan.gentoo.org>
	 <43608663.7020103@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:9177 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750783AbVJ0Oma (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Oct 2005 10:42:30 -0400
In-Reply-To: <43608663.7020103@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-scsi@vger.kernel.org, Eric Edgar <rocket@gentoo.org>, Matthew Wilcox <matthew@wil.cx>

On Thu, 2005-10-27 at 09:48 +0200, Stefan Richter wrote:
> I did not hear of a serious performance regression with that kernel yet. 
> I tested 2.6.14-rc3 and -rc5 myself but they should behave like -rc4.

Yes, for unrelated reasons, I've done u320 testing with -rc5.  I can
actually get it up to 320MB/s if I read and write entirely from the disk
cache, so I think our current throughput is OK in the generic systems.

James


