From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [v4.13-rc BUG] system lockup when running big buffered write(4M)
 to IB SRP via mpath
Date: Thu, 24 Aug 2017 00:03:11 +0800
Message-ID: <CACVXFVNP91Kf4bi=Ndc4aXR5pJg3u1pQ6Gzev7_nmS02h=gd6g@mail.gmail.com>
References: <20170808141715.GB22763@ming.t460p> <1502237504.4017.1.camel@redhat.com>
 <1502245693.6511.3.camel@redhat.com> <c072e942-0265-f0ad-561d-0e50d50e3cb1@redhat.com>
 <1502298599.2356.7.camel@wdc.com> <20170823113526.GA8130@ming.t460p> <1503501161.2484.3.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:37132 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932118AbdHWQDP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Aug 2017 12:03:15 -0400
In-Reply-To: <1503501161.2484.3.camel@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "ming.lei@redhat.com" <ming.lei@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "loberman@redhat.com" <loberman@redhat.com>

On Wed, Aug 23, 2017 at 11:12 PM, Bart Van Assche
<Bart.VanAssche@wdc.com> wrote:
> On Wed, 2017-08-23 at 19:35 +0800, Ming Lei wrote:
>> soft lockup still can be observed easily with patch d4acf3650c7c(
>> block: Make blk_mq_delay_kick_requeue_list() rerun the queue at a quiet time),
>> but no hard lockup.
>
> Hello Ming,
>
> I never claimed that commit d4acf3650c7c was a full solution to avoid these
> soft lockups. I assume these results mean that patch series "[PATCH 0/7]
> Device mapper and dm-mpath fixes" was not applied to the kernel used in your
> tests? A colleague of you has reported that that patch series is sufficient

OK, thanks for your clarification.

I run v4.13-rc6 with block for-next, so these patches are not applied in my
kernel.

-- 
Ming Lei
