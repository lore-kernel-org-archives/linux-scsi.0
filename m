From: adam radford <aradford@gmail.com>
Subject: Re: bad performance on 3 of 20 boxes with 3ware card
Date: Fri, 31 Jul 2009 16:44:35 -0700
Message-ID: <b1bc6a000907311644j1ece02faifaede6c9b8eb2d05@mail.gmail.com>
References: <alpine.DEB.1.10.0907311459220.28013@asgard.lang.hm>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gx0-f213.google.com ([209.85.217.213]:63365 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbZGaXof (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 31 Jul 2009 19:44:35 -0400
Received: by gxk9 with SMTP id 9so4236693gxk.13
        for <linux-scsi@vger.kernel.org>; Fri, 31 Jul 2009 16:44:35 -0700 (PDT)
In-Reply-To: <alpine.DEB.1.10.0907311459220.28013@asgard.lang.hm>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: david@lang.hm
Cc: linux-scsi@vger.kernel.org

On Fri, Jul 31, 2009 at 3:02 PM, <david@lang.hm> wrote:
> I hae 20 identical boxes (2x 4-core cpus, 64G ram, 16x1TB SATA drives on
> 07:00.0 RAID bus controller: 3ware Inc 9650SE SATA-II RAID (rev 01) raid 6)
> running linux 2.6.30
>
> on 3 of the 20 I seem to have a max write speed of ~5MB/sec (as opposed to
>>
>> 100 MB/sec)
>
> any pointers on how I can identify what is different about these three
> boxes?

Do you have cache OFF on the 3 slow boxes ?

-Adam
