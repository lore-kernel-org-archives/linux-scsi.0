From: Rob Evers <revers@redhat.com>
Subject: Re: [PATCH V5 0/3] scsi: Configure number of LUs reported by 'report-luns'
Date: Mon, 08 Dec 2014 08:04:13 -0500
Message-ID: <5485A1CD.80804@redhat.com>
References: <1417808263-5632-1-git-send-email-revers@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41472 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752358AbaLHNEP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Dec 2014 08:04:15 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id sB8D4DT0007822
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-scsi@vger.kernel.org>; Mon, 8 Dec 2014 08:04:14 -0500
Received: from revers-dell.usersys.redhat.com ([10.18.25.106])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id sB8D4DvX012838
	for <linux-scsi@vger.kernel.org>; Mon, 8 Dec 2014 08:04:13 -0500
In-Reply-To: <1417808263-5632-1-git-send-email-revers@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On 12/05/2014 02:37 PM, Rob Evers wrote:
> This patch set retrieves the number of LUs available on a target
> using the report-luns command by re-sizing the returned data
> buffer and retrying report luns.
>
> A minor bug fix is included.
>
> scsi_mod parameter max_report_luns is no longer used and is removed.
>
> Changes from previous posting:
>
>   - simplify implementation by removing max_report_luns parameter and
>     removing 2nd kmalloc failure handling
>
>   - remove patch to fix return value on first kmalloc failing
>
>   - drop do_scsi_report_luns encapsulation as it isn't required
>     with new implementation
>
> Rob Evers (3):
>    scsi: Avoid unnecessary GFP_ATOMIC allocation in scsi_report_lun_scan
>    scsi: Use set/get_unaligned_be32 in report_luns
>    scsi: Retry report-luns when reported LU count requres more memory
>
>   drivers/scsi/scsi_scan.c | 54 ++++++++++++++----------------------------------
>   1 file changed, 15 insertions(+), 39 deletions(-)
>

Patch set Signed-off-by: Rob Evers <revers@redhat.com>
