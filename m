From: Santosh Y <santoshsy@gmail.com>
Subject: Re: [PATCH 0/8] scsi: ufs: query support and other fixes
Date: Wed, 12 Jun 2013 11:09:14 +0530
Message-ID: <CALMYJDvLUNW1hY6JFbahM-BhRv-8ROkthJT7w=t2J1kQBr1eEg@mail.gmail.com>
References: <1368951703-2672-1-git-send-email-santoshsy@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f52.google.com ([209.85.214.52]:44453 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765Ab3FLFjg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Jun 2013 01:39:36 -0400
Received: by mail-bk0-f52.google.com with SMTP id d7so3941137bkh.11
        for <linux-scsi@vger.kernel.org>; Tue, 11 Jun 2013 22:39:34 -0700 (PDT)
In-Reply-To: <1368951703-2672-1-git-send-email-santoshsy@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, vinholikatti@gmail.com, Santosh Y <santoshsy@gmail.com>

On Sun, May 19, 2013 at 1:51 PM, Santosh Y <santoshsy@gmail.com> wrote:
> Hi James,
>
> Please merge the following patches to 'misc' branch.
>
> Thanks,
> Santosh
>
> Dolev Raviv (3):
>   scsi: ufs: add support for query requests
>   scsi: ufs: Add support for sending NOP OUT UPIU
>   scsi: ufs: Set fDeviceInit flag to initiate device initialization
>
> Seungwon Jeon (4):
>   scsi: ufs: wrap the i/o access operations
>   scsi: ufs: amend interrupt configuration
>   scsi: ufs: remove version check before IS reg clear
>   scsi: ufs: rework link start-up process
>
> Sujit Reddy Thumma (1):
>   scsi: ufs: Fix the response UPIU length setting
>
>  drivers/scsi/ufs/ufs.h    |  132 ++++-
>  drivers/scsi/ufs/ufshcd.c | 1172 +++++++++++++++++++++++++++++++++++----------
>  drivers/scsi/ufs/ufshcd.h |   47 +-
>  drivers/scsi/ufs/ufshci.h |    7 +-
>  4 files changed, 1085 insertions(+), 273 deletions(-)
>
> --
> 1.8.2.3
>

Hi James,

Please ignore this patch set, will send the new patchset with updates soon.

-- 
~Santosh
