From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] scsi: esas2r: Fix format string type mistakes
Date: Mon, 09 Jan 2017 23:52:52 -0500
Message-ID: <yq1a8azcy8r.fsf@oracle.com>
References: <20170104000140.GA120826@beast>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170104000140.GA120826@beast> (Kees Cook's message of "Tue, 3
        Jan 2017 16:01:40 -0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Bart Van Assche <bart.vanassche@gmail.com>, Bradley Grove <linuxdrivers@attotech.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Emese Revfy <re.emese@gmail.com>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Kees" == Kees Cook <keescook@chromium.org> writes:

Kees> From: Emese Revfy <re.emese@gmail.com> This adds the missing
Kees> __printf attribute which allows compile time format string
Kees> checking (and will be used by the coming initify gcc
Kees> plugin). Additionally, this fixes the warnings exposed by the
Kees> attribute.

Applied to 4.11/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
