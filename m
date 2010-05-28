From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: scsi error handler thread seems to run continuously
Date: Fri, 28 May 2010 19:30:21 -0400
Message-ID: <x49hblrbo4y.fsf@segfault.boston.devel.redhat.com>
References: <x49wrunvioi.fsf@segfault.boston.devel.redhat.com>
	<AANLkTim-dZFhUm8IOLwQhNLovBmUxb5AnGYmbYci1YYK@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52727 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753253Ab0E1Xa3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 May 2010 19:30:29 -0400
In-Reply-To: <AANLkTim-dZFhUm8IOLwQhNLovBmUxb5AnGYmbYci1YYK@mail.gmail.com>
	(Mike Snitzer's message of "Fri, 28 May 2010 17:55:32 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: linux-scsi@vger.kernel.org, David Zeuthen <david@fubar.dk>

Mike Snitzer <snitzer@redhat.com> writes:

> Chatting with James on #storage we arrived at the fact that in my case
> the error handler was being triggered by: hald-addon-storage: polling
> /dev/sr0 (every 16 sec)
>
> Killing hald-addon-storage stops the 16s periodic scsi error handler messages.

Ahh, silence.  On my system, hald-addon-storage was polling /dev/sr0
every 2 seconds.  Killing this process, there's now nothing going on.

Thanks a ton!

-Jeff
