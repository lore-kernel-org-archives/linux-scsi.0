From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] [RESEND] SCSI: ips: remove pointless #warning
Date: Tue, 19 May 2015 06:52:52 -0700
Message-ID: <1432043572.3007.14.camel@HansenPartnership.com>
References: <3121960.dnOqT9LCth@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3121960.dnOqT9LCth@wuerfel>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-scsi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2015-05-19 at 15:33 +0200, Arnd Bergmann wrote:
> The ips driver contains
> 
>  #warning "This driver has only been tested on the x86/ia64/x86_64 platforms"
> 
> which gets printed by the compiler every time this driver gets
> build for something other than those three architectures. The same
> is true for most other drivers, but none of them prints a warning like
> this.
> 
> Let's remove the warning now to reduce the amount of clutter.
> 
> FWIW, I've reviewed the driver and found a few oddities, but nothing
> that needs to be fixed or that would be architecture specific.

In principle I don't disagree.  However this warning was a specific
request of the driver writers.  Since the driver is pretty much dead,
I'm not sure anyone is going to check or fix it for non-intel any time
soon.

James
