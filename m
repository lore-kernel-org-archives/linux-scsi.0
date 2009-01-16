From: Grant Grundler <grundler@google.com>
Subject: Re: [GIT PATCH] firs round of SCSI bug fixes for 2.6.29-rc1
Date: Fri, 16 Jan 2009 12:09:14 -0800
Message-ID: <da824cf30901161209k7fa2d1cau27a2152c74256c4e@mail.gmail.com>
References: <1232117771.3224.21.camel@localhost.localdomain>
	 <20090116090928.e43c986e.akpm@linux-foundation.org>
	 <da824cf30901161102r67b9c31euc12fc95fb8330a07@mail.gmail.com>
	 <20090116.111059.205876014.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:53309 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755463AbZAPUJT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Jan 2009 15:09:19 -0500
In-Reply-To: <20090116.111059.205876014.davem@davemloft.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: akpm@linux-foundation.org, James.Bottomley@hansenpartnership.com, torvalds@linux-foundation.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, Jan 16, 2009 at 11:10 AM, David Miller <davem@davemloft.net> wrote:
...
>>
>> TBH, I still wouldn't implement it the way LSI maintainers did.
>> I'm happy they are the maintainers and it's their call.
>
> They are doing things which effect the entire system, not just
> their driver.  So this doesn't fall under "maintainer's rights"

Agreed. This case is about a debug option which is normally disabled.
So most people will never see this.

The thread was more about how to make the failure visible in a
sane way WITHOUT the debug flag enabled. Then when the
debug flag is enabled, panic the machine as well.

> If they fail locally, that's fine and perfectly expected, but to take
> the whole machine out is another matter altogether.

Agreed.

thanks,
grant
