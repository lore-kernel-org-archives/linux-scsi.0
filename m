From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: RFC: Transport identifier
Date: Sat, 28 Feb 2009 15:53:31 +0100
Message-ID: <49A94FEB.6050400@s5r6.in-berlin.de>
References: <yq1iqmxg6o4.fsf@sermon.lab.mkp.net>	<1235663301.19035.44.camel@localhost.localdomain> <yq1prh5ey7b.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:42808 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbZB1Oxp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 28 Feb 2009 09:53:45 -0500
In-Reply-To: <yq1prh5ey7b.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

Martin K. Petersen wrote:
> The thing is we need to start sending RC16 to a lot of drives very soon
> because of the 4KB thing.  And as we've seen RC16 breaks a lot of junk
> devices.  So we need a good indicator other than the SCSI rev. because
> that unfortunately doesn't cut it.

/Is/ the used transport protocol a good indicator for whether a
particular target breaks by READ CAPACITY 16?  I have doubts.  Command
set support is independent of transport protocol support.
-- 
Stefan Richter
-=====-==--= --=- ===--
http://arcgraph.de/sr/
