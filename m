From: Sebastian Herbszt <herbszt@gmx.de>
Subject: Re: [PATCH kernel] commit 4fbdf9cb ("lpfc: Fix for lun discovery
 issue with saturn adapter.")
Date: Sat, 23 May 2015 11:31:48 +0200
Message-ID: <20150523113148.00002dfc@localhost>
References: <1430209582-23925-1-git-send-email-aik@ozlabs.ru>
	<5548E2C1.3070209@emulex.com>
	<20150505234659.00003ab7@localhost>
	<555C0595.9060507@ozlabs.ru>
	<20150522133334.000064c9@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150522133334.000064c9@localhost>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E . J . Bottomley" <JBottomley@odin.com>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>, james.smart@emulex.com, linuxppc-dev@lists.ozlabs.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Sebastian Herbszt <herbszt@gmx.de>
List-Id: linux-scsi@vger.kernel.org

I wrote:
> Alexey Kardashevskiy wrote:
> > On 05/06/2015 07:46 AM, Sebastian Herbszt wrote:
> > > James Smart wrote:
> > >>
> > >> Reviewed-By: James Smart <james.smart@emulex.com>
> > >>
> > >>
> > >> Alexey, Sebastian,
> > >>
> > >> Yes - this section needs to be reverted.  This patch is good.
> > >>
> > >> -- james s
> > >
> > > Reviewed-by: Sebastian Herbszt <herbszt@gmx.de>
> > 
> > 
> > Unfortunately, just this revert is not enough, it fixed one of my machines 
> > but I have another machine with "Emulex Corporation Saturn-X: LightPulse 
> > Fibre Channel Host Adapter (rev 03)" which does not boot - the booting 
> > process stops at "[  OK  ] Reached target Basic System."
> > 
> > Any quick idea what else to revert between 4.0 and current upstream before 
> > I dig further? Thanks!
> 
> Is the other machine also POWER7?
> I tested the revert on x86 and it fixed my issue:
> 
> 4.1-rc4 (lpfc 10.5.0.0) - broken
> 4.0 + lpfc 10.5.0.0 - broken
> 4.1-rc4 (lpfc 10.5.0.0) + revert - ok
> 4.0 + lpfc 10.5.0.0 + revert - ok

James,

are you sending this revert to Linus any time soon?

Support for SLI-3 adapters is broken on all platforms for more than
a month now [1] and POWER7 doesn't seem to like it at all [2].

[1] http://marc.info/?l=linux-scsi&m=142938432414173
[2] http://marc.info/?l=linux-scsi&m=143021737816241

Sebastian
