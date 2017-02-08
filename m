From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v2 08/39] megaraid_sas: megasas_get_request_descriptor
 always return valid desc
Date: Wed, 8 Feb 2017 15:40:39 +0100
Message-ID: <37b07746-6961-17fa-704f-6aecb5a66ce5@redhat.com>
References: <1486546173-20713-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1486546173-20713-9-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40756 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752823AbdBHPXz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 8 Feb 2017 10:23:55 -0500
In-Reply-To: <1486546173-20713-9-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com

On 8.2.2017 10:29, Shivasharan S wrote:
> fix in v2 - split patches into two. 
> discussed below 
> http://marc.info/?l=linux-scsi&m=148638999110404&w=2
>
> No functional change. Code clean up. Removing error code which is not
> valid scenario.
> In megasas_get_request_descriptor we can remove the error handling
> which is not required.
> With fusion controllers, if there is a valid message frame available,
> we are guaranteed to get a corresponding request descriptor.
>
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas
