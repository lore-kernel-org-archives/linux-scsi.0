From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: qedf: Avoid reading past end of buffer
Date: Mon, 08 May 2017 22:08:44 -0400
Message-ID: <yq1a86msrwz.fsf@oracle.com>
References: <20170505224255.GA21521@beast>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170505224255.GA21521@beast> (Kees Cook's message of "Fri, 5
        May 2017 15:42:55 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: linux-scsi@vger.kernel.org, QLogic-Storage-Upstream@cavium.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-kernel@vger.kernel.org, Daniel Micay <danielmicay@gmail.com>
List-Id: linux-scsi@vger.kernel.org


Kees,

> Using memcpy() from a string that is shorter than the length copied
> means the destination buffer is being filled with arbitrary data from
> the kernel rodata segment. Instead, use strncpy() which will fill the
> trailing bytes with zeros.

Applied to 4.12/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
