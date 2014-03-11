From: adam radford <aradford@gmail.com>
Subject: Re: [PATCH 0/5] megaraid_sas: Updates for scsi-misc
Date: Tue, 11 Mar 2014 16:01:16 -0700
Message-ID: <CAHtARFH8KF1wAkB3yBy23E4r6Wq2AgvO+BiUr3K+mLTqqZ4mbQ@mail.gmail.com>
References: <CAHtARFHcaLNbNFrGYRU9SQpJzhhESM0=TVZ5X2Rz_=1fLvk_rg@mail.gmail.com>
	<531D9E74.9000802@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yh0-f47.google.com ([209.85.213.47]:47137 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754639AbaCKXBR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Mar 2014 19:01:17 -0400
Received: by mail-yh0-f47.google.com with SMTP id 29so3768459yhl.34
        for <linux-scsi@vger.kernel.org>; Tue, 11 Mar 2014 16:01:16 -0700 (PDT)
In-Reply-To: <531D9E74.9000802@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Kashyap Desai <Kashyap.Desai@lsi.com>, "Saxena, Sumit" <Sumit.Saxena@lsi.com>

>> Patch series is lacking coding style. Please re-check with
'./scripts/checkpatch.pl

I did run checkpatch against the whole patch series before submission.
Please see my comments about me leaving some lines > 80 columns in
place to preserve code readability at the top of the largest patch,
here:

http://marc.info/?l=3Dlinux-scsi&m=3D139444512512929&w=3D2

-Adam

On Mon, Mar 10, 2014 at 4:13 AM, Hannes Reinecke <hare@suse.de> wrote:
> On 03/10/2014 10:51 AM, adam radford wrote:
>> James/linux-scsi,
>>
>> The following patch series for megaraid_sas brings the driver up to
>> v06.803.01.00-rc1:
>>
>> 1. Load correct raid context timeout value for multipathing and clus=
tering.
>> 2. Fix megasas_ioc_init_fusion to use local stack variable.
>> 3. Return leaked MPT frames to MPT command pool.
>> 4. Add Dell PowerEdge VRTX SR-IOV VF device support.
>> 5. Version and Changelog update.
>>
>> This patch series apples on top of Sumit Saxena's latest patch serie=
s, which
>> starts here:
>>
>> http://marc.info/?l=3Dlinux-scsi&m=3D139220849616649&w=3D2
>>
>> and includes a small repost here:
>>
>> http://marc.info/?l=3Dlinux-scsi&m=3D139374736120535&w=3D2
>>
> Patch series is lacking coding style. Please re-check with
> './scripts/checkpatch.pl
>
> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke                   zSeries & Storage
> hare@suse.de                          +49 911 74053 688
> SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
