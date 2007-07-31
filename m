From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Inclusion of vmware mptbase regression fix
Date: Tue, 31 Jul 2007 15:49:27 -0500
Message-ID: <1185914967.3468.45.camel@localhost.localdomain>
References: <20070731202402.63f55ae5@localhost>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:39151 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756202AbXGaUta (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Jul 2007 16:49:30 -0400
In-Reply-To: <20070731202402.63f55ae5@localhost>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maarten Bressers <info@mbressers.speedlinq.nl>
Cc: petr@vandrovec.name, dsd@gentoo.org, mpt_linux_developer@lsi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, 2007-07-31 at 20:24 +0200, Maarten Bressers wrote:
> Hi Petr,
> 
> The patch you posted for the MPT Fusion driver regression with VMware 
> 5.5.4 (http://lkml.org/lkml/2007/3/23/345) was used to fix a Gentoo 
> kernel bug (http://bugs.gentoo.org/show_bug.cgi?id=185272).
> 
> Have you received word from upstream (kernel devs) yet as to whether 
> your patch will be included? Or if it will be included at all?

That's a slightly worse version of this patch.

http://marc.info/?l=linux-scsi&m=117432237404247

And the answer's still the same: fix the vmware fusion emulation ...
it's a software thing too.

James


