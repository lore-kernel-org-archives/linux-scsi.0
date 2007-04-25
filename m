From: Adrian Bunk <bunk@stusta.de>
Subject: 2.6.21-rc7: known regressions with patches
Date: Thu, 26 Apr 2007 01:40:43 +0200
Message-ID: <20070425234043.GI3468@stusta.de>
References: <Pine.LNX.4.64.0704151659570.5473@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:34566 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754524AbXDYXkd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Apr 2007 19:40:33 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704151659570.5473@woody.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, CIJOML <cijoml@volny.cz>, Markus Rechberger <markus.rechberger@amd.com>, v4l-dvb-maintainer@linuxtv.org, Michal Piotrowski <michal.k.k.piotrowski@gmail.com>, Takashi Iwai <tiwai@suse.de>, perex@suse.cz, alsa-devel@alsa-project.org, David Miller <davem@davemloft.net>, Robert Peterson <rpeterso@redhat.com>, linux-driver@qlogic.com, linux-scsi@vger.kernel.org

This email lists some known regressions in Linus' tree compared to 2.6.20
with patches available.

If you find your name in the Cc header, you are either submitter of one
of the bugs, maintainer of an affectected subsystem or driver, a patch
of you caused a breakage or I'm considering you in any other way
possibly involved with one or more of these issues.

Due to the huge amount of recipients, please trim the Cc when answering.


Subject    : Oops when changing USB DVB-T adapter
References : http://lkml.org/lkml/2007/3/9/212
             http://lkml.org/lkml/2007/4/5/154
Submitter  : CIJOML <cijoml@volny.cz>
Handled-By : Markus Rechberger <markus.rechberger@amd.com>
Status     : patches available


Subject    : snd_intel8x0: divide error: 0000
References : http://lkml.org/lkml/2007/3/5/252
Submitter  : Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Handled-By : Takashi Iwai <tiwai@suse.de>
Patch      : http://lkml.org/lkml/2007/4/20/117
Status     : patch available


Subject    : qla2xxx driver no longer works
References : http://lkml.org/lkml/2007/4/16/49
             http://lkml.org/lkml/2007/4/20/224
Submitter  : David Miller <davem@davemloft.net>
             Robert Peterson <rpeterso@redhat.com>
Handled-By : David Miller <davem@davemloft.net>
Patch      : http://lkml.org/lkml/2007/4/16/234
Status     : patch was suggested


