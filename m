From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/4] scsi: Allow hosts to be flagged as hotpluggable
Date: Thu, 16 Jul 2009 01:12:28 +0000
Message-ID: <1247706748.8632.3.camel@mulgrave.site>
References: <1247701438-18266-1-git-send-email-mjg@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:58625 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756909AbZGPBMe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Jul 2009 21:12:34 -0400
In-Reply-To: <1247701438-18266-1-git-send-email-mjg@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

On Thu, 2009-07-16 at 00:43 +0100, Matthew Garrett wrote:
> Userspace may wish to make policy decisions based on whether a host
> supports device hotplug or not - for example, AHCI link power management
> disables hotplug, so may only be desirable on hotplug ports. Add
> support for marking hosts as hotpluggable in order to allow userspace to
> treat them appropriately.

OK, so I don't really understand what the hotplug flag means.

You seem to be setting it unconditionally on most sata HBAs.  If it just
means "bus is hotpluggable", it should be set to 1 at initialisation and
the few non hot plug busses (like SPI) get to reset it.

However, by definition SATA (like SAS) is a hotplug bus ... why isn't it
set for some SATA controllers ... is it because the HBA itself does
something wrong when a hotplug event comes in?

James


