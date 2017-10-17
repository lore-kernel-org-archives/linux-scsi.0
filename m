From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: smartpqi: Convert timers to use timer_setup()
Date: Tue, 17 Oct 2017 00:09:10 -0400
Message-ID: <yq1mv4qxvo9.fsf@oracle.com>
References: <20171016235437.GA102564@beast>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171016235437.GA102564@beast> (Kees Cook's message of "Mon, 16
        Oct 2017 16:54:37 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Don Brace <don.brace@microsemi.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Kees,

> In preparation for unconditionally passing the struct timer_list
> pointer to all timer callbacks, switch to using the new timer_setup()
> and from_timer() to pass the timer pointer explicitly.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
