From: Matthias Andree <ma@dt.e-technik.uni-dortmund.de>
Subject: Re: Help needed: No CD-Recording on 2.6.9 / 2.6.10 for TEAC CD-R55S @ sym53c8xx
Date: Tue, 14 Dec 2004 21:53:41 +0100
Message-ID: <m3ekhsfvoq.fsf@merlin.emma.line.org>
References: <200412141738.01763.annabellesgarden@yahoo.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from krusty.dt.e-technik.Uni-Dortmund.DE ([129.217.163.1]:57551 "EHLO
	mail.dt.e-technik.uni-dortmund.de") by vger.kernel.org with ESMTP
	id S261650AbULNUxh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Dec 2004 15:53:37 -0500
In-Reply-To: <200412141738.01763.annabellesgarden@yahoo.de> (Karsten Wiese's
	message of "Tue, 14 Dec 2004 17:38:01 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Karsten Wiese <annabellesgarden@yahoo.de>
Cc: linux-scsi@vger.kernel.org, matthew@wil.cx

Karsten Wiese <annabellesgarden@yahoo.de> writes:

> IIRC stuff also ill behaved with 2.4 kernel and sym53c8xx_2 module.
> 2.4 kernel with ncr53c8xx module lets cdrecord work just fine. (Just
> verified with knoppix 3.4 boot cd.)

Are you using cdrecord setuid? If so, remove the setuid bit and retry
with "sudo".

-- 
Matthias Andree
