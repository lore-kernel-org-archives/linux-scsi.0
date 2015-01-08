From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/2] target: Don't arbitrary limit I/O size to fabric_max_sectors
Date: Thu, 08 Jan 2015 09:37:34 -0500
Message-ID: <yq1zj9t2v9t.fsf@sermon.lab.mkp.net>
References: <1420590258-21122-1-git-send-email-nab@daterainc.com>
	<1420647107.12144.8.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1420647107.12144.8.camel@haakon3.risingtidesystems.com>
	(Nicholas A. Bellinger's message of "Wed, 07 Jan 2015 08:11:47 -0800")
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Roland Dreier <roland@purestorage.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

>>>>> "nab" == Nicholas A Bellinger <nab@linux-iscsi.org> writes:

nab> IIRC, most modern hardware is reporting a large enough value for
nab> queue_max_hw_sectors() to support 8 MB I/Os, but I'm thinking that
nab> this could end up being problematic for older hardware that is
nab> reporting much smaller values.

Reporting queue_max_hw_sectors sounds sane to me.

What's your concern wrt. older hardware?

-- 
Martin K. Petersen	Oracle Linux Engineering
