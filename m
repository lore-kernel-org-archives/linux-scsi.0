From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [RFC] FC Transport : Async Events via netlink interface
Date: Wed, 19 Apr 2006 08:52:40 -0400
Message-ID: <44463298.7060008@emulex.com>
References: <1145306661.4151.0.camel@localhost.localdomain> <20060418160121.GA2707@us.ibm.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:50369 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1750739AbWDSMwu
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Apr 2006 08:52:50 -0400
In-Reply-To: <20060418160121.GA2707@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

Mike Anderson wrote:
> Is there some reason that you are not using nlmsg_multicast. The caller of
> this function is somewhat simulating the function of multicast.

Only that I haven't looked into using groups yet. It certainly makes sense.

> In the send_fail case it looks like you leak skbs. Do you need to add a
> call to nlmsg_free or kfree_skb?

Yep.

I'll include these comments in the revised post. I'll wait a little longer
for any further comments.

-- james

