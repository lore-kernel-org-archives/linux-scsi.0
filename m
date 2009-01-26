From: "Ed Lin - PTU" <ed.lin@promise.com>
Subject: RE: [PATCH 1/5] stex: Fix for potential invalid response
Date: Mon, 26 Jan 2009 13:53:35 -0800
Message-ID: <85ABFDC4641C4847BA6088F2982EFD8F01DC83DA@nonamew.ptu.promise.com>
References: <1232997415.3248.50.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gateway.promise.com ([67.111.72.2]:29790 "EHLO
	nonamew.ptu.promise.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752794AbZAZWIs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Jan 2009 17:08:48 -0500
Content-class: urn:content-classes:message
In-Reply-To: <1232997415.3248.50.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Promise_Linux <Promise_Linux@promise.com>



>-----Original Message-----
>From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com] 
>Sent: 2009年1月26日 11:17
>To: Ed Lin - PTU
>Cc: linux-scsi@vger.kernel.org; Promise_Linux
>Subject: Re: [PATCH 1/5] stex: Fix for potential invalid response
>
>
>On Mon, 2009-01-26 at 02:40 -0800, Ed Lin - PTU wrote:
>> The interrupt routine is good for normal cases. However, if 
>the firmware
>> is abnormal and returns an invalid response, the driver may reuse a
>> ccb structure which has already been handled. This may cause problem.
>> Fix this by setting the req member to NULL. Next time we know the
>> response is invalid and handle accordingly if req is NULL.
>> 
>> Signed-off-by: Ed Lin <ed.lin@promise.com>
>> ---
>> 
>> diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
>> index a3a18ad..6129db4 100644
>> --- a/drivers/scsi/stex.c
>> +++ b/drivers/scsi/stex.c
>> @@ -746,6 +746,7 @@ static void stex_mu_intr(struct st_hba *hba, u32
>> doorbell)
>
>The patches generally look fine.  Unfortunately your email tool has
>broken the line ends of most of them (like the above) which makes it
>almost impossible to apply them.  Could you resend with this fixed up?
>

Sure, I will do it shortly. Please let me know if it's still broken.
Sorry for the inconvenience.
