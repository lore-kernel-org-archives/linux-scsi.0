From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: LSI SAS2008 SATA TRIM not working
Date: Fri, 07 Feb 2014 20:24:18 -0500
Message-ID: <yq1iosqs8fx.fsf@sermon.lab.mkp.net>
References: <1391730975.3449.16.camel@sonic.justonedata.com>
	<yq1vbwqslek.fsf@sermon.lab.mkp.net>
	<1391806363.2761.8.camel@sonic.justonedata.com>
	<yq1mwi2skoz.fsf@sermon.lab.mkp.net>
	<1391808293.2761.9.camel@sonic.justonedata.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34424 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbaBHBYx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Feb 2014 20:24:53 -0500
In-Reply-To: <1391808293.2761.9.camel@sonic.justonedata.com> (Kurt Miller's
	message of "Fri, 07 Feb 2014 16:24:53 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kurt Miller <kurt@intricatesoftware.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

>>>>> "Kurt" == Kurt Miller <kurt@intricatesoftware.com> writes:

Kurt> #  hdparm -I /dev/sdc

[...]

I don't see any deterministic read after trim/read zero after trim
support on your drive. And I have a sneaking suspicion that those are
two of the fields that the LSI firmware looks at when deciding whether
to support logical block provisioning (in addition to support for the
DSM TRIM command).

-- 
Martin K. Petersen	Oracle Linux Engineering
