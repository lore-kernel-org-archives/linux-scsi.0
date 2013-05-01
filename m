From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 10/21] [SCSI] nsp32: use mdelay instead of large udelay
 constants
Date: Wed, 01 May 2013 06:55:54 -0700
Message-ID: <1367416554.4791.8.camel@dabdike.int.hansenpartnership.com>
References: <1366910944-3033663-1-git-send-email-arnd@arndb.de>
	 <1366910944-3033663-11-git-send-email-arnd@arndb.de>
	 <CALZLnaFeLcaGM7_McTZ=pKBRnpXk0AvqOTF=1YCqJv-53yk4XQ@mail.gmail.com>
	 <201304291521.14195.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:48186 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754325Ab3EANzz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 May 2013 09:55:55 -0400
In-Reply-To: <201304291521.14195.arnd@arndb.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Masanori Goto <gotom@sanori.org>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>, linux-scsi@vger.kernel.org


On Mon, 2013-04-29 at 15:21 +0200, Arnd Bergmann wrote:
> On Friday 26 April 2013, Masanori Goto wrote:
> > 2013/4/25 Arnd Bergmann <arnd@arndb.de>
> > >
> > > ARM cannot handle udelay for more than 2 miliseconds, so we
> > > should use mdelay instead for those.
> > >
> > 
> > Singed-off-by: GOTO Masanori <gotom@debian.or.jp>
> 
> Thanks. I assume you mean "Acked-by", not "Singed-off" as in "burnt"
> or "Signed-off" as a notification that you have applied it to your
> own git tree.
> 
> I'll keep the patch with an your "Acked-by" line in my tree unless
> James wants to apply to the scsi tree.

I can, certainly.  I'll be sending the first scsi set today, but I'll be
doing another one for just before the close of the merge window.

Goto-san, while I have your attention, is the nsp_cs driver orphaned? I
know it's not your driver, but you did once work with its author (YOKOTA
Hiroshi <yokota@netlab.is.tsukuba.ac.jp>) and I'm trying to get some
cleanup on the static functions in the header files.

Thanks,

James











