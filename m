From: Takahiro Yasui <tyasui@redhat.com>
Subject: Re: [RFC][PATCH] Introduce the parameter to limit scsi timeout count
Date: Tue, 02 Jun 2009 16:48:06 -0400
Message-ID: <4A259006.2040203@redhat.com>
References: <4A2428B5.9000701@redhat.com> <1243886558.4203.31.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:52442 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776AbZFBUpG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Jun 2009 16:45:06 -0400
In-Reply-To: <1243886558.4203.31.camel@mulgrave.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org

Hi James,

James Bottomley wrote:
> It doesn't really look like a good solution to the problem you're
> describing, particularly if it's just a few isolated arrays.
> 
> The code you propose would certainly catch things like usb devices which
> are known for random timeouts; plus a lot of SCSI/ATA devices suffer
> isolated timeouts because of I/O load.  Global code like this could end
> up offlining them.
> 
> Which arrays are these, and what's the taxonomy of the failure ... if
> TUR succeeds, perhaps there's another command for the arrays we could
> send that would fail or timeout ... or perhaps there's a different way
> they should be recovered.

Thank you for the comments. I believe that this issue is not specific
to a few storages but is a general issue on a HDD storages. Therefore,
I think that adding a max timeout count on each device is one of
solutions to servers which are sensitive to delay.

But I got your point. I will try to find an implementation to not
affect other devices.

Thanks,
---
Takahiro Yasui
Hitachi Computer Products (America), Inc.

