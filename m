From: Andy Rudoff <andy@rudoff.com>
Subject: Re: [LSF/MM TOPIC] atomic block device
Date: Sat, 15 Feb 2014 11:15:28 -0700
Message-ID: <CABBL8E+dQPi=N108+z97F54o=xg7vYk5T1JCBGY+9UetiC6qTg@mail.gmail.com>
References: <CAA9_cmf7Y1TL8XqR7dYUn=Pv-En2e0X0FM0zdpkiBkUuNBGKfQ@mail.gmail.com>
 <1392487335.2178.5.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ie0-f175.google.com ([209.85.223.175]:63440 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469AbaBOSPt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 15 Feb 2014 13:15:49 -0500
Received: by mail-ie0-f175.google.com with SMTP id at1so2175277iec.6
        for <linux-scsi@vger.kernel.org>; Sat, 15 Feb 2014 10:15:48 -0800 (PST)
In-Reply-To: <1392487335.2178.5.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Dan Williams <dan.j.williams@intel.com>, lsf-pc@lists.linux-foundation.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, jmoyer@redhat.com, david@fromorbit.com, Chris Mason <clm@fb.com>, Jens Axboe <axboe@kernel.dk>, Bryan E Veal <bryan.e.veal@intel.com>, Annie Foong <annie.foong@intel.com>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Lameter <christoph@lameter.com>

> OK, I'm prepared to look through it, but I should warn you that after
> the SNIA HBAAPI cluster fuck I'm not well disposed towards any APIs that
> come out of SNIA.  I've read the first 30 pages and they don't inspire
> confidence; it's basically going the same way as HBA API.  The failure
> there was trying to define universal interfaces for every OS regardless
> of the existing interfaces they currently had.  this NVM model seems to
> define a lot of existing stuff in block and VFS but slightly
> differently.  Why do you think it's a good idea?

Note that the NVMP workgroup did not define any APIs.  Instead, we
concentrated on defining the actions that we see applications needing
(or being able to use) and defining some common terminology.  We leave
the API defintion to the operating system authors so they can create
them in the way that makes the most sense for their environment (much
like you are suggesting above, I think).

> I'll further add  what we really need are use cases, not an API
> chocolate box.  I think some DB people will be coming to LSF, so we
> should really talk use cases with them.

Totally agree.

-andy
