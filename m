From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] xen/scsifront: use offset_in_page() macro
Date: Mon, 24 Apr 2017 18:15:02 -0400
Message-ID: <yq17f29ihax.fsf@oracle.com>
References: <4dbc77ccaaed98b183cf4dba58a4fa325fd65048.1492758503.git.geliangtang@gmail.com>
        <b066ac954374a00bca91fadf3f2d5aba0eb8cb0a.1492758340.git.geliangtang@gmail.com>
        <ca4bb9e8-b614-a24d-e533-70ce75ff288f@suse.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49822 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S978725AbdDXWPO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Apr 2017 18:15:14 -0400
In-Reply-To: <ca4bb9e8-b614-a24d-e533-70ce75ff288f@suse.com> (Juergen Gross's
        message of "Mon, 24 Apr 2017 07:05:16 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Juergen Gross <jgross@suse.com>
Cc: Geliang Tang <geliangtang@gmail.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, xen-devel@lists.xenproject.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org


Juergen,

> On 22/04/17 03:21, Geliang Tang wrote:
>> Use offset_in_page() macro instead of open-coding.
>> 
>> Signed-off-by: Geliang Tang <geliangtang@gmail.com>
>
> Reviewed-by: Juergen Gross <jgross@suse.com>

Taking this through the Xen tree or should I queue it?

-- 
Martin K. Petersen	Oracle Linux Engineering
