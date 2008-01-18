From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] SCSI: fix isa/pcmcia compile problem
Date: Sat, 19 Jan 2008 08:46:58 +0900
Message-ID: <47913A72.5040607@gmail.com>
References: <20080117023514.9df393cf.akpm@linux-foundation.org>	 <478F7F2B.9000801@linux.vnet.ibm.com>	 <20080117111104.3baa878e.akpm@linux-foundation.org>	 <47904927.1040000@linux.vnet.ibm.com>  <47905348.1000709@gmail.com>	 <1200668315.3111.3.camel@localhost.localdomain>	 <479135EE.2090009@gmail.com> <1200699173.3111.77.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.183]:34996 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138AbYARXrG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Jan 2008 18:47:06 -0500
Received: by wa-out-1112.google.com with SMTP id v27so2018207wah.23
        for <linux-scsi@vger.kernel.org>; Fri, 18 Jan 2008 15:47:05 -0800 (PST)
In-Reply-To: <1200699173.3111.77.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, fischer@norbit.de, Andy Whitcroft <apw@shadowen.org>, Balbir Singh <balbir@linux.vnet.ibm.com>, Samuel Ortiz <samuel@sortiz.org>

James Bottomley wrote:
>> I personally think it's a bit odd to disallow building into kernel
>> because of the peculiarity of the implementation (including c files and
>> compiling them slightly differently) and also no one reporting doesn't
>> necessarily mean no one has attempted it and failed.
> 
> Heh ... I'll make you a deal.  Find just one user of one of these
> drivers who can make use of them built in, and I'll apply the patch.  

I don't think I can.  I didn't even know they were isa ones before
actually looking at the code.

> I'm just a bit reluctant to touch these drivers, since they're all
> incredibly ancient.  We don't have good luck with simple transformation
> patches on the older drivers ... and it seems to take months before
> anyone notices there's a problem.

Alright then, please go ahead and disallow built-in.

Thanks.

-- 
tejun
