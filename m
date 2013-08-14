From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Incorrect LBA Returned from scsi_get_lba() and blk_rq_pos() (Possible DIF Impact)
Date: Wed, 14 Aug 2013 16:25:22 -0400
Message-ID: <yq161v8ggul.fsf@sermon.lab.mkp.net>
References: <340C71CD25A7EB49BFA81AE8C83926671B2EFFD6@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca>
	<yq1halhmmjr.fsf@sermon.lab.mkp.net>
	<405BE55790F03349A85344435F25B01C07A85C02@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29939 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758395Ab3HNUZc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Aug 2013 16:25:32 -0400
In-Reply-To: <405BE55790F03349A85344435F25B01C07A85C02@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca>
	(Kamaljit Singh's message of "Tue, 13 Aug 2013 14:43:36 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kamaljit Singh <Kamaljit.Singh@pmcs.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Sami Waheed <Sami.Waheed@pmcs.com>, linux-scsi@vger.kernel.org

>>>>> "Kamaljit" == Kamaljit Singh <Kamaljit.Singh@pmcs.com> writes:

Kamaljit> Did you get a chance to merge your changes into mainline?  I'm
Kamaljit> using 3.10.4 and am still seeing this issue.

Thanks for the reminder. No, I'm still sitting on some PI patches that
need to be merged. Will fix!

-- 
Martin K. Petersen	Oracle Linux Engineering
