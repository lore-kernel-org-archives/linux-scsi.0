From: "Smart, James" <James.Smart@Emulex.Com>
Subject: RE: [PATCH]: Flexible timeout infrastructure
Date: Wed, 16 Jun 2004 13:33:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3356669BBE90C448AD4645C843E2BF28034F94F3@xbl.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:64241 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S264278AbUFPRfA
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Jun 2004 13:35:00 -0400
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <James.Bottomley@SteelEye.com>
Cc: Luben Tuikov <luben_tuikov@adaptec.com>, Mike Anderson <andmike@us.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Sorry, guess I wasn't clear.

reset - meant timer reset. And I completely follow that the command is not
being retried, etc, just the timeout restarted.

I'll try to restate. The patch proposed to allow only 1 restart of the timer
for a command. My comment was - why not 2, or 3?  I would think - the number
of restarts needed is a function of how long the timeout value is vs when
the LLDD event occurs and what the duration of the LLDD event is. I can see
capping the number of timer restarts, but am not sure 1 is the best choice. 

-- james
