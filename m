From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: PROBLEM: 2.6.0-test9: SCSI mid layer tells a lie.
Date: Thu, 4 Dec 2003 12:21:27 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031204202127.GB2265@beaverton.ibm.com>
References: <0E3FA95632D6D047BA649F95DAB60E57037F83D5@exa-atlanta.se.lsil.com> <200312032348.AA02824@fukuchi.jp.fujitsu.com> <20031204020508.GB1775@beaverton.ibm.com> <007b01c3ba77$07612f30$2987110a@lsd.css.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.132]:53135 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S263298AbTLDURC
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Dec 2003 15:17:02 -0500
Content-Disposition: inline
In-Reply-To: <007b01c3ba77$07612f30$2987110a@lsd.css.fujitsu.com>
List-Id: linux-scsi@vger.kernel.org
To: Hironobu Ishii <ishii.hironobu@jp.fujitsu.com>
Cc: Masao Fukuchi <fukuchi.masao@jp.fujitsu.com>, "Moore, Eric Dean" <emoore@lsil.com>, linux-scsi <linux-scsi@vger.kernel.org>, mpt_linux_developer@lsil.com

Hironobu Ishii [ishii.hironobu@jp.fujitsu.com] wrote:
> Thank you, Mike.
> 
> Your patch solved the problem.
> I appreciate your quick help.

Thanks for testing it. I am going to make a slight change and then
repost the patch on a new thread.

In looking at the patch we only want to set result if it is not already
set. This is rare case as the error handler is normally ran for commands
that have timedout.

-andmike
--
Michael Anderson
andmike@us.ibm.com

