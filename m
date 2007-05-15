From: "Satyam Sharma" <satyam.sharma@gmail.com>
Subject: Re: Asynchronous scsi scanning
Date: Wed, 16 May 2007 05:19:40 +0530
Message-ID: <a781481a0705151649p4cc61bceqd61d778a67776c7f@mail.gmail.com>
References: <1179073116.3723.45.camel@mulgrave.il.steeleye.com>
	 <a781481a0705140523y789e012bj2ec317565e34366f@mail.gmail.com>
	 <1179153096.3703.23.camel@mulgrave.il.steeleye.com>
	 <a781481a0705141741u4c2f442dk76c68f757cadc38d@mail.gmail.com>
	 <17841.simon.1179228389@5ec7c279.invalid>
	 <20070515120228.GI10562@parisc-linux.org>
	 <4649E03A.1090004@simon.arlott.org.uk>
	 <20070515172905.GJ10562@parisc-linux.org>
	 <a781481a0705151627n18d3be55t6b77885fd7775ffd@mail.gmail.com>
	 <464A4222.4000208@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.171]:36196 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757600AbXEOXtl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 May 2007 19:49:41 -0400
Received: by ug-out-1314.google.com with SMTP id 44so1701997uga
        for <linux-scsi@vger.kernel.org>; Tue, 15 May 2007 16:49:40 -0700 (PDT)
In-Reply-To: <464A4222.4000208@linux.intel.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Simon Arlott <simon@fire.lp0.eu>, James Bottomley <james.bottomley@steeleye.com>, Dave Jones <davej@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, kernel-packagers@vger.kernel.org, "Robert P. J. Day" <rpjday@mindspring.com>

On 5/16/07, Arjan van de Ven <arjan@linux.intel.com> wrote:
> Satyam Sharma wrote:
> >> > >semantics of it (read-only?  read-write?  write-only?
> >
> > Well, it _has_ to be write, don't really care if it's read-write or
> > write-only. I would still prefer read-write, but we can go ahead with
> > write-only too. It doesn't really matter, does it?
>
> just to be devils advocate...
> it should be a read that returns when done,

Heh, yeah. We just need to trigger that scsi_complete_async_scans()
after all ... might as well abuse all intuition on the user's behalf :-)

> and that can be polled

Gaah! :-)

But seriously, though, this sysfs attribute can be implemented
_any which way_. Better for us if we do it the simplest way (and which
taxes the user's intuition the least). Just that Matthew asked so many
questions so I thought I might as well answer them :-)
