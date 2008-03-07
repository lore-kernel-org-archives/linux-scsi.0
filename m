From: "Ke Wei" <kewei.mv@gmail.com>
Subject: Re: [PATCH] mvsas: fix default can_queue
Date: Fri, 7 Mar 2008 23:31:44 +0800
Message-ID: <6b2481670803070731x6c2717feyfc8ba9cc35f7181d@mail.gmail.com>
References: <1204308113.4003.45.camel@localhost.localdomain>
	 <1204556371.3043.7.camel@localhost.localdomain>
	 <1204682849.3091.95.camel@localhost.localdomain>
	 <1204750960.3047.67.camel@localhost.localdomain>
	 <6b2481670803060646m54675625g729a82c4da33ce05@mail.gmail.com>
	 <1204818725.3062.14.camel@localhost.localdomain>
	 <1204825474.3062.25.camel@localhost.localdomain>
	 <47D03117.2020903@garzik.org>
	 <6b2481670803070250p7e6eab01i6660c53188914058@mail.gmail.com>
	 <1204902185.2889.6.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.191]:45776 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756667AbYCGPbr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Mar 2008 10:31:47 -0500
Received: by rn-out-0910.google.com with SMTP id v46so882515rnb.15
        for <linux-scsi@vger.kernel.org>; Fri, 07 Mar 2008 07:31:46 -0800 (PST)
In-Reply-To: <1204902185.2889.6.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Fri, Mar 7, 2008 at 11:03 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
>
> Are you still seeing timeouts in the lldd_max_execute_num == 1 case?
> And if so, is that still with can_queue == 1?
>
Yes , I set lldd_max_execute_num = 1 & can_queue = 1. By far, no timeout event.

> James
>
>
>


-- 
Best Regards,
Ke Wei
