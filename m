From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: Re: [PATCH 0/5] bnx2fc version 1.0.14
Date: Thu, 18 Apr 2013 14:47:15 -0700
Message-ID: <517069E3.8010100@broadcom.com>
References: <1362778134-21045-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2156 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936478Ab3DRVri (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Apr 2013 17:47:38 -0400
In-Reply-To: <1362778134-21045-1-git-send-email-bprakash@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
Cc: JBottomley@Parallels.com, linux-scsi@vger.kernel.org

On 03/08/2013 01:28 PM, Bhanu Prakash Gollapudi wrote:
> Hi James,
>
> Please consider including the following patches for 3.9+ merge window.
>
> Thanks,
> Bhanu
>
> Bhanu Prakash Gollapudi (5):
>    bnx2fc: Enable cached tasks to improve performance
>    bnx2fc: Include chip number in the symbolic name
>    bnx2fc: Fix race condition between IO completion and abort
>    bnx2fc: Update copyright information
>    bnx2fc: Bumped version to 1.0.14
>
>   drivers/scsi/bnx2fc/bnx2fc.h      |   57 +++++++++++++++++++++++++++++++++++-
>   drivers/scsi/bnx2fc/bnx2fc_els.c  |    2 +-
>   drivers/scsi/bnx2fc/bnx2fc_fcoe.c |   55 ++++++++++++++++++++++++++++++-----
>   drivers/scsi/bnx2fc/bnx2fc_hwi.c  |    8 ++++-
>   drivers/scsi/bnx2fc/bnx2fc_io.c   |    9 ++++--
>   drivers/scsi/bnx2fc/bnx2fc_tgt.c  |    2 +-
>   6 files changed, 116 insertions(+), 17 deletions(-)
>

Hi James,

I see that these patches were not picked up by you yet.  Please let me 
know if you're waiting for any information.

thanks,
Bhanu


