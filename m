From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: sd: ZBC Update Read/Write Commands to SCSI spec
Date: Tue, 31 May 2016 22:50:53 -0400
Message-ID: <yq1vb1tvcz6.fsf@sermon.lab.mkp.net>
References: <1464188556.3020.4.camel@petroskoutoupis.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23022 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbcFACvG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 May 2016 22:51:06 -0400
In-Reply-To: <1464188556.3020.4.camel@petroskoutoupis.com> (Petros Koutoupis's
	message of "Wed, 25 May 2016 10:02:36 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Petros Koutoupis <petros@petroskoutoupis.com>
Cc: hare@suse.de, linux-scsi@vger.kernel.org

>>>>> "Petros" == Petros Koutoupis <petros@petroskoutoupis.com> writes:

Petros> Note, I did not place the a check for zoned devices in the
Petros> DIF-enabled conditional above, under the assumption that if the
Petros> media supports Type-2 then it should also support the 32-byte
Petros> commands. Thoughts?

That's correct.

-- 
Martin K. Petersen	Oracle Linux Engineering
