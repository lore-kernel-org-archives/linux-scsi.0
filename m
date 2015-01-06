From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: T10-PI: Getting failed tag info
Date: Tue, 06 Jan 2015 18:49:50 -0500
Message-ID: <yq1fvbn8o69.fsf@sermon.lab.mkp.net>
References: <54892468.5060300@vlnb.net> <yq1r3w5blys.fsf@sermon.lab.mkp.net>
	<20141215081857.GA24067@infradead.org>
	<yq1zjao8lsc.fsf@sermon.lab.mkp.net>
	<20141230121542.GF32187@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50328 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687AbbAFXuZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jan 2015 18:50:25 -0500
In-Reply-To: <20141230121542.GF32187@infradead.org> (Christoph Hellwig's
	message of "Tue, 30 Dec 2014 04:15:42 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Vladislav Bolkhovitin <vst@vlnb.net>, linux-scsi@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@infradead.org> writes:

Christoph> But those extensions require new structures to pass in the PI
Christoph> info anyway..

Yep. But I still don't see why that warrants having a parallel error
passing infrastructure in the kernel to handle data integrity
errors. What does that buy us?

I agree with not leaking any of the new errors to unsuspecting
applications and only passing them out if the caller has explicitly
enabled DIX.

-- 
Martin K. Petersen	Oracle Linux Engineering
