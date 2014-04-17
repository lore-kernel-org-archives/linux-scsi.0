From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Please help me to review the patch about supporting SATA PM in
 LIBSAS
Date: Thu, 17 Apr 2014 06:19:22 -0700
Message-ID: <1397740762.7417.16.camel@dabdike.int.hansenpartnership.com>
References: <CAP0P+NUR1AAxfGT5artyJeD7NNnkq2R=oHJ06VN3zQiLj9qTFw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:41751 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756778AbaDQNTZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Apr 2014 09:19:25 -0400
In-Reply-To: <CAP0P+NUR1AAxfGT5artyJeD7NNnkq2R=oHJ06VN3zQiLj9qTFw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: xiangliang yu <yxlraid@gmail.com>
Cc: dan.j.williams@intel.com, pmurali@logicube.com, linux-scsi@vger.kernel.org

On Thu, 2014-04-17 at 11:07 +0800, xiangliang yu wrote:
> hi,
> 
> The patch is support SATA PM device and can  find all devices that is
> attached to PM.

By PM you mean Port Multipilier not Power Management ... we can be
easily confused by the acronym, so I'd spell it out.

It also looks like the patch does a bit more: it adds more fine grained
SATA error handling, so in final form it probably should be three
patches: the EH changes, the PMP additions and the mvsas updates to take
advantage of it.

> Until now, i have tested the identified, hot-plug and IO function and
> result is ok except one mvsas timeout issue.
> i'll continue to debug mvsas issue, but i don't know whether the
> libsas code of the patch is ok.
> So, please help me to review the patch if you feel free. thanks!
> the patch is as below:

Your mail system (this time gmail I think) managed to destroy the patch
by reducing all the tabs to a single space, so while it might be OK, I
can't be sure I'm reading it correctly.  You also have a few generic
spelling mistakes like "falied" instead of "failed".

As part of the error handler rewrite, you disconnect
ata_std_error_handler() can we just remove that function now?

James


