From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] vmw_pvscsi: return SUCCESS for successful command aborts
Date: Tue, 01 Nov 2016 09:54:36 -0400
Message-ID: <yq1y4131f1f.fsf@sermon.lab.mkp.net>
References: <DM2PR0501MB1536D5BFF3BBE109199083C6CBAE0@DM2PR0501MB1536.namprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18735 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932756AbcKANyo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Nov 2016 09:54:44 -0400
In-Reply-To: <DM2PR0501MB1536D5BFF3BBE109199083C6CBAE0@DM2PR0501MB1536.namprd05.prod.outlook.com>
        (Jim Gill's message of "Mon, 31 Oct 2016 22:04:16 +0000")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jim Gill <jgill@vmware.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "emilne@redhat.com" <emilne@redhat.com>, "djeffery@redhat.com" <djeffery@redhat.com>, pv-drivers <pv-drivers@vmware.com>

>>>>> "Jim" == Jim Gill <jgill@vmware.com> writes:

Jim> VMware prefers to update the module's version number as the driver
Jim> is updated. Would you please update the
Jim> PVSCSI_DRIVER_VERSION_STRING in vmx_pvscsi.h from 1.0.6.0-k to
Jim> 1.0.7.0-k?  Otherwise the patch looks fine to us.

Applied to 4.9/scsi-fixes with a bumped version number.

-- 
Martin K. Petersen	Oracle Linux Engineering
