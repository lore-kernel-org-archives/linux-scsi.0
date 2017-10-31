From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: fcoe: Convert timers to use timer_setup()
Date: Tue, 31 Oct 2017 11:36:58 -0400
Message-ID: <yq1375zcorp.fsf@oracle.com>
References: <20171025100557.GA145012@beast>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171025100557.GA145012@beast> (Kees Cook's message of "Wed, 25
        Oct 2017 03:05:57 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, QLogic-Storage-Upstream@qlogic.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Johannes Thumshirn <jth@kernel.org>, linux-scsi@vger.kernel.org, fcoe-devel@open-fcoe.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Kees,

> In preparation for unconditionally passing the struct timer_list
> pointer to all timer callbacks, switch to using the new timer_setup()
> and from_timer() to pass the timer pointer explicitly.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
