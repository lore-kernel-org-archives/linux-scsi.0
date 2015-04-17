From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v4 02/43] hpsa: clean up host, channel, target, lun prints
Date: Fri, 17 Apr 2015 15:15:41 +0200
Message-ID: <5531077D.7030705@redhat.com>
References: <20150416134224.30238.66082.stgit@brunhilda> <20150416134650.30238.61648.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36228 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932117AbbDQNQH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Apr 2015 09:16:07 -0400
In-Reply-To: <20150416134650.30238.61648.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.combrace@pmcs.com
Cc: linux-scsi@vger.kernel.org

On 04/16/2015 03:46 PM, Don Brace wrote:
> From: Webb Scales <webbnh@hp.com>
>
> We had a mix of formats used for specifying controller, bus, target,
> and lun address of devices.
>
> change to the format used by the scsi midlayer and upper layer (2:3:0:0)
> so you can easily follow the information from hpsa to scsi midlayer
> to sd upper layer.
>
> Also add this information:
> - product ID
> - vendor ID
> - RAID level
> - SSD Smath Path capable and enabled
> - exposure level (sg-only)
>
> Example:
> hpsa 0000:04:00.0: added scsi 2:0:0:0: Direct-Access     HP LOGICAL VOLUME   RAID-0 SSDSmartPathCap+ En+ Exp=4
> scsi 2:0:0:0: Direct-Access     HP       LOGICAL VOLUME   10.0 PQ: 0 ANSI: 5
> sd 2:0:0:0: [sdr] 12501713072 512-byte logical blocks: (6.40 TB/5.82 TiB)
> sd 2:0:0:0: [sdr] 4096-byte physical blocks
> sd 2:0:0:0: [sdr] Attached SCSI disk
> sd 2:0:0:0: Attached scsi generic sg20 type 0
>
> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
> Signed-off-by: Robert Elliott <elliott@hp.com>
> Signed-off-by: Don Brace <don.brace@pmcs.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas

