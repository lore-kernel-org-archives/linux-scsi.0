From: "Subhash Jadavani" <subhashj@codeaurora.org>
Subject: RE: [PATCH V4 09/17] scsi: ufs: manually add well known logical units
Date: Tue, 23 Sep 2014 15:48:09 -0700
Message-ID: <000801cfd780$72ee2870$58ca7950$@codeaurora.org>
References: <1411457499-8074-1-git-send-email-draviv@codeaurora.org>    <1411457499-8074-10-git-send-email-draviv@codeaurora.org>    <20140923083532.GB28647@infradead.org> <fe5615989f4f99067ddb8695a4a046e1.squirrel@www.codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:38005 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756759AbaIWWsL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Sep 2014 18:48:11 -0400
In-Reply-To: <fe5615989f4f99067ddb8695a4a046e1.squirrel@www.codeaurora.org>
Content-Language: en-us
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Dolev Raviv' <draviv@codeaurora.org>
Cc: james.bottomley@hansenpartnership.com, hch@infradead.org, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com

Thanks Chris. Agreed with all your suggestion, next revision will address
your comments.

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Dolev Raviv
Sent: Tuesday, September 23, 2014 4:49 AM
To: Christoph Hellwig
Cc: Dolev Raviv; james.bottomley@hansenpartnership.com; hch@infradead.org;
linux-scsi@vger.kernel.org; linux-scsi-owner@vger.kernel.org;
linux-arm-msm@vger.kernel.org; santoshsy@gmail.com; Subhash Jadavani
Subject: Re: [PATCH V4 09/17] scsi: ufs: manually add well known logical
units


> None of the REPORT LUNS language makes sense as we're not using it.
>
> Can you respon the patch with a better description, and a little 
> comment in the code on why you're adding these wluns.

ok.

>
> Also can I assume none of the later patches relies on their existance?

In UFS power management commands such as SSU, are sent to "device w- lun".
Leaving it out should only affect the ability to suspend the device.
Other patches are not directly affected by it.

> If you do you need to check the error return from scsi_add_device, if 
> not said comment should mention why it's fine to not actually find any 
> of these.
>

Will discus it further with Subhash.

> Also if you do use one of them from kernel space later it might make 
> more sense to use __scsi_add_device and store a pointer to the 
> scsi_device instead of looking it up later.
>

I'll review all you suggestions with Subhash.


--
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

