From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] scsi: qla2xxx: Simplify conditional check again
Date: Wed, 27 Mar 2019 21:28:47 -0400
Message-ID: <yq1ftr7vlbk.fsf@oracle.com>
References: <20190320163315.12740-1-natechancellor@gmail.com>
        <20190326220444.10040-1-natechancellor@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190326220444.10040-1-natechancellor@gmail.com> (Nathan
        Chancellor's message of "Tue, 26 Mar 2019 15:04:46 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Nathan Chancellor <natechancellor@gmail.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Joe Carnuccio <joe.carnuccio@cavium.com>, Himanshu Madhani <hmadhani@marvell.com>, qla2xxx-upstream@qlogic.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>, clang-built-linux@googlegroups.com
List-Id: linux-scsi@vger.kernel.org


Nathan,

> Clang warns when it sees a logical not on the left side of a
> conditional statement because it thinks the logical not should be
> applied to the whole statement, not just the left side:

Applied to 5.2/scsi-queue, thanks.

-- 
Martin K. Petersen	Oracle Linux Engineering
