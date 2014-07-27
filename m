From: "Laszlo T." <tlacix@gmail.com>
Subject: Re: [PATCH] usb-storage/SCSI: Add broken_fua blacklist flag
Date: Sun, 27 Jul 2014 23:04:42 +0200
Message-ID: <CAOaU5MaKVMqL3NUcZX9=4jBVFGvnGpdePRg_73ff-2doSwjTzA@mail.gmail.com>
References: <CAOaU5MZxg4eFsFO51fkCqx_HLAi=TcZKqdJ8RAOL4F+iU50RkA@mail.gmail.com>
	<Pine.LNX.4.44L0.1407262149370.20700-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:59270 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524AbaG0VEm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 27 Jul 2014 17:04:42 -0400
Received: by mail-ig0-f173.google.com with SMTP id h18so2857069igc.12
        for <linux-scsi@vger.kernel.org>; Sun, 27 Jul 2014 14:04:42 -0700 (PDT)
In-Reply-To: <Pine.LNX.4.44L0.1407262149370.20700-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-scsi@vger.kernel.org

2014-07-27 3:50 GMT+02:00 Alan Stern <stern@rowland.harvard.edu>:
> On Sat, 26 Jul 2014, Laszlo T. wrote:
>
>> Hello,
>>
>> First of all I've just subscribed the linux-scsi thread. I hope you
>> get my email the right way.
>>
>> I have also problems with Jmicron JMS567 mobile rack.
>>
>> I tried on different kernels:
>> 3.15.5
>> 3.16.rc6
>> the 'Invalid field in cdb' errors disappeared but still not ok.
>
> Since your device uses the uas driver, you might get more help on the
> linux-usb mailing list.  (You don't have to subscribe to the list in
> order to post to it.)
>
> Alan Stern
>

Thank you, I will email them.

In the meantime, is there any alternate solution to use this mobile rack?

I tried to backlist the uas driver on 3.16.rc6 but in that case the
/dev/sd* file wasn't created.
and also tried to disable fua (libata fua=0) on 3.14 kernel, but I got
the 'Invalid field in cdb' errors.

Br,
Laszlo
