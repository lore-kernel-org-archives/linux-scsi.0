From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 14/14] tcm_loop: Enable DIF/DIX modes in SCSI host LLD
Date: Mon, 13 Jan 2014 15:08:37 -0500
Message-ID: <yq1ha97oda2.fsf@sermon.lab.mkp.net>
References: <1389212157-14540-1-git-send-email-nab@daterainc.com>
	<1389212157-14540-15-git-send-email-nab@daterainc.com>
	<yq1wqi7pmrd.fsf@sermon.lab.mkp.net>
	<1389638711.5567.437.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1389638711.5567.437.camel@haakon3.risingtidesystems.com>
	(Nicholas A. Bellinger's message of "Mon, 13 Jan 2014 10:45:11 -0800")
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

>>>>> "nab" == Nicholas A Bellinger <nab@linux-iscsi.org> writes:

nab> Sure, this can be exposed at a tcm_loop configfs attribute that is
nab> accessible after scsi_add_host() has been called, which I assume is
nab> OK to do..

As long as it's set before we discover devices.

-- 
Martin K. Petersen	Oracle Linux Engineering
