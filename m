From: Andi Kleen <ak@muc.de>
Subject: Re: 2.6.6 + Adaptec I2O
Date: Tue, 01 Jun 2004 20:20:52 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <m3ekozi1h7.fsf@averell.firstfloor.org>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189FAD5129@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zero.aec.at ([193.170.194.10]:4615 "EHLO zero.aec.at")
	by vger.kernel.org with ESMTP id S264965AbUFASUz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jun 2004 14:20:55 -0400
In-Reply-To: <547AF3BD0F3F0B4CBDC379BAC7E4189FAD5129@otce2k03.adaptec.com> (Mark
 Salyzyn's message of "Tue, 1 Jun 2004 13:25:14 -0400")
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: linux-scsi@vger.kernel.org

"Salyzyn, Mark" <mark_salyzyn@adaptec.com> writes:

> PROC_SEXIUM was reserved by our application software group when we added
> PROC_PENTIUM. PROC_SEXIUM was simply a `followon' processor of a
> different feather. The dptsig.h file actually is shared with (many)
> other sources, so it carries an impact.
>
> Branching this file, notwithstanding ... sooo ... if it is to change,
> maybe it should be set to PROC_EM64T ...

Better call it PROC_X86_64 then. That's the standard name for the 
architecture on Linux.

What is this used for anyways? I'm not really sure why a driver should
know about the CPU type. How about just dropping it?

-Andi


