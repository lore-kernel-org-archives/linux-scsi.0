From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: spinlock_irqsave() && flags (Was: pm80xx: Spinlock fix)
Date: Mon, 23 Dec 2013 10:43:07 -0800
Message-ID: <CA+55aFwPUVeZTn5-_RhvGTQA2v3TOPafGPH-JAEwdVA5qE4FSA@mail.gmail.com>
References: <52B8357D.60202@redhat.com>
	<52B83B89.9040700@gmail.com>
	<CE2C58F938F4C44EA74FFF880BAA7E5E1C68AA8A@BBYEXM01.pmc-sierra.internal>
	<CAD0Z9T+69VoSnDY-Sj7a1QfJ-KLJYVyL9=WQ123XMfRvQmGdsg@mail.gmail.com>
	<52B8518B.4060204@gmail.com>
	<52B8569D.4050101@redhat.com>
	<CAD0Z9TK-cn=X3ywSzPnEQN-FB+ue+0dHQ3EHuwonC+KfgrmPMA@mail.gmail.com>
	<20131223163410.GA28220@redhat.com>
	<20131223172744.GA2069@redhat.com>
	<CA+55aFy_y45feJNJgFa=Taks0GpxiXEMJexhjVVYH-vVFkPmkA@mail.gmail.com>
	<20131223182455.GA5656@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ea0-f179.google.com ([209.85.215.179]:55091 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640Ab3LWSnJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Dec 2013 13:43:09 -0500
In-Reply-To: <20131223182455.GA5656@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: Jason Seba <jason.seba42@gmail.com>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Tomas Henzl <thenzl@redhat.com>, Jack Wang <xjtuwjp@gmail.com>, Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>, Viswas G <Viswas.G@pmcs.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "JBottomley@parallels.com" <JBottomley@parallels.com>, Vasanthalakshmi Tharmarajan <Vasanthalakshmi.Tharmarajan@pmcs.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On Mon, Dec 23, 2013 at 10:24 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> However, the code above already has the users. Do you think it makes
> sense to add something like

No. I think it makes sense to put a big warning on any users you find,
and fart in the general direction of any developer who did that broken
pattern.

Because code like that is obviously crap.

                Linus
