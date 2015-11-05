From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [Y2038] [RESEND PATCH v3] scsi: stex: Remove use of struct timeval
Date: Thu, 05 Nov 2015 17:23 +0100
Message-ID: <5227791.rORtZBSFWh@wuerfel>
References: <20151030083040.GA31741@tina-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151030083040.GA31741@tina-laptop>
Sender: linux-kernel-owner@vger.kernel.org
To: y2038@lists.linaro.org
Cc: Tina Ruchandani <ruchandani.tina@gmail.com>, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@odin.com>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Friday 30 October 2015 01:30:40 Tina Ruchandani wrote:
> Function stex_gettime uses 'struct timeval' whose tv_sec value
> will overflow on 32-bit systems in year 2038 and beyond. This patch
> replaces the use of struct timeval and do_gettimeofday with
> ktime_get_real_seconds, which returns a 64-bit seconds value.
> 
> Suggested-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Tina Ruchandani <ruchandani.tina@gmail.com>
> 

For reference

Reviewed-by: Arnd Bergmann <arnd@arndb.de>

I'm putting this into my y2038 tree so I don't forget it, but I'd hope
that James can apply it into scsi and I'll drop it again.

	Arnd
