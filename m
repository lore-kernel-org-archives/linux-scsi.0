From: Matthias Andree <matthias.andree@gmx.de>
Subject: Re: sym53c8xx_2 make scsitap slow
Date: Wed, 12 Jan 2005 23:19:22 +0100
Message-ID: <m3d5waqoid.fsf@merlin.emma.line.org>
References: <15050.1105528515@www34.gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from krusty.dt.E-Technik.Uni-Dortmund.DE ([129.217.163.1]:60576 "EHLO
	mail.dt.e-technik.uni-dortmund.de") by vger.kernel.org with ESMTP
	id S261486AbVALWTX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Jan 2005 17:19:23 -0500
In-Reply-To: <15050.1105528515@www34.gmx.net> (frage schnell's message of
	"Wed, 12 Jan 2005 12:15:15 +0100 (MET)")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: frage schnell <frage.schnell@gmx.de>
Cc: linux-scsi@vger.kernel.org

"frage schnell" <frage.schnell@gmx.de> writes:

> I used a HP ulrium storage on a tekteam DC-390U2B with kernel 2.6.5 and
> modul sym53c8xx 
>   tar writs with 11MB/s to the tape
> with new kernel 2.6.8 or 2.6.10
>    tar writs with 3MB/s to the tape
>
> wath have I to to to get the same speed with the new kennel 

Please provide dmesg logs to shed some light on the detection of the
adaptor and tape drive.

-- 
Matthias Andree
