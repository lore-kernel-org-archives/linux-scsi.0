From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 3/4] target: Return descriptor format sense data in case the LU spans 64bit sectors
Date: Thu, 16 Jul 2015 21:53:21 -0400
Message-ID: <yq1twt3mtwu.fsf@sermon.lab.mkp.net>
References: <1437031685-22403-1-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1437031685-22403-1-git-send-email-sagig@mellanox.com> (Sagi
	Grimberg's message of "Thu, 16 Jul 2015 10:28:05 +0300")
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Sagi" == Sagi Grimberg <sagig@mellanox.com> writes:

Sagi> In case a LU spans 64bit sectors, fixed size sense data
Sagi> information field is only 32 bits which means the sector
Sagi> information will be truncated.

Sagi> Thus, if the LU spans 64bit sectors, use descriptor format sense
Sagi> data to correctly report sector information.

A-OK.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
