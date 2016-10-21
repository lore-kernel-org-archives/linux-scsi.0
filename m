From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [PATCH v2 4/7] megaraid_sas: Send SYNCHRONIZE_CACHE command to
 firmware
Date: Fri, 21 Oct 2016 06:01:27 -0400
Message-ID: <1777e4f0-e324-e31a-91af-d0787217d973@redhat.com>
References: <1476954305-576-1-git-send-email-sumit.saxena@broadcom.com>
 <1476954305-576-5-git-send-email-sumit.saxena@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12583 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750884AbcJUKBb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 21 Oct 2016 06:01:31 -0400
In-Reply-To: <1476954305-576-5-git-send-email-sumit.saxena@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit Saxena <sumit.saxena@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, stable@vger.kernel.org

On 10/20/2016 05:05 AM, Sumit Saxena wrote:
>  From previous patch we have below changes in v2 -
> 1.  Updated change log.  Provided more detail in change log.
> 2.  Agreed to remove module parameter. If we remove module parameter, we
>      can ask customer to disable WCE on drive to get similar impact.
> 3.  Always Send SYNCHRONIZE_CACHE  for JBOD (non Raid) Device to Firmware.

Just a note - the user can disable sending the synchronize cache settings by 
mount time options with a file system (nobarrier) or for raw devices, overriding 
cache_type.

This should never be required unless the target device has some quirk that does 
not allow it to handle synchronize_cache correctly.

Regards,

Ric


