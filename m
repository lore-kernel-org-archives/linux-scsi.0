From: James Bottomley <James.Bottomley@steeleye.com>
Subject: RE: [PATCH]: Flexible timeout infrastructure
Date: 16 Jun 2004 12:38:20 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1087407501.2067.37.camel@mulgrave>
References: <3356669BBE90C448AD4645C843E2BF28034F94F3@xbl.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:12717 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264288AbUFPRie (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Jun 2004 13:38:34 -0400
In-Reply-To: <3356669BBE90C448AD4645C843E2BF28034F94F3@xbl.ma.emulex.com>
List-Id: linux-scsi@vger.kernel.org
To: "Smart, James" <James.Smart@Emulex.Com>
Cc: Luben Tuikov <luben_tuikov@adaptec.com>, Mike Anderson <andmike@us.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2004-06-16 at 12:33, Smart, James wrote:
> I'll try to restate. The patch proposed to allow only 1 restart of the timer
> for a command. My comment was - why not 2, or 3?  I would think - the number
> of restarts needed is a function of how long the timeout value is vs when
> the LLDD event occurs and what the duration of the LLDD event is. I can see
> capping the number of timer restarts, but am not sure 1 is the best choice. 

It does.  But the number of allowed restarts is linked to the command
retries (actually allowed retries + 1).

James


