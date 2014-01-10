From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 08/14] target/spc: Expose ATO bit in control mode page
Date: Fri, 10 Jan 2014 15:57:05 -0500
Message-ID: <yq1a9f3r1we.fsf@sermon.lab.mkp.net>
References: <1389212157-14540-1-git-send-email-nab@daterainc.com>
	<1389212157-14540-9-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1389212157-14540-9-git-send-email-nab@daterainc.com> (Nicholas
	A. Bellinger's message of "Wed, 8 Jan 2014 20:15:51 +0000")
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

>>>>> "nab" == Nicholas A Bellinger <nab@daterainc.com> writes:

nab> This patch updates spc_modesense_control() to set the Application
nab> Tag Owner (ATO) bit when when DIF emulation is enabled by the
nab> backend device.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
