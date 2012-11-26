From: Roland Dreier <roland@purestorage.com>
Subject: Re: [PATCH 00/11] First pass at merging Bart's HA work
Date: Mon, 26 Nov 2012 11:22:06 -0800
Message-ID: <CAL1RGDVjTraBAe+7HOGeDqtoy9zC9KSdJ8D7hWqc287vzyfD_g@mail.gmail.com>
References: <cover.1353903448.git.dillowda@ornl.gov> <CAL1RGDU+b4GxEoY0TOvkyJjr0yx=5tFNmAVZ27hVjOOx=n=yJg@mail.gmail.com>
 <1353957308.2681.5.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys010aog108.obsmtp.com ([74.125.245.84]:56595 "HELO
	na3sys010aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755269Ab2KZTW1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Nov 2012 14:22:27 -0500
Received: by mail-pa0-f70.google.com with SMTP id hz11so11147493pad.1
        for <linux-scsi@vger.kernel.org>; Mon, 26 Nov 2012 11:22:26 -0800 (PST)
In-Reply-To: <1353957308.2681.5.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: David Dillow <dillowda@ornl.gov>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Bart Van Assche <bvanassche@acm.org>

> I'm amenable to that, but we do need an agreed patch set, as Roland
> says.  I also hate to apply the pressure, but I suspect -rc7 was the
> last -rc, so I'm expecting the merge window to open on 2/12.

I think the srp_transport bits are all simple and non-controversial.
So at least from my perspective, OK to merge right now, except
that Dave mentioned he screwed up the attribution on one email,
but that should be easy to fix with a quick resend.

 - R.
