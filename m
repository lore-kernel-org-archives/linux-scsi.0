From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Random scsi disk disappearing
Date: Fri, 18 Aug 2006 00:33:42 +0200
Message-ID: <44E4EEC6.6040900@s5r6.in-berlin.de>
References: <OF23DA8DB2.DFFECE8E-ON422571CD.005B6F56-422571CD.005BA03C@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:20713 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1030277AbWHQWfr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Aug 2006 18:35:47 -0400
In-Reply-To: <OF23DA8DB2.DFFECE8E-ON422571CD.005B6F56-422571CD.005BA03C@de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andreas Herrmann <AHERRMAN@de.ibm.com>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>, Michael Tokarev <mjt@tls.msk.ru>

Andreas Herrmann wrote:
> Anyone interested in a script to conveniently interpret or change the
> SCSI logging level? Such a script (scsi_logging_level) exists in the
> s390-tools package (version 1.5.3).

That would be very welcome.

> If others show interest for this script, maybe a better place can be
> found than s390-tools (because it is not really s390-specific).

It could be put into linux/Documentation/scsi/. People who are 
confronted with a debugging problem probably look into Documentation/. 
Also, scripts which demonstrate usage of certain kernel interfaces do 
count as valuable documentation.
-- 
Stefan Richter
-=====-=-==- =--- =--=-
http://arcgraph.de/sr/
