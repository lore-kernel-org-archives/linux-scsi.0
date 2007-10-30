From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 2/2] Remove dma_coherent_mem interface
Date: Tue, 30 Oct 2007 15:26:31 -0500
Message-ID: <1193775991.3321.108.camel@localhost.localdomain>
References: <1193773405-15799-1-git-send-email-matthew@wil.cx>
	 <1193773405-15799-2-git-send-email-matthew@wil.cx>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:60178 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757695AbXJ3U0e (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Oct 2007 16:26:34 -0400
In-Reply-To: <1193773405-15799-2-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-arch@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, linux-scsi@vger.kernel.org, jejb@steeleye.com, Matthew Wilcox <willy@linux.intel.com>

On Tue, 2007-10-30 at 15:43 -0400, Matthew Wilcox wrote:
> This interface only had one user (and two implementations).
> It complicates other work, so remove it.

Its design was basically to facilitate the use of bus remote memory.
There's a long thread somewhere discussing this with the ARM people.
They had some type of SoC implementation that needed to allocate local
memory for device descriptors.  The Q720 is pretty much the same way, so
I used it to build the implementation when I created it for the ARM
people.  This is the original thread:

http://marc.info/?t=108757862100001

They said they were implementing this system, so I've no idea what
happened.  However, what are the problems the API is causing?  it seems
useful, so there should be a preference in its favour of existence
unless it's causing a problem.

James


