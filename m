From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi_transport_spi: Export host width and HBA id
Date: Wed, 01 Jun 2011 23:56:11 +0900
Message-ID: <1306940171.11897.52.camel@mulgrave.site>
References: <201106011318.p51DImMr003035@pentland.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:38835 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756844Ab1FAO4Q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jun 2011 10:56:16 -0400
In-Reply-To: <201106011318.p51DImMr003035@pentland.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@parallels.com>, linux-scsi@vger.kernel.org

On Wed, 2011-06-01 at 15:18 +0200, Hannes Reinecke wrote:
> Currently it's impossible to find out if the host supports
> wide SCSI unless you're committed to trawl through syslog.
> And it's near impossible to find the actual HBA id, which
> is settable for some SCSI HBAs (like aic7xxx).
> So export them via sysfs.

Um, that's what the the 

/sys/class/spi_transport/target<x:y:x>/max_width

parameter gives you, isn't it?

max_width tells you if the HBA/device combination supports wide; width
tells you if the device is using it.

James


