From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] qla2xxx: Fix ql_dump_buffer
Date: Mon, 06 Mar 2017 22:24:53 -0500
Message-ID: <yq137eplqey.fsf@oracle.com>
References: <404b1c3a4bfd1f83211482b77b4a9680e755e32a.1488503664.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <404b1c3a4bfd1f83211482b77b4a9680e755e32a.1488503664.git.joe@perches.com>
        (Joe Perches's message of "Thu, 2 Mar 2017 17:14:47 -0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: qla2xxx-upstream@qlogic.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Joe" == Joe Perches <joe@perches.com> writes:

Joe> Recent printk changes for KERN_CONT cause this logging to be
Joe> defectively emitted on multiple lines.  Fix it.

Applied to 4.11/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
