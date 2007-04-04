From: "Willem Riede" <wrlk@riede.org>
Subject: Re: Linux tape drivers
Date: Wed, 4 Apr 2007 12:22:35 -0700
Message-ID: <150283e90704041222v1d8554b6lcb5a6771d4a031b4@mail.gmail.com>
References: <200704031508.37222.kern@sibbald.com>
	 <20070403145728.d8f83320.akpm@linux-foundation.org>
	 <150283e90704032000p7f447a26pe3752b22024a1b67@mail.gmail.com>
	 <200704041626.15298.kern@sibbald.com>
	 <20070404115536.fd752555.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.245]:62906 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934084AbXDDTWg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Apr 2007 15:22:36 -0400
Received: by an-out-0708.google.com with SMTP id b33so365847ana
        for <linux-scsi@vger.kernel.org>; Wed, 04 Apr 2007 12:22:35 -0700 (PDT)
In-Reply-To: <20070404115536.fd752555.akpm@linux-foundation.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kern Sibbald <kern@sibbald.com>, Kai Makisara <Kai.Makisara@kolumbus.fi>, linux-scsi@vger.kernel.org

On 4/4/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Wed, 4 Apr 2007 16:26:14 +0200 Kern Sibbald <kern@sibbald.com> wrote:
>
> >  I'm all in favor of deprecating ide-tape if ide-scsi is a viable alternative,
>
> ow.  ide-scsi is in very bad shape and nobody is maintaining it or fixing
> bugs in it or anything.  The only reason we retain ide-scsi at all is, err,
> because some tape drives need it.
>
> If we have no alternative to using ide-scsi, and if the tape controllers in
> question are not some terribly obscure things which nobody would seriously
> use then we have a bit of a problem.  I don't know of anyone who we can
> turn to to get anything done in ide-scsi.

Andrew,

Kai suggests that libata should be able to take over from ide-scsi.
Do you concur? That may be a better way forward than ide-scsi.
I know, because I had a hard enough time with it when I needed
to fix it so it worked for osst, at least.

Regards, Willem Riede.
