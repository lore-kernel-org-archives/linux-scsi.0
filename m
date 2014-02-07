From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: LSI SAS2008 SATA TRIM not working
Date: Fri, 07 Feb 2014 15:59:40 -0500
Message-ID: <yq1mwi2skoz.fsf@sermon.lab.mkp.net>
References: <1391730975.3449.16.camel@sonic.justonedata.com>
	<yq1vbwqslek.fsf@sermon.lab.mkp.net>
	<1391806363.2761.8.camel@sonic.justonedata.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34071 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbaBGVAN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Feb 2014 16:00:13 -0500
In-Reply-To: <1391806363.2761.8.camel@sonic.justonedata.com> (Kurt Miller's
	message of "Fri, 07 Feb 2014 15:52:43 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kurt Miller <kurt@intricatesoftware.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

>>>>> "Kurt" == Kurt Miller <kurt@intricatesoftware.com> writes:

Kurt> Thank you for your reply. Below is the output you requested. Note
Kurt> that when the EVO's are connected to a SATA AHCI port on my
Kurt> desktop motherboard, TRIM works okay. Please let me know if you
Kurt> need additional information.

Kurt>    provisioning: lbpme=0, lbprz=0 Last logical block
                       ^^^^^^^

This indicates the SAT on the mpt2sas board didn't enable discard
support for the drive.

Please provide the full output of hdparm -I. Maybe we can get some clues
as to why that is...

-- 
Martin K. Petersen	Oracle Linux Engineering
