From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: pmcraid: Convert timers to use timer_setup()
Date: Tue, 31 Oct 2017 11:47:19 -0400
Message-ID: <yq1h8ufb9q0.fsf@oracle.com>
References: <20171025100729.GA145083@beast>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33023 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752330AbdJaPrZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Oct 2017 11:47:25 -0400
In-Reply-To: <20171025100729.GA145083@beast> (Kees Cook's message of "Wed, 25
        Oct 2017 03:07:29 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org


Kees,

> In preparation for unconditionally passing the struct timer_list pointer to
> all timer callbacks, switch to using the new timer_setup() and from_timer()
> to pass the timer pointer explicitly.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
