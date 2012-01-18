From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [LSF/MM TOPIC] linux servers as a storage server - what's missing?
Date: Wed, 18 Jan 2012 18:51:37 +0000
Message-ID: <CAO+b5-qHGLXr7HtzV9R81sk8=h_L2i9-pR+uZ7yrGiKktsGZUQ@mail.gmail.com>
References: <4EF2026F.2090506@redhat.com>
	<CAL1RGDVvSbOjvCFWDSYLm4xRvKftM5OhwEf9pMGrJhjJHxzsaA@mail.gmail.com>
	<4F1706AD.3080405@redhat.com>
	<CAL1RGDXDaeNG_YVC38f4nxvBA+btbypcW=1KyEzm90UQOw3HiQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:44058 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758077Ab2ARSvi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Jan 2012 13:51:38 -0500
In-Reply-To: <CAL1RGDXDaeNG_YVC38f4nxvBA+btbypcW=1KyEzm90UQOw3HiQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <roland@purestorage.com>
Cc: Ric Wheeler <rwheeler@redhat.com>, linux-fsdevel@vger.kernel.org, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Wed, Jan 18, 2012 at 6:46 PM, Roland Dreier <roland@purestorage.com> wrote:
> > Why would you crash is you have device mapper multipath configured to handle
> > path fail over? We have tons of enterprise customers that use that...
>
> cf http://www.spinics.net/lists/linux-scsi/msg56254.html
>
> Basically hot unplug of an sdX can oops on any recent kernel, no
> matter what dm stuff you have on top.
>
> > On the broader topic of error handling and so on, I do agree that is always
> > an area of concern (how many times to retry, how long time outs need to be,
> > when to panic/reboot or propagate up an error code)
>
> Yes, especially the scsi eh stuff escalating to a host reset when
> a single drive has gone bad -- even if the HBA is happily doing IO
> to other drives, we'll kill access to the whole SAS fabric.

With which SCSI low-level diver does that occur and how does the call
stack look like ? I haven't encountered any such issues while testing
the srp-ha patch set. However, I have to admit that the issues
mentioned in the description of commit 3308511 were discovered while
testing the srp-ha patch set.

Bart.
