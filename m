From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 13/17] drivers/scsi/initio.c: suppress compile warning
Date: Fri, 28 Mar 2008 15:13:16 -0700
Message-ID: <20080328151316.58c43596.akpm@linux-foundation.org>
References: <200803282148.m2SLmfg7012252@imap1.linux-foundation.org>
	<da824cf30803281455g22334554y8cb3887beec951a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37572 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752897AbYC1WN0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Mar 2008 18:13:26 -0400
In-Reply-To: <da824cf30803281455g22334554y8cb3887beec951a@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Grant Grundler <grundler@google.com>
Cc: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On Fri, 28 Mar 2008 14:55:28 -0700
"Grant Grundler" <grundler@google.com> wrote:

> On Fri, Mar 28, 2008 at 2:48 PM,  <akpm@linux-foundation.org> wrote:
> > From: Andrew Morton <akpm@linux-foundation.org>
> >
> >  powerpc:
> >
> >  drivers/scsi/initio.c: In function 'initio_build_scb':
> >  drivers/scsi/initio.c:2585: warning: large integer implicitly truncated to unsigned type
> 
> I posted a fix for this yesterday and Alan Cox ACKed it.

Oh well, I droped this one then.

> It's here:
>     http://marc.info/?l=linux-scsi&m=120668352622659&w=2

And there it will probably stay.  Please send me a copy if you want to
delegate the send-it-until-it-sticks slog.

