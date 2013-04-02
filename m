From: Ewan Milne <emilne@redhat.com>
Subject: RE: [PATCH] scsi_dh_alua: Add module parameter to allow failover
 to non preferred path without STPG
Date: Tue, 02 Apr 2013 08:38:16 -0400
Message-ID: <1364906296.2647.0.camel@localhost.localdomain>
References: <8255ED565A0EAA4A960625E27D49DBF21FF906FB@SACEXCMBX04-PRD.hq.netapp.com>
	 <1364826280.3828.120.camel@localhost.localdomain>
	 <8255ED565A0EAA4A960625E27D49DBF21FF95717@SACEXCMBX04-PRD.hq.netapp.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6524 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759812Ab3DBMjA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Apr 2013 08:39:00 -0400
In-Reply-To: <8255ED565A0EAA4A960625E27D49DBF21FF95717@SACEXCMBX04-PRD.hq.netapp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Stewart, Sean" <Sean.Stewart@netapp.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "James.Bottomley@suse.de" <James.Bottomley@suse.de>, "snitzer@redhat.com" <snitzer@redhat.com>, "hare@suse.de" <hare@suse.de>

On Mon, 2013-04-01 at 21:18 +0000, Stewart, Sean wrote:
> How about the following?  Reworded in a way such that 0 means no and 1 means yes.
> 
> +static uint optimize_stpg;
> +module_param(optimize_stpg, uint, S_IRUGO|S_IWUSR); 
> +MODULE_PARM_DESC(optimize_stpg, "Allow use of a non-optimized path, rather than sending a STPG, when implicit TPGS is supported (0=No,1=Yes). Default is 0.");

Great, thank you.

-Ewan D. Milne <emilne@redhat.com>


