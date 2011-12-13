From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 1/1] scsi: retrieve cache mode using ATA_16 if normal
 routine fails
Date: Tue, 13 Dec 2011 15:38:17 -0500
Message-ID: <4EE7B7B9.7060700@garzik.org>
References: <1323688722-25400-1-git-send-email-amit.sahrawat83@gmail.com> <1323694267.20451.5.camel@dabdike> <CAKYAXd-3LYJUWbAqaT4XfbNXJ_F0L1Lxu1evUxLyu=poHLMFug@mail.gmail.com> <1323766382.8163.12.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:35913 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944Ab1LMUiV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Dec 2011 15:38:21 -0500
In-Reply-To: <1323766382.8163.12.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Namjae Jeon <linkinjeon@gmail.com>, Amit Sahrawat <amit.sahrawat83@gmail.com>, Nam-Jae Jeon <namjae.jeon@samsung.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On 12/13/2011 03:53 AM, James Bottomley wrote:
> On Tue, 2011-12-13 at 09:20 +0900, Namjae Jeon wrote:
>>> This whole patch looks like a layering violation.  Why not just update
>>> the SAT layer to translate the MODE SENSE correctly?
>> Would plz you explain more ? I didn't clearly understand your point yet.
>
> The ATA layer does translation for SCSI commands.  Just translate the
> mode sense correctly to use IDENTIFY word 85.  It's a smaller patch and
> no need for any changes in SCSI.

Correct.

> Actually, looking at it, it seems to be correct ... why is it not
> working for you?

Indeed -- the patch attempts to address a problem that the libata-scsi 
translation module already handles.

I would look at why the device is not properly reporting that already. 
If necessary, we would update libata not SCSI.

	Jeff


