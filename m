From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] Update lsscsi to cope with upcoming SCSI sysfs rework
Date: Wed, 19 Mar 2008 16:19:09 -0400
Message-ID: <47E1753D.1080907@torque.net>
References: <47DFBD3E.8050502@suse.de>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:34480 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966348AbYCSWBI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Mar 2008 18:01:08 -0400
In-Reply-To: <47DFBD3E.8050502@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>

Hannes Reinecke wrote:
> Hi Doug,
> 
> I'm preparing a set of patches to update the SCSI midlayer to
> play more nicely with the ongoing driver core rework.
> Part of the patchset is to move every SCSI entity 
> (ie hosts, targets, and devices) into the scsi bus.
> So /sys/bus/scsi/devices will look like:
> 
> hare@yarrow:/tmp> ls /sys/bus/scsi/devices
> 2:0:4:0  host0  host1  host2  host3  host4  target2:0:4
> 
> Currently 'lsscsi' doesn't handle this properly; it needs
> a simple fix to handle it properly. And as this fix doesn't
> affect normal parsing we can as well apply it now :-)

Hannes,
I have placed a lssci-0.20beta.tgz tarball on
http://sg.torque.net/scsi/lsscsi.html
It includes your patch.

Doug Gilbert
