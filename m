From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [patch 3/3] Enable Aggressive Link Power management for AHCI controllers.
Date: Tue, 12 Jun 2007 09:18:19 -0300
Message-ID: <20070612121819.GA20408@khazad-dum.debian.net>
References: <20070611184146.448266229@intel.com> <20070611114839.907bcae2.kristen.c.accardi@intel.com> <20070612011148.GA9808@khazad-dum.debian.net> <466DF3E9.30303@linux.intel.com> <d8jr6oikkcz.fsf@nygaard.ping.uio.no> <466DFE09.3020408@garzik.org> <20070612035928.GB9808@khazad-dum.debian.net> <466E1A32.90306@linux.intel.com> <20070612090940.GA9719@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:42564 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754531AbXFLMSZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Jun 2007 08:18:25 -0400
Content-Disposition: inline
In-Reply-To: <20070612090940.GA9719@srcf.ucam.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>, Jeff Garzik <jeff@garzik.org>, Dagfinn Ilmari =?iso-8859-1?Q?Manns=E5ker?= <ilmari@ilmari.org>, Kristen Carlson Accardi <kristen.c.accardi@intel.com>, james.bottomley@steeleye.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, htejun@gmail.com

On Tue, 12 Jun 2007, Matthew Garrett wrote:
> On Mon, Jun 11, 2007 at 08:59:46PM -0700, Arjan van de Ven wrote:
> > that's a temporary shortcoming; even with these power savings you can 
> > do hotplug as long as you're willing to poll for it at a reasonable 
> > interval and are willing to wait the time between polls for a hotplug 
> > to take effect..
> 
> On laptops, I suspect that we'll probably get an ACPI interrupt even if 
> the AHCI hotplug pathway can't manage.

As long as we don't crash the drive or AHCI controller because we hotplugged
it in a way it didn't like (like trying to hotplug a ICH5R would cause).

It is not like 1Hz would not be fast enough for laptop bays and docks, so
the polling frequency would not be a problem.  I still prefer when levels
and on/off are kept separate, but if it won't stand in the way of hotplug, I
certainly don't care enough to bother.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
