From: weiping zhang <zwp10758@gmail.com>
Subject: Re: [RFC PATCH] scsi: sd: add wce_rcd sysfs interface
Date: Thu, 18 Jan 2018 12:02:00 +0800
Message-ID: <CAA70yB77hLWphXKUc2QtuJ2OMEFQtSZa6_b7ccaTJR6uyrhKDQ@mail.gmail.com>
References: <20180117124945.GA7787@bogon.didichuxing.com> <yq1k1wfriav.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:37555 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753772AbeARECB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Jan 2018 23:02:01 -0500
Received: by mail-wm0-f68.google.com with SMTP id v71so19960230wmv.2
        for <linux-scsi@vger.kernel.org>; Wed, 17 Jan 2018 20:02:00 -0800 (PST)
In-Reply-To: <yq1k1wfriav.fsf@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: weiping zhang <zhangweiping@didichuxing.com>, jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org

2018-01-18 10:51 GMT+08:00 Martin K. Petersen <martin.petersen@oracle.com>:
>
> Hi Weiping,
>
>> add user friendly interface wce_rcd to enable/disable
>> write&read cache. The code base on cache_type, but need short input.
>
> While I agree that the cache_type interface is somewhat arcane, I don't
> think that adding a duplicate interface with slightly different
> semantics is a good idea.
>
Hi Martin,

How about add new match array for cache_type interface like following:
static const char * const sd_wce_rcd[] = {"00", "01", "10", "11"};
if cache_type match one of "sd_cache_type", "sd_wce_rcd", it will
works as before.

And, for show function, add more info, to show cache status, like following:
write back
write cache: on
read cache: on


> --
> Martin K. Petersen      Oracle Linux Engineering
