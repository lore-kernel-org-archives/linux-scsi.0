From: Sebastian Herbszt <herbszt@gmx.de>
Subject: Re: [PATCH kernel] commit 4fbdf9cb ("lpfc: Fix for lun discovery
 issue with saturn adapter.")
Date: Fri, 22 May 2015 13:33:34 +0200
Message-ID: <20150522133334.000064c9@localhost>
References: <1430209582-23925-1-git-send-email-aik@ozlabs.ru>
	<5548E2C1.3070209@emulex.com>
	<20150505234659.00003ab7@localhost>
	<555C0595.9060507@ozlabs.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:65513 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756961AbbEVLea (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 May 2015 07:34:30 -0400
In-Reply-To: <555C0595.9060507@ozlabs.ru>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: james.smart@emulex.com, linuxppc-dev@lists.ozlabs.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, "James E . J . Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Sebastian Herbszt <herbszt@gmx.de>

Alexey Kardashevskiy wrote:
> On 05/06/2015 07:46 AM, Sebastian Herbszt wrote:
> > James Smart wrote:
> >>
> >> Reviewed-By: James Smart <james.smart@emulex.com>
> >>
> >>
> >> Alexey, Sebastian,
> >>
> >> Yes - this section needs to be reverted.  This patch is good.
> >>
> >> -- james s
> >
> > Reviewed-by: Sebastian Herbszt <herbszt@gmx.de>
> 
> 
> Unfortunately, just this revert is not enough, it fixed one of my machines 
> but I have another machine with "Emulex Corporation Saturn-X: LightPulse 
> Fibre Channel Host Adapter (rev 03)" which does not boot - the booting 
> process stops at "[  OK  ] Reached target Basic System."
> 
> Any quick idea what else to revert between 4.0 and current upstream before 
> I dig further? Thanks!

Is the other machine also POWER7?
I tested the revert on x86 and it fixed my issue:

4.1-rc4 (lpfc 10.5.0.0) - broken
4.0 + lpfc 10.5.0.0 - broken
4.1-rc4 (lpfc 10.5.0.0) + revert - ok
4.0 + lpfc 10.5.0.0 + revert - ok

Sebastian
