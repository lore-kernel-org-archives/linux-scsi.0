From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH RESEND] scsi_transport_sas: move bsg destructor into sas_rphy_remove
Date: Fri, 2 May 2014 12:26:40 -0700
Message-ID: <CAPcyv4jcD9RG9B4vjcE8227Yx09j3v+OPNxhE58ZbFo2202mnA@mail.gmail.com>
References: <1396471241-1315-1-git-send-email-joe.lawrence@stratus.com>
	<20140402164852.1f20ccb6@jlaw-desktop.mno.stratus.com>
	<20140502150132.6ddd8a0c@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ve0-f177.google.com ([209.85.128.177]:33572 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136AbaEBT0l (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 May 2014 15:26:41 -0400
Received: by mail-ve0-f177.google.com with SMTP id db11so1174375veb.8
        for <linux-scsi@vger.kernel.org>; Fri, 02 May 2014 12:26:40 -0700 (PDT)
In-Reply-To: <20140502150132.6ddd8a0c@jlaw-desktop.mno.stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Lawrence <joe.lawrence@stratus.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, "Reddy, Sreekanth" <Sreekanth.Reddy@lsi.com>

On Fri, May 2, 2014 at 12:01 PM, Joe Lawrence <joe.lawrence@stratus.com> wrote:
> On Wed, 2 Apr 2014 16:48:52 -0400
> Joe Lawrence <joe.lawrence@stratus.com> wrote:
>
>> On Wed, 2 Apr 2014 16:40:41 -0400
>> Joe Lawrence <joe.lawrence@stratus.com> wrote:
>>
>> > Since bsg creation is a side effect of sas_rphy_add, move its
>> > complementary removal call into sas_rphy_remove.
>>
>> Hello James,
>>
>> This a resend of a patch posted to quiet an end-device sysfs warning in
>> its device deletion path when removing the mpt2sas driver:
>>
>>   (initial report)
>>   sysfs group not found for kobject on mpt2sas unload
>>   http://marc.info/?t=138497460000004
>>
>>   (patch + ACK + comments)
>>   http://marc.info/?t=138609455500001
>>
>>   (gentoo, LSI repro)
>>   mpt2sas driver barfs when force removing a drive on 3.13.1
>>   http://marc.info/?t=139122351300001
>>
>> Dan Williams had a few other suggestions for cleanup in this area, but
>> those could be handled in a subsequent patch.  This one missed 3.14
>> inclusion and the warning still occurs in Linus's tree as of today
>> (post scsi/block merge) hence the repost.
>
> Ping? Just reproduced on 3.15-rc3.  Also found this:
>
>   (~500 repro count on Fedora Problem Tracker)
>   http://retrace.fedoraproject.org/faf/problems/1623421/
>

Hmm, looks like the re-send is missing my ack.  Feel free to add:

Acked-by: Dan Williams <dan.j.williams@intel.com>

James, do you want me to shepherd sas infrastructure bits
(libsas/scsi_transport_sas) along in my own tree, or...?
