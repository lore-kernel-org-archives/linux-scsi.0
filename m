From: Roland Dreier <roland@purestorage.com>
Subject: Re: [PATCH 00/11] First pass at merging Bart's HA work
Date: Mon, 26 Nov 2012 10:50:56 -0800
Message-ID: <CAL1RGDU+b4GxEoY0TOvkyJjr0yx=5tFNmAVZ27hVjOOx=n=yJg@mail.gmail.com>
References: <cover.1353903448.git.dillowda@ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys010aog104.obsmtp.com ([74.125.245.76]:38876 "HELO
	na3sys010aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753942Ab2KZSvT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Nov 2012 13:51:19 -0500
Received: by mail-gg0-f198.google.com with SMTP id f4so5646443ggn.1
        for <linux-scsi@vger.kernel.org>; Mon, 26 Nov 2012 10:51:18 -0800 (PST)
In-Reply-To: <cover.1353903448.git.dillowda@ornl.gov>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Dillow <dillowda@ornl.gov>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Bart Van Assche <bvanassche@acm.org>

 > This series compiles, but is otherwise UNTESTED. I'll be working on that
 > over the next few days, with an eye on getting as much of Bart's work
 > into 3.8 as possible.

Hi Dave,

Great to have you back.  Certainly I'd like to get this stuff into 3.8 too.

A couple of comments:
 - I think the srp_transport stuff should go through linux-scsi / James B.
   instead of my tree, esp. since it's shared with the IBM vscsi stuff (I think)
 - I see Bart had a few comments about a few of your patches, I'll wait
   for you guys to hash that out.

Otherwise definitely happy to merge this for 3.8!

Thanks,
  Roland
