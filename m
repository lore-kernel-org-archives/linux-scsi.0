From: Israel Rukshin <israelr@mellanox.com>
Subject: Re: [PATCH v2] scsi_sysfs: fix hang when removing scsi device
Date: Thu, 16 Mar 2017 17:59:42 +0200
Message-ID: <3877f490-e3e7-bb5e-9b91-402820f2d9bc@mellanox.com>
References: <1489077442-20610-1-git-send-email-israelr@mellanox.com>
 <1489088191.2597.9.camel@sandisk.com>
 <22efc8bd-ae71-14c7-247b-7399bfd28c6d@mellanox.com>
 <1489430936.2658.9.camel@sandisk.com>
 <1489432986.23810.12.camel@HansenPartnership.com>
 <1489437175.2658.17.camel@sandisk.com>
 <1489442133.23810.24.camel@HansenPartnership.com>
 <1489458944.2987.1.camel@sandisk.com>
 <c9afc172-105a-cabf-b286-150c6dc11a68@mellanox.com>
 <96b2016e-c9a0-07e8-0af3-be04802162a9@mellanox.com>
 <1489620422.2660.16.camel@sandisk.com>
 <8e4daba5-b172-2ee1-e889-93892079e839@mellanox.com>
 <1489678950.2574.7.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-he1eur01on0088.outbound.protection.outlook.com ([104.47.0.88]:19964
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752131AbdCPQAY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Mar 2017 12:00:24 -0400
In-Reply-To: <1489678950.2574.7.camel@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>
Cc: "maxg@mellanox.com" <maxg@mellanox.com>

On 3/16/2017 5:42 PM, Bart Van Assche wrote:
> On Thu, 2017-03-16 at 11:02 +0200, Israel Rukshin wrote:
>> I tested your patches and the hang disappeared when fast_io_fail_tmo
>> expired. The warning from patch 1 still exist, so we need an additional
>> fix for that.
> Hello Israel,
>
> Thanks for the testing! I will leave out patch 1 for now since it is not
> needed to fix the hang.
>
> I assume that your e-mail counts as a Tested-by?
>
> PS: please do not top-post when replying. This is considered annoying in the
> Linux kernel community.
>
> Bart.

Hello Bart,

Yes, you can add me as Tested-by.

Israel.
