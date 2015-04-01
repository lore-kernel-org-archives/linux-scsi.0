From: Suman Tripathi <stripathi@apm.com>
Subject: Re: [PATCH v1] ata: ahci_xgene: Add AHCI Support for second
 generation of APM X-Gene SoC
Date: Wed, 1 Apr 2015 22:07:54 +0530
Message-ID: <CAOHikRCD1izpMkfOJxaXhi8=JuaNt5ay=cW90RJzEwjJPv5uOw@mail.gmail.com>
References: <1427899682-10912-1-git-send-email-stripathi@apm.com>
	<1427899682-10912-2-git-send-email-stripathi@apm.com>
	<20150401161336.GS9974@htj.duckdns.org>
	<20150401163116.GT9974@htj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod5og112.obsmtp.com ([64.18.0.24]:34588 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752619AbbDAQh5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Apr 2015 12:37:57 -0400
Received: by wgoe14 with SMTP id e14so59345142wgo.0
        for <linux-scsi@vger.kernel.org>; Wed, 01 Apr 2015 09:37:54 -0700 (PDT)
In-Reply-To: <20150401163116.GT9974@htj.duckdns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>, Linux SCSI List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, Mark Langsdorf <mlangsdo@redhat.com>, Jon Masters <jcm@redhat.com>, patches <patches@apm.com>

On Wed, Apr 01, 2015 at 12:13:36PM -0400, Tejun Heo wrote:
> > Signed-off-by : Suman Tripathi <stripathi@apm.com>
>
> Applied to libata/for-4.1 w/ minor edit.

Reverted due to build failure from missing asm/cputype.h.  Suman,
you're the develper and familiar with how the prerequisite patches are
flowing where.  When sending patches to maintainers, please let them
know how to deal with your patches.  Having cross-tree dependencies
are fine, there are multiple ways to deal with that but please don't
just drop patches which will fail build and see what happens.  Please
help us do our job.

Apologize for that . Really sorry  . I will check it.

Thanks.

On Wed, Apr 1, 2015 at 10:01 PM, Tejun Heo <tj@kernel.org> wrote:
> On Wed, Apr 01, 2015 at 12:13:36PM -0400, Tejun Heo wrote:
>> > Signed-off-by : Suman Tripathi <stripathi@apm.com>
>>
>> Applied to libata/for-4.1 w/ minor edit.
>
> Reverted due to build failure from missing asm/cputype.h.  Suman,
> you're the develper and familiar with how the prerequisite patches are
> flowing where.  When sending patches to maintainers, please let them
> know how to deal with your patches.  Having cross-tree dependencies
> are fine, there are multiple ways to deal with that but please don't
> just drop patches which will fail build and see what happens.  Please
> help us do our job.
>
> Thanks.
>
> --
> tejun



-- 
Thanks,
with regards,
Suman Tripathi
