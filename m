From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH V6 07/10] aacraid: Created new mutex for ioctl path
Date: Thu, 4 Feb 2016 13:29:17 +0100
Message-ID: <56B3441D.8020003@redhat.com>
References: <1454540768-12271-1-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
 <1454540768-12271-8-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49692 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751333AbcBDM3W (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Feb 2016 07:29:22 -0500
In-Reply-To: <1454540768-12271-8-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@pmcs.com>, James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: Mahesh.Rajashekhara@pmcs.com, Murthy.Bhat@pmcs.com, Gana.Sridaran@pmcs.com, aacraid@pmc-sierra.com, Scott.Benesh@pmcs.com, jthumshirn@suse.de, shane.seymour@hpe.com

On 4.2.2016 00:06, Raghava Aditya Renukunta wrote:
> aac_mutex was used to create protect the ioctl path for only the
> compat path, it would be make more sense to place mutex in
> aac_do_ioctl, which is the main ioctl function call that handles
> all ioctl commands.
>
> Created new mutex ioctl_mutex in struct aac_dev to protect switch
> case in aac_do_ioctl and removed aac_mutex from aac_cfg_ioctl and
> aac_compat_do_ioctl
>
> Changes in V1:
> Unlock ioctl_mutex incase of error
> Fix compilation error with aac->adapter_shutdown
>
> Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@pmcs.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas

