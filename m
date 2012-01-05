From: Lin Ming <ming.m.lin@intel.com>
Subject: Re: [PATCH v3 0/3] fixes for ata port runtime pm support
Date: Thu, 5 Jan 2012 09:50:11 +0800
Message-ID: <CAF1ivSZx5pkZPQcL-X4=QA9rqvCoyW8kzg1_Q1ANsCwk-D=D=Q@mail.gmail.com>
References: <1324536649-5796-1-git-send-email-ming.m.lin@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:59608 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab2AEBuM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Jan 2012 20:50:12 -0500
In-Reply-To: <1324536649-5796-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <JBottomley@parallels.com>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org

On Thu, Dec 22, 2011 at 2:50 PM, Lin Ming <ming.m.lin@intel.com> wrote:
> Hi Jeff,
>
> Here are the v3 fixes for ata port runtime pm support.
>
> Could you consider applying these fixes?

Hi Jeff,

Hope you have a good holiday.

How about these fixes?

Lin Ming

> Thanks.
>
> Changes in v3:
> - Add ata port hibernate callbacks
>
> Changes in v2:
> - Drop the patch "[SCSI] sd: fix runtime status check in sd_shutdown"=
=2E
> =A0It's no longer needed with commit fe6b91f(PM / Driver core: leave
> =A0runtime PM enabled during system shutdown).
> - Add Ack from Alan
>
> v1: https://lkml.org/lkml/2011/12/13/443
> v2: https://lkml.org/lkml/2011/12/14/516
>
> Lin Ming (3):
> =A0 =A0 =A0[SCSI]: runtime resume parent for child's system-resume
> =A0 =A0 =A0ata: update ata port's runtime status during system resume
> =A0 =A0 =A0ata: add ata port hibernate callbacks
>
> =A0drivers/ata/libata-core.c | =A0 58 +++++++++++++++++++++++++++++++=
+++++++++----
> =A0drivers/scsi/scsi_pm.c =A0 =A0| =A0 11 +++++++-
> =A02 files changed, 62 insertions(+), 7 deletions(-)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" i=
n
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
