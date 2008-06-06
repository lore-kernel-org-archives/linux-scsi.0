From: "Martin K. Petersen" <mkp@mkp.net>
Subject: Re: [PATCH] scsi_debug: Runtime-configurable sector size
Date: Thu, 05 Jun 2008 20:53:28 -0400
Message-ID: <yq1skvrmliv.fsf@sermon.lab.mkp.net>
References: <yq18wxko6yc.fsf@sermon.lab.mkp.net>
	<1212679735.13549.35.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jaguar.mkp.net ([192.139.46.146]:51670 "EHLO jaguar.mkp.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751654AbYFFAx3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Jun 2008 20:53:29 -0400
In-Reply-To: <1212679735.13549.35.camel@localhost.localdomain> (James Bottomley's message of "Thu\, 05 Jun 2008 10\:28\:55 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Douglas Gilbert <dougg@torque.net>

>>>>> "James" == James Bottomley <James.Bottomley@HansenPartnership.com> writes:

James> This could have used some checkpatch love:

James> total: 9 errors, 2 warnings, 181 lines checked

James> About 8 of the errors are spaces before tab (one is the fact
James> that checkpatch doesn't like struct * foo, but that's the style
James> of the file, so I left it in).

Ugh, sorry about that.  I did a search and replace on the old macro so
I didn't notice the extraneous spaces in the original.

-- 
Martin K. Petersen      http://mkp.net/
