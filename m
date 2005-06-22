From: "Gabor Z. Papp" <gzp@papp.hu>
Subject: Re: 2.4 and aacraid dmesg
Date: Wed, 22 Jun 2005 17:59:36 +0200
Message-ID: <x64qbq757b@gzp>
References: <60807403EABEB443939A5A7AA8A7458B0152148D@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from odpn1.odpn.net ([212.40.96.53]:49621 "EHLO odpn1.odpn.net")
	by vger.kernel.org with ESMTP id S261555AbVFVP7n (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Jun 2005 11:59:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: linux-scsi@vger.kernel.org

* "Salyzyn, Mark" <mark_salyzyn@adaptec.com>:

| >Multimedia audio controller: Creative Labs SB Live! EMU10k1 (rev 08)
| 
| Do you really need the audio card? :-) I'd toss (or disable) the audio
| system in a heart beat just to remove the annoyance of the messages.

ehaehaeh. Well, its not an enterprise server. I just prefer hw raid
over sw. The cheapest scsi hw raid card was this model, thats why I
bought to server me. Running with 2 Seagate Cheetah 10K.7 in raid1.

| Do keep the F/W up-to-date if you should run into problems.

Thanks for the hint.

| The 2200S is more than four times as fast (when stressed to the
| maximum), the 2120S was meant for 'budget' scenarios with feature
| completeness in mind.

Ideal for home usage. ;-)

| > Ah, the chip is *very* *very* *very* hot on the card, is that normal?
| 
| I can put my hand on the CPU and keep it there with only a smidgen of
| concern and nary a sizzling sound. I would worry if you could cook eggs
| on it.

I can!

| Do you have a means to measure the actual temperature to add some
| objectivism?

Well, the mobo temp is around 47C, and I bet the chip is over 60.
I can't touch it. I was thinking about installing a mini fan on the
heatsink. Oh, about the heatsink, I see its something like a
"tuning", or a homebrew work. I think adaptec put the heatsink on the
chip after they discovered the cooling problem. But I can be wrong.
