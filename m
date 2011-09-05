From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 1/2] megaraid_sas: Remove the shutdown_controller call
Date: Mon, 05 Sep 2011 16:17:39 +0200
Message-ID: <4E64DA03.4090409@redhat.com>
References: <1314200130-28890-1-git-send-email-thenzl@redhat.com> <1314200130-28890-2-git-send-email-thenzl@redhat.com> <CAHtARFF1iwy2NR1G01hFqBo2hoYxAbG+0DQ0UJNSS3JO_s5qbg@mail.gmail.com> <4E560526.5060601@redhat.com> <CAHtARFE+pbaVgbEyxrdF6qyFgu4Km4QOi28wUzfVtc5_SRayAg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40461 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752386Ab1IEORp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 Sep 2011 10:17:45 -0400
In-Reply-To: <CAHtARFE+pbaVgbEyxrdF6qyFgu4Km4QOi28wUzfVtc5_SRayAg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: adam radford <aradford@gmail.com>
Cc: linux-scsi@vger.kernel.org, steve.masters@lsi.com, michael.benz@lsi.com, bo.yang@lsi.com

On 08/26/2011 02:00 AM, adam radford wrote:
> On Thu, Aug 25, 2011 at 1:17 AM, Tomas Henzl <thenzl@redhat.com> wrote:
>> In the meantime - I've sent two patches, what do you think about the second one?
>> It solves(hides) the problem too.
> Here are my thoughts on your patches:
>
> 1. You are not checking if (reset_devices) around these code changes
> to determine if you are in the kdump kernel, which is the only place
> you are seeing this issue.
> 2. You should only change behavior for the device ID's you are having
> issue with.
> 3. We need to update your PERC5 controller to the latest firmware,
> then try to reproduce.
This problem is fixed in firmware thanks to Adam (LSI), so neither patch is needed.

Tomas


>
> -Adam
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

