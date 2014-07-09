From: loody <miloody@gmail.com>
Subject: Re: dummy scsi read or scsi command periodically for external USB
 Hard Disk
Date: Wed, 9 Jul 2014 11:17:51 +0800
Message-ID: <CANudz+vdVQAJgz1YYN=yFQn+749XFbvi3Hqnd+n5zkM5FxuJtQ@mail.gmail.com>
References: <CANudz+vNcLEJSX9L4FsPMMgJfp7rZxcryPcRmPs0-k5nB61dDg@mail.gmail.com>
	<Pine.LNX.4.44L0.1407081524460.1283-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:62721 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345AbaGIDRx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jul 2014 23:17:53 -0400
In-Reply-To: <Pine.LNX.4.44L0.1407081524460.1283-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Bryn M. Reeves" <bmr@redhat.com>, "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>

hi Alan:

2014-07-09 3:26 GMT+08:00 Alan Stern <stern@rowland.harvard.edu>:
> On Wed, 9 Jul 2014, loody wrote:
>
>> there is one thing pop in my mind.
>> if events_poll_msecs is used for media_change, shouldn't we wrap is READ10?
>
> No.  Why should media change polling use READ(10)?  TEST UNIT READY
> does a good job of detecting media changes.
>
>> the difference seems
>> 1. change SCSI command
>> 2. allocate 512 Byte for 1 sector dummy read
>> the periodically trigging flow should be the same.
>>
>> if you think above is possible, where we should start from?
>
> Why do you want to make this change?
on that usb hard disk, no matter media_change or TEST_UNIT_READY, keep
polling the device every 3mins.
the disconnection still happen.

So I am wondering, I can use the existence wheel, such as echo 40000 >
/sys/block/sda/events_poll_
msecs.
but what it really do is read sector, not media_change or test_unit_ready.

thanks for your kind help
