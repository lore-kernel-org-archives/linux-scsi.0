From: Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH] scsi: Fix qemu boot hang problem
Date: Mon, 11 Aug 2014 09:21:49 -0700
Message-ID: <53E8ED9D.7030809@roeck-us.net>
References: <1407675265-29192-1-git-send-email-linux@roeck-us.net>	<53E8CF41.2050300@kernel.dk> <CAHdzE-_uFg5m+mr+itugeZwOTqMtLXB=AR01ZsH=yaobez4aew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHdzE-_uFg5m+mr+itugeZwOTqMtLXB=AR01ZsH=yaobez4aew@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Venkatesh Srinivas <venkateshs@google.com>, Jens Axboe <axboe@kernel.dk>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Webb Scales <webbnh@hp.com>
List-Id: linux-scsi@vger.kernel.org

On 08/11/2014 08:33 AM, Venkatesh Srinivas wrote:
> Should we wrap the sdev->device_busy read and test in a new
> scsi_device_busy(), so as to preserve the old polarity?
>
I don't see a difference in polarity, or at least replacing '== 0' with '!'
is not a reverse in polarity for me. Anyway, I don't really care if
or how this is wrapped, as long as it is getting fixed.

Thanks,
Guenter
