From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] scsi_debug: support scsi-mq, queues and locks
Date: Tue, 15 Jul 2014 13:48:44 -0400
Message-ID: <yq11ttmv7gj.fsf@sermon.lab.mkp.net>
References: <53BAA104.6090207@interlog.com>
	<94D0CD8314A33A4D9D801C0FE68B402958BA045E@G9W0745.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32329 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595AbaGORsu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Jul 2014 13:48:50 -0400
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402958BA045E@G9W0745.americas.hpqcorp.net>
	(Robert Elliott's message of "Sun, 13 Jul 2014 22:55:19 +0000")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: "dgilbert@interlog.com" <dgilbert@interlog.com>, SCSI development list <linux-scsi@vger.kernel.org>

>>>>> "Rob" == Elliott, Robert (Server Storage) <Elliott@hp.com> writes:

Rob,

Rob> When resp_unmap is the caller, though, there is no guarantee that
Rob> the data will change.

Rob> Maybe another modparam should be included to cause the driver to
Rob> purposely ignore unmap requests?  That might help more people
Rob> realize the danger in these commands.

I don't really have a problem with an additional option.

I also think it's important to emphasize that the purpose of the LBP
support in scsi_debug is to test the block and SCSI layer code. The same
is true for the T10 PI support. I see scsi_debug as being a simple test
vehicle rather than a comprehensive and realistic SCSI target. We have
the target subsystem for that.

-- 
Martin K. Petersen	Oracle Linux Engineering
