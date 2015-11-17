From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCHv4 1/1] SCSI: hosts: update to use ida_simple for host_no management
Date: Tue, 17 Nov 2015 18:20:00 -0500
Message-ID: <yq1d1v8tdr3.fsf@sermon.lab.mkp.net>
References: <cover.1444241058.git.lduncan@suse.com>
	<f89fe3933ae899dc01f2eddd2a0cefac3383cf3c.1444241058.git.lduncan@suse.com>
	<1444830904.2220.28.camel@HansenPartnership.com>
	<561EA018.7020700@suse.com>
	<1444848835.2220.50.camel@HansenPartnership.com>
	<5644BEE1.3010208@suse.com> <yq1ziyhy38c.fsf@sermon.lab.mkp.net>
	<5649C79E.9070603@suse.de> <564A4EDC.8060805@suse.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47412 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbbKQXVP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Nov 2015 18:21:15 -0500
In-Reply-To: <564A4EDC.8060805@suse.com> (Lee Duncan's message of "Mon, 16 Nov
	2015 13:47:08 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lee Duncan <lduncan@suse.com>
Cc: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, Christoph Hellwig <hch@infradead.org>, Ewan Milne <emilne@redhat.com>

>>>>> "Lee" == Lee Duncan <lduncan@suse.com> writes:

Lee> Martin: I will be glad to update the patch, creating a modprobe
Lee> parameter as suggested, if you find this acceptable.

For development use a module parameter would be fine. But I am concerned
about our support folks that rely on the incrementing host number when
analyzing customer log files.

Ewan: How do you folks feel about this change?

-- 
Martin K. Petersen	Oracle Linux Engineering
