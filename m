From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: aicasm: fix kbuild for separated build directories
Date: Tue, 23 Feb 2016 20:54:20 -0500
Message-ID: <yq1a8mqkh4j.fsf@sermon.lab.mkp.net>
References: <1455316946.2396.65.camel@HansenPartnership.com>
	<20160217234604.GA16500@pobox.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51397 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469AbcBXByd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Feb 2016 20:54:33 -0500
In-Reply-To: <20160217234604.GA16500@pobox.suse.cz> (Michal Marek's message of
	"Thu, 18 Feb 2016 00:46:04 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michal Marek <mmarek@suse.cz>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>

>>>>> "Michal" == Michal Marek <mmarek@suse.cz> writes:

Michal> Sorry for the late reply. Letting kbuild handle the aicasm
Michal> directory is a step in the right direction. However, it still
Michal> failed for me and instead of trying to understand how the rules
Michal> work, I removed them and used the existing kbuild
Michal> infrastructure. Please try the patch below on top of yours.

James?

-- 
Martin K. Petersen	Oracle Linux Engineering
