From: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Subject: Re: [PATCH] scsi: ibmvscsi: Convert timers to use timer_setup()
Date: Tue, 31 Oct 2017 14:46:40 -0700
Message-ID: <8db42ced-307e-15f1-817a-5c4e76c5df58@linux.vnet.ibm.com>
References: <20171025100607.GA145026@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:54932 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753962AbdJaVqs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 31 Oct 2017 17:46:48 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v9VLhgpM185605
        for <linux-scsi@vger.kernel.org>; Tue, 31 Oct 2017 17:46:47 -0400
Received: from e18.ny.us.ibm.com (e18.ny.us.ibm.com [129.33.205.208])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2dxxk7rdmy-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 31 Oct 2017 17:46:47 -0400
Received: from localhost
        by e18.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <tyreld@linux.vnet.ibm.com>;
        Tue, 31 Oct 2017 17:46:47 -0400
In-Reply-To: <20171025100607.GA145026@beast>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kees Cook <keescook@chromium.org>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org

On 10/25/2017 03:06 AM, Kees Cook wrote:
> In preparation for unconditionally passing the struct timer_list pointer to
> all timer callbacks, switch to using the new timer_setup() and from_timer()
> to pass the timer pointer explicitly.
> 
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> Cc: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
> Cc: linux-scsi@vger.kernel.org
> Cc: linuxppc-dev@lists.ozlabs.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  drivers/scsi/ibmvscsi/ibmvfc.c   | 14 ++++++--------
>  drivers/scsi/ibmvscsi/ibmvscsi.c |  7 +++----
>  2 files changed, 9 insertions(+), 12 deletions(-)

Acked-by: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
