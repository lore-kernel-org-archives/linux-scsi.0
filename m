From: gcoady@gmail.com
Subject: Re: 2.6: how do I this in sysfs?
Date: Tue, 30 Aug 2005 09:17:41 +1000
Message-ID: <mm57h19bgaf3bj3rrvi6ps24k0inaei55q@4ax.com>
References: <D4CFB69C345C394284E4B78B876C1CF10ABB0269@cceexc23.americas.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay01.mail-hub.dodo.com.au ([203.220.32.149]:58761 "EHLO
	relay01.mail-hub.dodo.com.au") by vger.kernel.org with ESMTP
	id S1751411AbVH2XSH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Aug 2005 19:18:07 -0400
In-Reply-To: <D4CFB69C345C394284E4B78B876C1CF10ABB0269@cceexc23.americas.cpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, greg@kroah.com, mochel@osdl.org, "Moore, Eric Dean" <Eric.Moore@lsil.com>, "Patterson, Andrew D (Linux R&D)" <andrew.patterson@hp.com>, Luben Tuikov <luben_tuikov@adaptec.com>

On Mon, 29 Aug 2005 12:24:18 -0500, "Miller, Mike (OS Dev)" <Mike.Miller@hp.com> wrote:

>
>> This is after my minimal sas transport class, please also 
>> read the thread about it on linux-scsi
>> 
>In the referenced code for using sysfs, there only appear to be methods
>for reading attributes.  How about if we want to cause a command to
>get written out to the hardware?   Do we do something like this?
>
>        /* get a semaphore keep everyone else out while we're working,
>           and hope like hell that all the other processes are playing
>           nice and using the semaphore too, or else we're hosed. */
>
[...]
>        release_some_kind_of_semaphore();
>
>I'm not suggesting that the above is a good idea.  I don't have a good
>idea about how to do this.

Take a look at hwmon drivers, it is nowhere near so bad as you think.

Grant.

