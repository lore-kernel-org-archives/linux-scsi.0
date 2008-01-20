From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [SCSI] scsi.h: add macro for enclosure bit of inquiry data
Date: Sun, 20 Jan 2008 18:44:15 +0100
Message-ID: <4793886F.2070707@s5r6.in-berlin.de>
References: <1200841780.3105.1.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:54736 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753578AbYATRoT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 20 Jan 2008 12:44:19 -0500
In-Reply-To: <1200841780.3105.1.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> The macro tells us whether the device is (or contains) an enclosure device.
...
> +static inline int scsi_device_enclosure(struct scsi_device *sdev)
> +{
> +	return sdev->inquiry[6] & (1<<6);
> +}

Perhaps call it scsi_device_is_enclosure() to better reflect the nature
of this function.

Or if it is an accessor to inquiry data to you, maybe call it
scsi_device_inquiry_encserv() or
scsi_device_inquiry_enclosure_services() or
sdev_to_inquiry_encserv() or
sdev_to_inquiry_enclosure_services().

Alas neither of this fits with the existing similar functions in
scsi_device.h which don't have expressive names.
-- 
Stefan Richter
-=====-==--- ---= =-=--
http://arcgraph.de/sr/
