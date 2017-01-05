From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: qedi: return via va_end to match corresponding va_start
Date: Thu, 05 Jan 2017 00:32:04 -0500
Message-ID: <yq1d1g2kr6z.fsf@oracle.com>
References: <20161216141043.22324-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161216141043.22324-1-colin.king@canonical.com> (Colin King's
        message of "Fri, 16 Dec 2016 14:10:43 +0000")
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: QLogic-Storage-Upstream@cavium.com, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Colin" == Colin King <colin.king@canonical.com> writes:

Colin> Although on most systems va_end is a no-op, it is good practice
Colin> to use va_end on the function return path, especially since the
Colin> va_start documenation states:

Colin>   "Each invocation of va_start() must be matched by a
Colin>   corresponding
Colin>    invocation of va_end() in the same function."

Applied to 4.11/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
