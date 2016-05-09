From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHv3 00/14] libata: ZAC support
Date: Mon, 9 May 2016 12:38:22 -0400
Message-ID: <20160509163822.GH7110@mtj.duckdns.org>
References: <1461581156-92581-1-git-send-email-hare@suse.de>
 <20160425201627.GI7822@mtj.duckdns.org>
 <572C7A80.4000903@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f171.google.com ([209.85.161.171]:33955 "EHLO
	mail-yw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbcEIQiY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 May 2016 12:38:24 -0400
Content-Disposition: inline
In-Reply-To: <572C7A80.4000903@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-ide@vger.kernel.org, Shaun Tancheff <shaun.tancheff@seagate.com>, Damien Le Moal <damien.lemoal@hgst.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

On Fri, May 06, 2016 at 01:05:36PM +0200, Hannes Reinecke wrote:
> On 04/25/2016 10:16 PM, Tejun Heo wrote:
> > Hello,
> > 
> > On Mon, Apr 25, 2016 at 12:45:42PM +0200, Hannes Reinecke wrote:
> >> here's a patchset implementing ZAC support for libata.
> >>
> >> This is the second part of a larger patchset for ZAC/ZBC support;
> >> it requires the scsi trace fixes queued for in mkp/4.7/scsi-queue and
> >> the patchset 'libata: SATL update' queued in tj/for-4.7-zac.
> > 
> > The patches look good from libata side.  If others are okay with it, I
> > can pull mkp/4.7/scsi-queue into tj/for-4.7-zac and apply this series
> > on top of it.
> > 
> Ping?
> 
> I can easily split off the libsas bits into a different patchset if
> this turns out to be an issue.
> But it would be really good if this could make it 4.7, it will help
> further integration a _lot_.

Pulled in mkp/4.7/scsi-queue into libata/for-4.7-zac and applied the
patches on top.

Thanks.

-- 
tejun
