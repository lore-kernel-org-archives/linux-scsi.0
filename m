From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH v2.5 2/6] scsi_debug: rework resp_report_luns
Date: Tue, 3 May 2016 16:58:12 -0700
Message-ID: <57293B14.5060300@sandisk.com>
References: <1462070687-12689-1-git-send-email-dgilbert@interlog.com>
 <1462070687-12689-3-git-send-email-dgilbert@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0094.outbound.protection.outlook.com ([157.56.110.94]:16203
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756849AbcECX6T (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 May 2016 19:58:19 -0400
In-Reply-To: <1462070687-12689-3-git-send-email-dgilbert@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, tomas.winkler@intel.com, emilne@redhat.com

On 04/30/2016 07:44 PM, Douglas Gilbert wrote:
> Based on "[PATH V2] scsi_debug: rework resp_report_luns" patch
> sent by Tomas Winkler on Thursday, 26 Feb 2015. His notes:
>    1. Remove duplicated boundary checks which simplify the fill-in
>       loop
>    2. Use more of scsi generic API
> Replace fixed length response array a with heap allocation
> allowing up to 256 normal LUNs per target.
>
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
