From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 19/24] fnic: Use time64_t to represent trace timestamps
Date: Wed, 22 Jun 2016 16:09:24 +0200
Message-ID: <8562537.c35I4lEtz8@wuerfel>
References: <1466382443-11063-1-git-send-email-deepa.kernel@gmail.com> <1466382443-11063-20-git-send-email-deepa.kernel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1466382443-11063-20-git-send-email-deepa.kernel@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Deepa Dinamani <deepa.kernel@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, tglx@linutronix.de, torvalds@linux-foundation.org, tytso@mit.edu, viro@zeniv.linux.org.uk, y2038@lists.linaro.org, Hiral Patel <hiralpat@cisco.com>, Suma Ramars <sramars@cisco.com>, Brian Uchino <buchino@cisco.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, John Stultz <john.stultz@linaro.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sunday, June 19, 2016 5:27:18 PM CEST Deepa Dinamani wrote:
> trace timestamps use struct timespec and CURRENT_TIME which
> are not y2038 safe.
> These timestamps are only part of the trace log on the machine
> and are not shared with the fnic.
> Replace then with y2038 safe struct timespec64 and
> ktime_get_real_ts64(), respectively.
> 
> Note that change to add time64_to_tm() is already part of John's
> kernel tree: https://lkml.org/lkml/2016/6/17/875 .
> 

While the patch looks good, I think it can't be part of this
series now, since it has to go on top of that first patch,
rather than merged in parallel.

When you send a pull request, please leave it out and submit
this one separately after 4.8-rc1.

	Arnd

