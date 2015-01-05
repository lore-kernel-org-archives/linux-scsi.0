From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH V6 0/3] scsi: Configure number of LUs reported by
 'report-luns'
Date: Mon, 05 Jan 2015 09:59:52 -0500
Message-ID: <1420469992.3891.94.camel@localhost.localdomain>
References: <1418745680-18126-1-git-send-email-revers@redhat.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45380 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753202AbbAEO7x (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 Jan 2015 09:59:53 -0500
Received: from int-mx13.intmail.prod.int.phx2.redhat.com (int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t05Exr82020779
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-scsi@vger.kernel.org>; Mon, 5 Jan 2015 09:59:53 -0500
In-Reply-To: <1418745680-18126-1-git-send-email-revers@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rob Evers <revers@redhat.com>
Cc: linux-scsi@vger.kernel.org

On Tue, 2014-12-16 at 11:01 -0500, Rob Evers wrote:
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
>  - remove exteraneous else
> 
>  - remove INITIAL_MAX_REPORT_LUNS, hardwire buffer sizing, and touch up
>    related comment
> 
> Rob Evers (3):
>   scsi: Avoid unnecessary GFP_ATOMIC allocation in scsi_report_lun_scan
>   scsi: Use set/get_unaligned_be32 in report_luns
>   scsi: retry report-luns when reported LU count requres more memory
> 
>  drivers/scsi/scsi_scan.c | 54 ++++++++++++++----------------------------------
>  1 file changed, 15 insertions(+), 39 deletions(-)
> 

Looks good.

Reviewed-by: Ewan D. Milne <emilne@redhat.com>


