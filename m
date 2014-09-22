From: ronnie sahlberg <ronniesahlberg@gmail.com>
Subject: Re: SCSI test tool for linux (and others)
Date: Mon, 22 Sep 2014 09:44:20 -0700
Message-ID: <CAN05THS-Gw9WvUB44MxiZHwvxcgYFMM6DPVzKACjtaeYtExoDw@mail.gmail.com>
References: <CAN05THQ9Z0sMgJ5gFZhLBP9JH+pmFYNVBr0KrgCCYF9=haFKbg@mail.gmail.com>
	<54204F84.8090509@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:35428 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318AbaIVQoW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Sep 2014 12:44:22 -0400
Received: by mail-la0-f48.google.com with SMTP id ty20so7001557lab.21
        for <linux-scsi@vger.kernel.org>; Mon, 22 Sep 2014 09:44:20 -0700 (PDT)
In-Reply-To: <54204F84.8090509@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org

On Mon, Sep 22, 2014 at 9:34 AM, Bart Van Assche <bvanassche@acm.org> wrote:
> On 21/09/2014 9:58, ronnie sahlberg wrote:
>>
>> For now I populated it with a bunch of tests I copied fro the SCSI family.
>> Some, not all, tests.
>> Missing are a whole bunch of tests that require that you have multiple
>> I_T nexuses,
>> such as all the persistent reservation tests, which would be difficult
>> to implement on /dev/sg* devices. (all users of a specific /dev/sg*
>> device ends up on the same nexus, right, the nexus for kernel<->device
>> ?)
>
>
> Hello Ronnie,
>
> Have you considered to allow multiple /dev/sg* arguments to be specified and
> to let the tests that require multiple I_T nexuses use one /dev/sg* argument
> per nexus ? Do you think such a feature would be helpful for testing FC and
> RDMA over SCSI initiator drivers in a setup with multiple storage paths
> between initiator and target systems ?
>

Good idea. I have added that as an Issue to the githup repo so I do not forget.
