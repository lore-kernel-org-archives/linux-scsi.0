From: Martin Zuziak <zuziak@math.ku.dk>
Subject: aic79xx driver - hotswap error
Date: Mon, 28 Aug 2006 14:15:46 +0200
Message-ID: <20060828121542.GA13993@pc000ffe3ca343.math.ku.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imf.math.ku.dk ([130.225.103.32]:55943 "EHLO mail.math.ku.dk")
	by vger.kernel.org with ESMTP id S932104AbWH1MPy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Aug 2006 08:15:54 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello all

Hot-swapping doesn't seem to work with the aic79xx driver in kernel
2.6.17.9. Removing or adding a disk from/to a running system makes i/o
to any disk on the bus fail.

The machine is an IBM x346 server with a x86_64 cpu and a aic7902 scsi
controller.

A copy of the system log is here:
http://www.math.ku.dk/~zuziak/tmp/aic79xx_error_2.6.17.9.log

It shows the result of removing the third disk: the first disk (the only
one mounted) becomes inaccessible.

Kernel 2.6.15.7 seems to work but I have had no luck with newer kernels.

Has anyone seen hot-swapping work with the aic79xx driver in recent
kernels?

Sincerely,

Martin Zuziak <zuziak@math.ku.dk>

