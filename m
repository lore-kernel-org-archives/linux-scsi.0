From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi_dh_alua: Add module parameter to allow failover
 to non preferred path without STPG
Date: Sun, 31 Mar 2013 18:24:22 +0200
Message-ID: <51586336.9080802@suse.de>
References: <8255ED565A0EAA4A960625E27D49DBF21FF906FB@SACEXCMBX04-PRD.hq.netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37965 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755534Ab3CaPY3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 31 Mar 2013 11:24:29 -0400
In-Reply-To: <8255ED565A0EAA4A960625E27D49DBF21FF906FB@SACEXCMBX04-PRD.hq.netapp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Stewart, Sean" <Sean.Stewart@netapp.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "James.Bottomley@suse.de" <James.Bottomley@suse.de>, "snitzer@redhat.com" <snitzer@redhat.com>

On 03/28/2013 11:07 PM, Stewart, Sean wrote:
> Currently ALUA device handler sends STPG command during failover and failback.
> Failover can be optimized by implicit failover (by not to sending STPG command),
> when 1 is passed as hwhandler parameter in multipath.conf. ex "2 alua 1". We may
> need to pass the parameter through module param for alua device handler to optimize
> failover if incase retain_attached_hwhandler set in multipath.conf and hwhandler
> is set with non-tpgs device handler ex: '1 rdac'.
>
> Signed-off-by: Vijay Chauhan <vijay.chauhan@netapp.com>
> Signed-off-by: Sean Stewart <Sean.Stewart@netapp.com>
>
Acked-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
