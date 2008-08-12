From: Giuliano Pochini <pochini@shiny.it>
Subject: removable device: can't detect disk changes
Date: Tue, 12 Aug 2008 15:08:14 +0200
Message-ID: <20080812150814.a2fd58cd.pochini@shiny.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out26.alice.it ([85.33.2.26]:3901 "EHLO
	smtp-out26.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250AbYHLNXR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Aug 2008 09:23:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Fujitsu magneto-optical drive, Adaptec 29160 and 
Linux Jay 2.6.26 #7 SMP Sun Aug 10 18:34:22 CEST 2008 ppc 7455, altivec supported PowerMac3,6 GNU/Linux

When I insert a disk and I mount it, scsi_test_unit_ready() is called and
the do-while loop gets sshdr->sense_key == UNIT_ATTENTION in the first
cycle and 0 in the second one. So the if below misses the UNIT_ATTENTION
and sdev->changed = 1 is not executed. At this point bad things can
happen... I'm not sure how to fix this. Any clue ?


--
Giuliano.
