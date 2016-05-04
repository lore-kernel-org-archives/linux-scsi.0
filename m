From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH v2.5 5/6] scsi_debug: uuid for lu name
Date: Wed, 4 May 2016 15:37:03 -0700
Message-ID: <572A798F.8090707@sandisk.com>
References: <1462070687-12689-1-git-send-email-dgilbert@interlog.com>
 <1462070687-12689-6-git-send-email-dgilbert@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0061.outbound.protection.outlook.com ([157.56.110.61]:53248
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753409AbcEDWhK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 May 2016 18:37:10 -0400
In-Reply-To: <1462070687-12689-6-git-send-email-dgilbert@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, tomas.winkler@intel.com, emilne@redhat.com, bart.vanassche@sandisk.com

On 04/30/2016 07:44 PM, Douglas Gilbert wrote:
> Permit changing of a LU name from a (fake) IEEE registered NAA (5)
> to a locally assigned UUID. Using a UUID (RFC 4122) for a SCSI
> designation descriptor (e.g. a LU name) was added in spc5r08.pdf
> (a draft INCITS standard) on 25 January 2016. Add parameter
> uuid_ctl to use a separate UUID for each LU (storage device) name.
> Additional option for all LU names to have the same UUID (since
> their storage is shared). Previous action of using NAA identifier
> for LU name remains the default.
>
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
