From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] hpsa: use designated initializers
Date: Tue, 20 Dec 2016 17:41:20 -0500
Message-ID: <yq1lgva2pgv.fsf@sermon.lab.mkp.net>
References: <20161217010449.GA140636@beast>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161217010449.GA140636@beast> (Kees Cook's message of "Fri, 16
        Dec 2016 17:04:49 -0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Don Brace <don.brace@microsemi.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Kees" == Kees Cook <keescook@chromium.org> writes:

Kees> Prepare to mark sensitive kernel structures for randomization by
Kees> making sure they're using designated initializers. These were
Kees> identified during allyesconfig builds of x86, arm, and arm64, with
Kees> most initializer fixes extracted from grsecurity.

Applied to 4.11/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
