From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] add sysfs attributes to scan and delete scsi_devices
Date: 08 Jul 2003 15:50:15 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1057697416.1825.10.camel@mulgrave>
References: <20030708134016.A32161@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:40196 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S265337AbTGHUfl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Jul 2003 16:35:41 -0400
In-Reply-To: <20030708134016.A32161@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2003-07-08 at 15:40, Patrick Mansfield wrote:
> This patch against recent 2.5 bk adds a sysfs attribute to allow scanning
> (or rescanning) and deletion of scsi_devices.
> 
> It also allows scanning of entire hosts, channels, or targets.

I'm not convinced we need a bus file for this.  What's the reason we
can't have a per host file instead?

I'm thinking of the hotplug case where you know the sysfs path to the
card just inserted.  Translating that to a hostid will be rather hard.

James


