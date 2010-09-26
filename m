From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] SCSI: remove noop in fc_bsg_goose_queue()
Date: Mon, 27 Sep 2010 07:58:33 +0900
Message-ID: <1285541913.2888.71.camel@mulgrave.site>
References: <AANLkTi=LeDERNV8ij6Jj+Z5cT8PRhd+4UqyzBRiBRcP+@mail.gmail.com>
	 <1285083682.16440.36.camel@mulgrave.site>
	 <AANLkTi=mcETa6FfUCE9=J2_m1dS31UTBCdu5i76CAd+F@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36094 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932220Ab0IZW6s (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 26 Sep 2010 18:58:48 -0400
In-Reply-To: <AANLkTi=mcETa6FfUCE9=J2_m1dS31UTBCdu5i76CAd+F@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hillf Danton <dhillf@gmail.com>
Cc: James Smart <james.smart@emulex.com>, linux-scsi@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

On Thu, 2010-09-23 at 23:10 +0800, Hillf Danton wrote:
> On Tue, Sep 21, 2010 at 11:41 PM, James Bottomley
> <James.Bottomley@suse.de> wrote:
> >
> > this code doesn't do anything because there's a bug in it.  If you can
> > work out what it's trying to do, you should be able to fix the bug.
> >
> > James
> >
> What is it, James? Because I could not goto deep sleep with this bug in ear.

Think about it ... it's clearly something to do with the flag ... what
is it?  Google is useful as well as looking in the block source code.
The key would be knowing what the flag does.

James


