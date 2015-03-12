From: Julian Calaby <julian.calaby@gmail.com>
Subject: Re: [PATCH v2 1/9] snic: snic module infrastructure
Date: Thu, 12 Mar 2015 11:54:35 +1100
Message-ID: <CAGRGNgWQ2TndGCgpkBrGveKPDpnExMdZc86ysE_2CLgiTMSUeQ@mail.gmail.com>
References: <1426093299-4511-1-git-send-email-nmusini@cisco.com> <1426093299-4511-2-git-send-email-nmusini@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:45495 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585AbbCLAy6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Mar 2015 20:54:58 -0400
Received: by wibbs8 with SMTP id bs8so16250537wib.4
        for <linux-scsi@vger.kernel.org>; Wed, 11 Mar 2015 17:54:57 -0700 (PDT)
In-Reply-To: <1426093299-4511-2-git-send-email-nmusini@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Narsimhulu Musini <nmusini@cisco.com>
Cc: James Bottomley <JBottomley@parallels.com>, linux-scsi <linux-scsi@vger.kernel.org>, hare@suse.de, Sesidhar Baddela <sebaddel@cisco.com>

Hi,

On Thu, Mar 12, 2015 at 4:01 AM, Narsimhulu Musini <nmusini@cisco.com> wrote:
> snic_main.c contains module load and unload, global driver context,
> PCI Registration, PCI probe and remove, SCSI ML registration functionality.
>
> snic.h contains snic structure definition, snic global context, and
> prototypes.
>
> snic_os.h contains OS specific interfaces.
>
> snic_attrs.c contains device attributes to list snic state, link state,
> and driver version under /sys/class/scsi_host/host<id>/
>
> v2
> Added Compile time macro for debugfs dependent functionality.

Your changelog should be below the "---" and before the diffstat.

> Signed-off-by: Narsimhulu Musini <nmusini@cisco.com>
> Signed-off-by: Sesidhar Baddela <sebaddel@cisco.com>
> ---

I.e. here.

>  drivers/scsi/snic/snic.h       |  421 +++++++++++++++++
>  drivers/scsi/snic/snic_attrs.c |   80 ++++
>  drivers/scsi/snic/snic_main.c  | 1022 ++++++++++++++++++++++++++++++++++++++++
>  drivers/scsi/snic/snic_os.h    |   81 ++++
>  4 files changed, 1604 insertions(+)
>  create mode 100644 drivers/scsi/snic/snic.h
>  create mode 100644 drivers/scsi/snic/snic_attrs.c
>  create mode 100644 drivers/scsi/snic/snic_main.c
>  create mode 100644 drivers/scsi/snic/snic_os.h

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
