From: Hironobu Ishii <ishii.hironobu@jp.fujitsu.com>
Subject: Re: PROBLEM: 2.6.0-test9: SCSI mid layer tells a lie.
Date: Thu, 04 Dec 2003 23:58:05 +0900
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <007b01c3ba77$07612f30$2987110a@lsd.css.fujitsu.com>
References: <0E3FA95632D6D047BA649F95DAB60E57037F83D5@exa-atlanta.se.lsil.com>
 <200312032348.AA02824@fukuchi.jp.fujitsu.com>
 <20031204020508.GB1775@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;	charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:32140 "EHLO
	fgwmail5.fujitsu.co.jp") by vger.kernel.org with ESMTP
	id S262228AbTLDO6f (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Dec 2003 09:58:35 -0500
Received: from m1.gw.fujitsu.co.jp ([10.0.50.71]) by fgwmail5.fujitsu.co.jp (8.12.10/Fujitsu Gateway)
	id hB4EwXVv006451 for <linux-scsi@vger.kernel.org>; Thu, 4 Dec 2003 23:58:33 +0900
	(envelope-from ishii.hironobu@jp.fujitsu.com)
Received: from s3.gw.fujitsu.co.jp by m1.gw.fujitsu.co.jp (8.12.10/Fujitsu Domain Master)
	id hB4EwXap028455 for <linux-scsi@vger.kernel.org>; Thu, 4 Dec 2003 23:58:33 +0900
	(envelope-from ishii.hironobu@jp.fujitsu.com)
Received: from fjmail502.fjmail.jp.fujitsu.com (fjmail502-0.fjmail.jp.fujitsu.com [10.59.80.98]) by s3.gw.fujitsu.co.jp (8.12.10)
	id hB4EwWwS014388 for <linux-scsi@vger.kernel.org>; Thu, 4 Dec 2003 23:58:32 +0900
	(envelope-from ishii.hironobu@jp.fujitsu.com)
Received: from CARREN (fjscan502-0.fjmail.jp.fujitsu.com [10.59.80.122])
 by fjmail502.fjmail.jp.fujitsu.com
 (Sun Internet Mail Server sims.4.0.2001.07.26.11.50.p9)
 with SMTP id <0HPD00JARLLJ05@fjmail502.fjmail.jp.fujitsu.com> for
 linux-scsi@vger.kernel.org; Thu,  4 Dec 2003 23:58:32 +0900 (JST)
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>, Masao Fukuchi <fukuchi.masao@jp.fujitsu.com>
Cc: "Moore, Eric Dean" <emoore@lsil.com>, linux-scsi <linux-scsi@vger.kernel.org>, mpt_linux_developer@lsil.com

----- Original Message ----- 
From: "Mike Anderson" <andmike@us.ibm.com>
To: "Masao Fukuchi" <fukuchi.masao@jp.fujitsu.com>
Cc: "Moore, Eric Dean" <emoore@lsil.com>; "Hironobu Ishii"
<ishii.hironobu@jp.fujitsu.com>; "linux-scsi" <linux-scsi@vger.kernel.org>;
<mpt_linux_developer@lsil.com>
Sent: Thursday, December 04, 2003 11:05 AM
Subject: Re: PROBLEM: 2.6.0-test9: SCSI mid layer tells a lie.


> In reviewing the error handler with Patrick it looks like there is a bug
> in scsi_eh_flush_done_q when scmd->allowed has been exceeded and the
> command error was a timeout.
>
> The patch below may help, but I only have compile / boot tested it.
> Could you test this on your error and see if it helps.
>

> DESC
> This patch fixes a bug in scsi_eh_flush_done_q when the allowed count has
> been exceeded and the command errored for a timeout. The bug is that the
> result will be left at zero and the command finished.


Thank you, Mike.

Your patch solved the problem.
I appreciate your quick help.

Hironobu Ishii

