From: Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>
Subject: RE: [PATCH] scsi: pm8001: pm80xx_hwi.c:  Cleaning up variable is
 set more than once
Date: Fri, 27 Jun 2014 09:06:49 +0000
Message-ID: <CE2C58F938F4C44EA74FFF880BAA7E5E1CD730A3@BBYEXM02.pmc-sierra.internal>
References: <1403704907-25672-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <53ABD51C.5050806@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:38529 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750756AbaF0JGu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jun 2014 05:06:50 -0400
In-Reply-To: <53ABD51C.5050806@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jack Wang <xjtuwjp@gmail.com>, Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: "lindar_liu@usish.com" <lindar_liu@usish.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>



On Thu, Jun 26, 2014 at 1:50 PM, Maurizio Lombardi <mlombard@redhat.com> wrote:
> On 06/26/2014 10:09 AM, Jack Wang wrote:
>> Thanks Rickard,
>>
>> From my point of view, looks good, but I'd like to get review from Anand
>> (cc-ed).
>
> I would like to add that I noticed that this fields is only set and appears to be never used,
> maybe it could be completely removed.

You are correct. The whole forensic_info structure itself is not used or referred anywhere. I will remove it and send a patch.

Regards,
Suresh Thiagarajan
>
> Regards,
> Maurizio Lombardi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
