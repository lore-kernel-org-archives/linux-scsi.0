From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 07/14] target/sbc: Add P_TYPE + PROT_EN bits to READ_CAPACITY_16
Date: Fri, 10 Jan 2014 15:39:21 -0500
Message-ID: <yq1mwj3r2py.fsf@sermon.lab.mkp.net>
References: <1389212157-14540-1-git-send-email-nab@daterainc.com>
	<1389212157-14540-8-git-send-email-nab@daterainc.com>
	<52CE78EB.60108@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <52CE78EB.60108@mellanox.com> (Sagi Grimberg's message of "Thu, 9
	Jan 2014 12:24:43 +0200")
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Or Gerlitz <ogerlitz@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Sagi" == Sagi Grimberg <sagig@mellanox.com> writes:

Sagi> What about FORMAT_UNIT emulation?  The backstore protection
Sagi> configuration is done at the target side via configfs/targetcli,

I don't know of any non-disk devices that actually implement FORMAT
UNIT. Usually such configuration is done using the array management
interface.

-- 
Martin K. Petersen	Oracle Linux Engineering
