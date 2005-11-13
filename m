From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Bug#338089: New aic7xxx driver fails spectacularly on 2940UW
Date: Sat, 12 Nov 2005 22:16:58 -0600
Message-ID: <1131855418.4179.7.camel@mulgrave>
References: <20051109014713.78691.qmail@web88003.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:4781 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751327AbVKMERg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 12 Nov 2005 23:17:36 -0500
In-Reply-To: <20051109014713.78691.qmail@web88003.mail.re2.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Graham Knap <graham.knap@rogers.com>
Cc: Horms <horms@debian.org>, 338089@bugs.debian.org, linux-scsi@vger.kernel.org

On Tue, 2005-11-08 at 20:47 -0500, Graham Knap wrote:
> Target 0 Negotiation Settings
>         User: 40.000MB/s transfers (20.000MHz, offset 127, 16bit)
>         Goal: 40.000MB/s transfers (20.000MHz, offset 8, 16bit)
>         Curr: 40.000MB/s transfers (20.000MHz, offset 8, 16bit)

That's a bit unfortunate ... it shows that the domain validation code
negotiated identical settings in the old kernel, so it doesn't look like
that's the problem.

My best guess would be that the bus is slightly marginal.  The aic7xxx
drivers are notoriously sensitive to bus problems.  Could you try
lowering the bus speed to 10MHz in the aic7xxx bios and see if that
helps?

Thanks,

James


