From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: qedf: Use vsprintf extension %pad
Date: Mon, 06 Mar 2017 22:39:49 -0500
Message-ID: <yq1pohtkb5m.fsf@oracle.com>
References: <f6a0331e574df0ab1c9dad61571b92c17971ae99.1488825093.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <f6a0331e574df0ab1c9dad61571b92c17971ae99.1488825093.git.joe@perches.com>
        (Joe Perches's message of "Mon, 6 Mar 2017 10:32:27 -0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: QLogic-Storage-Upstream@cavium.com, kbuild test robot <lkp@intel.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Joe" == Joe Perches <joe@perches.com> writes:

Joe> Using %llx for a dma_addr_t can lead to format/argument mismatches.
Joe> Use %pad and the address of the dma_addr_t instead.

Applied to 4.11/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
