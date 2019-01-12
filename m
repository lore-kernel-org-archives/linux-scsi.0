From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 36/41] scsi: qla4xxx: ql4_os: mark expected switch fall-through
Date: Fri, 11 Jan 2019 21:05:56 -0500
Message-ID: <yq1tviey6ij.fsf@oracle.com>
References: <cover.1543374820.git.gustavo@embeddedor.com>
        <a118ae0eeeb3cdcd4846bc1031ea89ca62af1e00.1543374820.git.gustavo@embeddedor.com>
        <D8469DE5.5427A%njavali@marvell.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <D8469DE5.5427A%njavali@marvell.com> (Nilesh Javali's message of
        "Mon, 24 Dec 2018 09:01:26 +0000")
Sender: linux-kernel-owner@vger.kernel.org
To: Nilesh Javali <njavali@marvell.com>
Cc: "Gustavo A. R. Silva" <gustavo@embeddedor.com>, Dept-Eng QLogic Storage Upstream <QLogic-Storage-Upstream@cavium.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


Nilesh,

>>In preparation to enabling -Wimplicit-fallthrough, mark switch cases
>>where we are expecting to fall through.
>>
>>Notice that, in this particular case, I replaced "allow fall-through"
>>with a "fall through" annotation, which is what GCC is expecting to
>>find.

Applied to 5.1/scsi-queue. Thanks, Gustavo.

-- 
Martin K. Petersen	Oracle Linux Engineering
