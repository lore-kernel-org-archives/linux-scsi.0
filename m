From: "Tony Battersby" <tonyb@cybernetics.com>
Subject: RE: STK9840/SYM53c875 ODD transfer in DATA OUT phase
Date: Fri, 26 Sep 2003 13:27:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <03Sep26.132713edt.332206@cyborg.cybernetics.com>
References: <Pine.LNX.4.58.0309260858210.1793@filesrv1.baby-dragons.com>
Reply-To: <tonyb@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cyborg.cybernetics.com ([206.246.200.18]:60172 "EHLO
	cybernetics.com") by vger.kernel.org with ESMTP id S261554AbTIZR12
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Sep 2003 13:27:28 -0400
In-Reply-To: <Pine.LNX.4.58.0309260858210.1793@filesrv1.baby-dragons.com>
List-Id: linux-scsi@vger.kernel.org
To: "'Mr. James W. Laferriere'" <babydr@baby-dragons.com>, 'Jes Sorensen' <jes@wildopensource.com>
Cc: 'KELEMEN Peter' <Peter.Kelemen@cern.ch>, linux-scsi@vger.kernel.org

> If memory serves this is driver related .  And IIRC someone has
> made changes or at least put forth a patch to attempt to aleviate
> the odd byte count problem .  It is in (Again IIRC) both of the
> Symbois drivers (ie: 53c8xx.c & sym53c8xx_2) .  Do try a newer
> kernel than 2.4.21 tho 2.4.22 is what I am running .

Yes, this is an old problem that keeps coming up.  See:

http://marc.theaimsgroup.com/?t=101018223200001&r=1&w=2
http://marc.theaimsgroup.com/?t=106074664100005&r=1&w=2

I have not seen any patch to fix it.  My minor change in 2.4.22 was for
the Ignore Wide Residue message on a Request Sense command, but that was
a different issue.

Anthony J. Battersby
Cybernetics

