From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 00/11] First pass at merging Bart's HA work
Date: Mon, 26 Nov 2012 23:15:08 +0400
Message-ID: <1353957308.2681.5.camel@dabdike>
References: <cover.1353903448.git.dillowda@ornl.gov>
	 <CAL1RGDU+b4GxEoY0TOvkyJjr0yx=5tFNmAVZ27hVjOOx=n=yJg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:52341 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754150Ab2KZTP1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Nov 2012 14:15:27 -0500
In-Reply-To: <CAL1RGDU+b4GxEoY0TOvkyJjr0yx=5tFNmAVZ27hVjOOx=n=yJg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <roland@purestorage.com>
Cc: David Dillow <dillowda@ornl.gov>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Bart Van Assche <bvanassche@acm.org>

On Mon, 2012-11-26 at 10:50 -0800, Roland Dreier wrote:
>  - I think the srp_transport stuff should go through linux-scsi /
> James B.
>    instead of my tree, esp. since it's shared with the IBM vscsi stuff
> (I think)
>  - I see Bart had a few comments about a few of your patches, I'll
> wait
>    for you guys to hash that out.

I'm amenable to that, but we do need an agreed patch set, as Roland
says.  I also hate to apply the pressure, but I suspect -rc7 was the
last -rc, so I'm expecting the merge window to open on 2/12.

James


