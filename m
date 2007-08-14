From: Tore Anderson <tore@linpro.no>
Subject: Re: Linux 2.6.23-rc3
Date: Tue, 14 Aug 2007 15:07:18 +0200
Message-ID: <46C1A906.9050402@linpro.no>
References: <alpine.LFD.0.999.0708122143240.30176@woody.linux-foundation.org> <46C1717E.3030908@linpro.no> <46C19F57.3070801@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub.linpro.no ([213.236.139.167]:54438 "EHLO
	mailhub.linpro.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754780AbXHNNHU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Aug 2007 09:07:20 -0400
In-Reply-To: <46C19F57.3070801@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

* James Smart

> I've seen these before (and they haven't been specific to the LLDD).

  You're probably right.  I saw trouble happening when lpfc was in
 action and thought it might have something to do with it, but then
 again I'm not very intimate with the inner workings of the kernel.

> If you believe these are related to the -rc3 lpfc mods, I recommend 
> retesting on an -rc2 or 2.6.22 to see how similar they are.

  I have no opinion if this is something that appeared in -rc3 or not as
 I upgraded to it directly from 2.6.20 (which never gave me similar
 problems).  I'm compiling a new kernel with Matthew Wilcox' patch now,
 and will try a few more reboots to see how that helped.  I'll post
 about my findings tomorrow.

Regards
-- 
Tore Anderson
