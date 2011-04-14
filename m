From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: 2.6.39-rc3-git3 crashs after booting
Date: Thu, 14 Apr 2011 20:49:35 +0200
Message-ID: <BANLkTi=+5FsyUGFWk7P2Wb3RkxRgC4=EoQ@mail.gmail.com>
References: <web-504663160@zbackend1.aha.ru> <20110414104039.c0e655bd.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:57850 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759253Ab1DNSt4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Apr 2011 14:49:56 -0400
Received: by vws1 with SMTP id 1so1536674vws.19
        for <linux-scsi@vger.kernel.org>; Thu, 14 Apr 2011 11:49:55 -0700 (PDT)
In-Reply-To: <20110414104039.c0e655bd.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: werner <w.landgraf@ru.ru>, gregkh@suse.de, mingo@elte.hu, tj@kernel.org, randy.dunlap@oracle.com, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@hansenpartnership.com>, Jens Axboe <axboe@kernel.dk>

On Thu, Apr 14, 2011 at 7:40 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Thu, 14 Apr 2011 04:17:51 -0400 "werner" <w.landgraf@ru.ru> wrote:
>
>> The problem with the crashs after booting which started
>> with 2.6.39-rc1 continues with 2.6.39-rc3-git3

Although I'm not sure whether it is related, another bug report about
a lockup introduced between 2.6.38 and 2.6.39-rc1 can be found here:
https://bugzilla.kernel.org/show_bug.cgi?id=32982.

Bart.
