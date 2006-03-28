From: Matthias Andree <matthias.andree@gmx.de>
Subject: Re: [PATCH] Move SG_GET_SCSI_ID from sg to scsi
Date: Tue, 28 Mar 2006 11:43:22 +0200
Message-ID: <20060328094322.GA345@merlin.emma.line.org>
References: <Pine.LNX.4.58.0603262108500.13001@be1.lrz> <Pine.LNX.4.64.0603261424590.15714@g5.osdl.org> <Pine.LNX.4.58.0603271306140.3209@be1.lrz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751281AbWC1Jn3@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0603271306140.3209@be1.lrz>
Sender: linux-kernel-owner@vger.kernel.org
To: Bodo Eggert <7eggert@gmx.de>
Cc: Linus Torvalds <torvalds@osdl.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Bodo Eggert schrieb am 2006-03-27:

> As I understand, having a /dev/sd0815 corresponding to a /dev/sg4711 is
> the root of all evil and idiotic things, and moving all sg functions into
> the apropiate place is the sane thing to do.
> 
> This patch is a part of the process, and as soon as all sg functions are
> available using /dev/s[dtr]*, the corresponding sg devices should be
> deprecated and removed.

Oh, I hear Schilling wailing...

Seriously, at the time such changes are committed, a good manual for how
user-space applications are to be upgraded wouldn't hurt, and I am
indeed proposing that those familiar with the code should write it -
perhaps when porting an existing application to the new interfaces.

-- 
Matthias Andree
