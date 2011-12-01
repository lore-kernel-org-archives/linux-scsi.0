From: David Dillow <dillowda@ornl.gov>
Subject: Re: [PATCH 00/14] Make ib_srp better suited for H.A. purposes
Date: Thu, 01 Dec 2011 18:26:55 -0500
Message-ID: <1322782015.11664.4.camel@lap75545.ornl.gov>
References: <201112011954.25811.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emroute3.ornl.gov ([160.91.4.110]:35979 "EHLO emroute3.ornl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755596Ab1LBAAU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Dec 2011 19:00:20 -0500
In-reply-to: <201112011954.25811.bvanassche@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Roland Dreier <roland@purestorage.com>, Vu Pham <vuhuong@mellanox.com>

On Thu, 2011-12-01 at 13:54 -0500, Bart Van Assche wrote:
> This patch series makes the ib_srp driver better suited for use in a H.A.
> setup because:
> - Switchover without triggering read or write errors become possible. Such
>   errors are bad because these can make a filesystem switch to read-only
>   mode.
> - A ping mechanism has been added that allows to reduce the switch-over
>   time greatly.
> - Disconnecting from a target without unloading ib_srp becomes possible.
> - Switchover can be triggered explicitly by deleting an initiator device.

In general, I'm glad to see this being done. I won't have the time this
week for a detailed review, but will take a look as soon as I can. I
have a number of ideas I'd like to see implemented (and have partially
done), so it will be interesting to see if we're using similar
approaches.
-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office


