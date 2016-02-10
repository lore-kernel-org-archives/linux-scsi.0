From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/2] scsi: Fix endless loop of ATA hard resets due to VPD reads
Date: Tue, 09 Feb 2016 21:09:12 -0500
Message-ID: <yq1pow5b9kn.fsf@sermon.lab.mkp.net>
References: <20160202101830.GA3786@node.shutemov.name>
	<1454684063-19116-1-git-send-email-todd.fujinaka@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34669 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932293AbcBJCJS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Feb 2016 21:09:18 -0500
In-Reply-To: <1454684063-19116-1-git-send-email-todd.fujinaka@intel.com> (Todd
	Fujinaka's message of "Fri, 5 Feb 2016 06:54:23 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Todd Fujinaka <todd.fujinaka@intel.com>
Cc: kirill.shutemov@linux.intel.com, linux-scsi@vger.kernel.org

>>>>> "Todd" == Todd Fujinaka <todd.fujinaka@intel.com> writes:

Todd,

Todd> I've tried to read the code but I'm not sure where the strings are
Todd> getting parsed. I'm afraid I'm only familiar with the Ethernet
Todd> drivers. In any case, the patch didn't help and I had to add this
Todd> second Marvell line. I'm not sure if you can just wildcard the
Todd> second and third fields or not.

I tweaked your patch to match all revisions.

Applied to 4.5/scsi-fixes.

Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
