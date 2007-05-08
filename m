From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: [PATCH] zfcp: Stop system after memory corruption
Date: Tue, 8 May 2007 14:58:24 +0200
Message-ID: <20070508125824.GA14085@schmichrtp>
References: <200705071635.04585.swen.schillig@freenet.de> <646765f40705070856y28d958f8xe2e286ab347d63a5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:39029 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967451AbXEHNBj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 May 2007 09:01:39 -0400
Content-Disposition: inline
In-Reply-To: <646765f40705070856y28d958f8xe2e286ab347d63a5@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Swen Schillig <swen.schillig@freenet.de>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org

On Tue, May 08, 2007 at 01:56:07AM +1000, Julian Calaby wrote:
> >From: Christof Schmitt <christof.schmitt@de.ibm.com>
> [snip]
> >-                               ZFCP_LOG_NORMAL("bug: unexpected inbound "
> >-                                               "packet on adapter %s "
> >-                                               "(reqid=0x%lx, "
> >-                                               "first_element=%d, "
> >-                                               "elements_processed=%d)\n",
[...]
> As a minor quibble, may I suggest that these lines belong just above
> the panic introduced above? I assume that they'd be useful for
> debugging should this situation occur.

If this problem occurs, the administrator of the Linux system will be
advised to dump the Linux system and to also capture the logs from the
FCP adapter. The memory dump already contains the information about the 
unexpected packet and also information about the last requests
sent to the FCP adapter. So, the messages do not provide additional
debug data, and i removed them to simplify the code.

Christof Schmitt
