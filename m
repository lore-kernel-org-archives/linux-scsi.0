From: William Breathitt Gray <vilhelm.gray@gmail.com>
Subject: Re: [PATCH 0/4] Decouple X86_32 dependency from the ISA Kconfig
 option
Date: Wed, 13 Apr 2016 10:48:42 -0400
Message-ID: <20160413144842.GA26005@sophia>
References: <cover.1460379702.git.vilhelm.gray@gmail.com>
 <20160413072602.GA7629@gmail.com>
 <20160413121515.GA23870@sophia>
 <20160413143838.GD5867@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:36167 "EHLO
	mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759395AbcDMOsu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Apr 2016 10:48:50 -0400
Content-Disposition: inline
In-Reply-To: <20160413143838.GD5867@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, gregkh@linuxfoundation.org, x86@kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, alsa-devel@alsa-project.org

On Wed, Apr 13, 2016 at 04:38:38PM +0200, Ingo Molnar wrote:
>Ah, ok, so it's for enabling real hardware, not just a cleanup, right? You might 
>want to put that info into the boilerplate mail or so.
>
>I'm perfectly fine with all the patches that touch x86 code:
>
>  Acked-by: Ingo Molnar <mingo@kernel.org>
>
>I suppose you'd like to have these in the driver tree, all in one place?
>
>Thanks,
>
>	Ingo

Ah yes, in retrospect I should have made it clear that this was for
supporting hardware rather than simply code cleanup. That was an
oversight on my part not to have made it more explicit.

Introducing everything to the driver tree would be most convenient, thus
allowing me to quickly release my subsequent patches which will be
rebased on top of these.

William Breathitt Gray
