From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: LSI SAS2008 SATA TRIM not working
Date: Fri, 07 Feb 2014 15:44:19 -0500
Message-ID: <yq1vbwqslek.fsf@sermon.lab.mkp.net>
References: <1391730975.3449.16.camel@sonic.justonedata.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27127 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbaBGUot (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Feb 2014 15:44:49 -0500
In-Reply-To: <1391730975.3449.16.camel@sonic.justonedata.com> (Kurt Miller's
	message of "Thu, 06 Feb 2014 18:56:15 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kurt Miller <kurt@intricatesoftware.com>
Cc: linux-scsi@vger.kernel.org

>>>>> "Kurt" == Kurt Miller <kurt@intricatesoftware.com> writes:

Kurt> Is TRIM working for anyone using LSI SAS2008 controllers?

Yes. But its SAT appears to be somewhat selective about which devices it
flags as capable.

Please send me the output of:

# sg_readcap -l /dev/sdc
# sg_vpd -p bl /dev/sdc
# sg_vpd -p lbpv /dev/sdc

-- 
Martin K. Petersen	Oracle Linux Engineering
