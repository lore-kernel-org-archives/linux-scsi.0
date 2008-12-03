From: "Willem Riede" <osst@riede.org>
Subject: Re: [PATCH] remove ide-scsi
Date: Wed, 3 Dec 2008 06:31:15 -0700
Message-ID: <150283e90812030531o764b53b8w5bc655085ca4f106@mail.gmail.com>
References: <20081203103856S.fujita.tomonori@lab.ntt.co.jp>
	 <20081203100643.GA29340@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:49903 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbYLCNbR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Dec 2008 08:31:17 -0500
Received: by ey-out-2122.google.com with SMTP id 6so1501178eyi.37
        for <linux-scsi@vger.kernel.org>; Wed, 03 Dec 2008 05:31:15 -0800 (PST)
In-Reply-To: <20081203100643.GA29340@infradead.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, bzolnier@gmail.com, James.Bottomley@hansenpartnership.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, Dec 3, 2008 at 3:06 AM, Christoph Hellwig <hch@infradead.org> wrote:
>
> On Wed, Dec 03, 2008 at 10:38:54AM +0900, FUJITA Tomonori wrote:
> > This is for 2.6.29 (not 2.6.28) as feature-removal-schedule.txt says.
> >
> > It's against linux-next (which seems to has some changes to ide-scsi
> > for 2.6.29 from the ide tree).
>
> Isn't ide-scsi the only way to use ATAPI OnStream tapes supported by
> the osst driver?
>
You are right. There are IDE versions of the OnStream drives that need ide-scsi.
There are also SCSI versions of the OnStream, which work with osst directly.

Regards, Willem Riede.
