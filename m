From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH] scsi_dh_alua: Add module parameter to allow failover
 to non preferred path without STPG
Date: Mon, 01 Apr 2013 10:24:40 -0400
Message-ID: <1364826280.3828.120.camel@localhost.localdomain>
References: <8255ED565A0EAA4A960625E27D49DBF21FF906FB@SACEXCMBX04-PRD.hq.netapp.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54213 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757397Ab3DAOZZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Apr 2013 10:25:25 -0400
In-Reply-To: <8255ED565A0EAA4A960625E27D49DBF21FF906FB@SACEXCMBX04-PRD.hq.netapp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Stewart, Sean" <Sean.Stewart@netapp.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "James.Bottomley@suse.de" <James.Bottomley@suse.de>, "snitzer@redhat.com" <snitzer@redhat.com>, "hare@suse.de" <hare@suse.de>

On Thu, 2013-03-28 at 22:07 +0000, Stewart, Sean wrote:
> +static uint optimize_stpg;
> +module_param(optimize_stpg, uint, S_IRUGO|S_IWUSR);
> +MODULE_PARM_DESC(optimize_stpg, "Send STPG command for Failover on non-preferred path(0=Yes,1=No). Default is 0.");

Could you possibly reword the description?  When I first read this, it
seemed backwards to have 0=Yes and 1=No.

-Ewan D. Milne <emilne@redhat.com>



