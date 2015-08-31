From: Sony John <sony.john@avagotech.com>
Subject: Re: [PATCH 0/2] be2iscsi driver update to 10.6.0.1
Date: Mon, 31 Aug 2015 12:26:38 +0530
Message-ID: <CAJRCtXfLXjdStrWZeHkSdc8SeEbtjFDhHYr9gdApVxTVWZv8=Q@mail.gmail.com>
References: <1440026071-27748-1-git-send-email-sony.john@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:36528 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934AbbHaG4j (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Aug 2015 02:56:39 -0400
Received: by igboj15 with SMTP id oj15so18570700igb.1
        for <linux-scsi@vger.kernel.org>; Sun, 30 Aug 2015 23:56:39 -0700 (PDT)
In-Reply-To: <1440026071-27748-1-git-send-email-sony.john@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>, Mike Christie <michaelc@cs.wisc.edu>
Cc: John Soni Jose <sony.john@avagotech.com>, Ketan Mukadam <ketan.mukadam@avagotech.com>

Hi Mike

Any review updates for this patchset.

Thanks

On Thu, Aug 20, 2015 at 4:44 AM, John Soni Jose <sony.john@avagotech.com> wrote:
> This patch is generated against the for-next branch.
>
> John Soni Jose (1):
>   be2iscsi: Bump the driver version
>
> John Soni Jose (1):
>   be2iscsi: Fix updating the next pointer during WRB posting
>
>  drivers/scsi/be2iscsi/be_main.c |   62 +++++++++++++++++++++++++++++---------
>  drivers/scsi/be2iscsi/be_main.h |    7 ++--
>  drivers/scsi/be2iscsi/be_mgmt.c |   24 ++++++++++++--
>  drivers/scsi/be2iscsi/be_mgmt.h |    7 +++-
>  4 files changed, 76 insertions(+), 24 deletions(-)
>
