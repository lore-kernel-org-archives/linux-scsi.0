From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 5/8] fusion - adding verbose messages for RAID actions
Date: Mon, 30 Jan 2006 13:22:12 -0600
Message-ID: <1138648932.3283.28.camel@mulgrave>
References: <F331B95B72AFFB4B87467BE1C8E9CF5F1AAC81@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:22954 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932368AbWA3TWP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Jan 2006 14:22:15 -0500
In-Reply-To: <F331B95B72AFFB4B87467BE1C8E9CF5F1AAC81@NAMAIL2.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>
Cc: linux-scsi@vger.kernel.org

On Mon, 2006-01-16 at 18:53 -0700, Moore, Eric wrote:
> A customer request to send raid asyn actions 
> from firmware to the event syslog.  This shows
> when raid volumes go degraded, or complete resync,
> or volumes created/deleted, etc.

I've put this in, but it really is quite verbose.  This is what my
single IM RAID gives on boot:

mptbase: ioc1: RAID STATUS CHANGE for VolumeID 0
mptbase: ioc1:   volume is now optimal, enabled, quiesced
mptbase: ioc1: RAID STATUS CHANGE for PhysDisk 0
mptbase: ioc1:   PhysDisk is now online, quiesced
mptbase: ioc1: RAID STATUS CHANGE for PhysDisk 1
mptbase: ioc1:   PhysDisk is now online, quiesced
mptbase: ioc1: RAID STATUS CHANGE for VolumeID 0
mptbase: ioc1:   volume is now optimal, enabled
mptbase: ioc1: RAID STATUS CHANGE for PhysDisk 0
mptbase: ioc1:   PhysDisk is now online
mptbase: ioc1: RAID STATUS CHANGE for PhysDisk 1
mptbase: ioc1:   PhysDisk is now online
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
mptbase: ioc1: RAID STATUS CHANGE for VolumeID 0
mptbase: ioc1:   volume is now optimal, enabled, quiesced
mptbase: ioc1: RAID STATUS CHANGE for PhysDisk 0
mptbase: ioc1:   PhysDisk is now online, quiesced
mptbase: ioc1: RAID STATUS CHANGE for PhysDisk 1
mptbase: ioc1:   PhysDisk is now online, quiesced
mptbase: ioc1: RAID STATUS CHANGE for VolumeID 0
mptbase: ioc1:   volume is now optimal, enabled
mptbase: ioc1: RAID STATUS CHANGE for PhysDisk 0
mptbase: ioc1:   PhysDisk is now online
mptbase: ioc1: RAID STATUS CHANGE for PhysDisk 1
mptbase: ioc1:   PhysDisk is now online

Which is rather a lot of spew for a single device ...

James


