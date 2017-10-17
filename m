From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: libiscsi: Convert timers to use timer_setup()
Date: Tue, 17 Oct 2017 00:08:56 -0400
Message-ID: <yq1r2u2xvon.fsf@oracle.com>
References: <20171016235424.GA102550@beast>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171016235424.GA102550@beast> (Kees Cook's message of "Mon, 16
        Oct 2017 16:54:24 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Kees,

> In preparation for unconditionally passing the struct timer_list
> pointer to all timer callbacks, switch to using the new timer_setup()
> and from_timer() to pass the timer pointer explicitly.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
