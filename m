From: Andi Kleen <ak@muc.de>
Subject: Re: 2.6.6 + Adaptec I2O
Date: 1 Jun 2004 21:25:52 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040601191853.GA63663@colin2.muc.de>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189FAD5143@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from colin2.muc.de ([193.149.48.15]:27398 "HELO colin2.muc.de")
	by vger.kernel.org with SMTP id S265155AbUFATdH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jun 2004 15:33:07 -0400
Date: Tue, 1 Jun 2004 21:25:52 +0200
Content-Disposition: inline
In-Reply-To: <547AF3BD0F3F0B4CBDC379BAC7E4189FAD5143@otce2k03.adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: Matthew Wilcox <willy@debian.org>, Andi Kleen <ak@muc.de>, linux-scsi@vger.kernel.org

> The management tools could (but doesn't for linux, this is for sake of
> argument) report the driver was built for an i386 processor, yet we
> could be running on an i686 kernel. Other drivers from DPT/Adaptec for
> other operating systems have the same ioctl call populated with the same
> information.

Sounds useless to me. At least for linux you would need to report
a lot more than what you currently do to figure out if the driver
is compatible to a given kernel.

 e.g. how the kernel was built (with SMP, without, with PREEMPT etc., 
with what compiler etc.) See what the linux module loader checks.
In addition the distribution vendor may be needed.

Also PROC_SEXIUM is definitely wrong then since an x86-64 driver
is completely different from a i686 driver.

-Andi
