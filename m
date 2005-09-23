From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] libata: scsi error handling, lk 2.6.14-rc1
Date: Fri, 23 Sep 2005 05:00:20 -0400
Message-ID: <4333C424.6080209@pobox.com>
References: <432E7A6A.4090209@torque.net> <4333041E.9000405@emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:15797 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1750821AbVIWJAe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Sep 2005 05:00:34 -0400
In-Reply-To: <4333041E.9000405@emc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brett Russ <russb@emc.com>
Cc: dougg@torque.net, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, htejun@gmail.com

Brett Russ wrote:
> In March I got a bunch of patches in this same area into libata-dev; I'm 
> not sure where they sit now (definitely not in 2.6.14-rc).  Jeff would 
> probably know.
> 
> See start of thread:
> http://lkml.org/lkml/2005/3/17/157
> 
> So there would be conflicts if my stuff went forward--a lot of the 
> changes are similar.  I think the best bet would be to find the tree 
> with my patches and for you to look at it and find problems that you 
> solved in this patch that I didn't address.


Embarrassingly, I'm afraid they have probably disappeared into the dust 
of my SATA patch archive.  I completely forget the issues with your 
patches that caused me to not apply them immediately :(

	Jeff


