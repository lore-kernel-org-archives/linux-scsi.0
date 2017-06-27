From: "Javali, Nilesh" <Nilesh.Javali@cavium.com>
Subject: Re: [PATCH 1/1] qedi: Add support for offload iSCSI Boot
Date: Tue, 27 Jun 2017 10:08:52 +0000
Message-ID: <D5782BCE.57E03%nilesh.javali@cavium.com>
References: <20170619134429.17657-1-nilesh.javali@cavium.com>
 <20170619134429.17657-2-nilesh.javali@cavium.com>
 <yq1h8z27kix.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0078.outbound.protection.outlook.com ([104.47.33.78]:42912
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751632AbdF0KIy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Jun 2017 06:08:54 -0400
In-Reply-To: <yq1h8z27kix.fsf@oracle.com>
Content-Language: en-US
Content-ID: <208527A9ACC2C34A9B83371FBB11D1F9@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "lduncan@suse.com" <lduncan@suse.com>, "cleech@redhat.com" <cleech@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Dept-Eng QLogic Storage Upstream <QLogic-Storage-Upstream@cavium.com>



On 26/06/17, 10:29 PM, "Martin K. Petersen" <martin.petersen@oracle.com>
wrote:

>
>Nilesh,
>
>> This patch adds support for offload iSCSI boot (Boot from SAN
>> over iSCSI offload).
>>
>> The dependent qed patches for this support are,
>> - qed: Support NVM-image reading API
>> - qed: Share additional information with qedf
>
>You had tagged this for 4.12/scsi-fixes but the above patches are not
>present in 4.12. So I presume this would be a candidate for a second
>stage 4.13 merge?
Yes.

>
>Patch looks OK to me, but please resubmit with a slightly more verbose
>description of the changes and how they work.
Done. Resubmitted the patch.

Thanks,
Nilesh
