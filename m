From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 00/10] scsi: avoid linebreaks in syslog output
Date: Fri, 20 Dec 2013 14:35:38 +0100
Message-ID: <52B447AA.70508@redhat.com>
References: <1350030830-25614-1-git-send-email-hare@suse.de> <52B44548.8020308@redhat.com> <52B446BE.20901@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12424 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932292Ab3LTNfn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Dec 2013 08:35:43 -0500
In-Reply-To: <52B446BE.20901@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org

On 12/20/2013 02:31 PM, Hannes Reinecke wrote:
> On 12/20/2013 02:25 PM, Tomas Henzl wrote:
>> Hi Hannes, James,
>>
>> I'm wondering what happened to this patch-set? I think it could
>> make parsing of the output for userspace programs much easier.
>> Are there some problems still to solve or is this just forgotten?
>>
> Oh, no. Quite the contrary.
> As James has now merged my previous patchsets I'm in the process of
> updating this one, too.
>
> It'll be part of a larger patchset having a per-device
> scsi_logging_level; something I was wanting to have for a _LONG_
> time now.
>
> Currently I'm fiddling with sense code printing, so I won't be able
> to send anything this year. But early next year I should have
> something presentable.

Great news! thanks.

>
> Cheers,
>
> Hannes

