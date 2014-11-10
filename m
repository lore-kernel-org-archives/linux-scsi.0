From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: UNMAP command parameter list
Date: Mon, 10 Nov 2014 12:52:35 -0500
Message-ID: <yq1r3xb54f0.fsf@sermon.lab.mkp.net>
References: <loom.20141108T001847-741@post.gmane.org>
	<94D0CD8314A33A4D9D801C0FE68B40295937B4CE@G4W3202.americas.hpqcorp.net>
	<loom.20141108T211736-836@post.gmane.org>
	<loom.20141110T164410-58@post.gmane.org>
	<yq17fz36m4o.fsf@sermon.lab.mkp.net>
	<20141110174043.GA26944@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43160 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284AbaKJRxH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Nov 2014 12:53:07 -0500
In-Reply-To: <20141110174043.GA26944@infradead.org> (Christoph Hellwig's
	message of "Mon, 10 Nov 2014 09:40:43 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Andras Kovacs <akovacs@fixstars.com>, linux-scsi@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@infradead.org> writes:

Christoph> Note that if the hardware doesn't actually implement UNMAP
Christoph> and you have to emulate something you're probably better off
Christoph> emulating WRITE SAME (16) with the UNMAP bit, as the format
Christoph> is a lot easier to handle, and it's much better specified to
Christoph> start with.

Yup, absolutely!

-- 
Martin K. Petersen	Oracle Linux Engineering
