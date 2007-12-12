From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: broken dpt_i2o in 2.6.23 (was: ext2 check page: bad entry in
 directory) (fwd)
Date: Wed, 12 Dec 2007 03:38:08 -0800
Message-ID: <20071212033808.6fb92139.akpm@linux-foundation.org>
References: <20071212105841.GN6770@1und1.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50073 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754773AbXLLLim (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Dec 2007 06:38:42 -0500
In-Reply-To: <20071212105841.GN6770@1und1.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anders Henke <anders.henke@1und1.de>
Cc: miquels@cistron.nl, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, matthew@wil.cx, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>linux-scsi@vger.kernel.org

On Wed, 12 Dec 2007 11:58:41 +0100 Anders Henke <anders.henke@1und1.de> wrote:

> Hi,
> 
> I'd like to let you now that my boxes are running a 32-bit kernel, so
> the 64-bit-uncleanliness shouldn't apply to my boxes; however,
> 
> http://www.miquels.cistron.nl/linux/dpt_i2o-64bit-2.6.23.patch
> 
> fixed the issue on my testbox.
> 
> I took a clean 2.6.23, applied patch, recompiled the kernel, reboot: works.

What a huge patch :(

We already reverted the offening patch so I assume that 2.6.24-rc5 is
working for you?

I guess we need to look at restoring "dpt_i2o: convert to SCSI hotplug
model" and then absorbing what Miquel has done there.

