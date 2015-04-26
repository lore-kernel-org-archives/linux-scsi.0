From: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH 19/23] advansys: Remove cmd_per_lun setting
Date: Sun, 26 Apr 2015 20:23:52 +0200
Message-ID: <201504262023.52590.linux@rainbow-software.org>
References: <1429874322-85488-1-git-send-email-hare@suse.de> <201504261657.01552.linux@rainbow-software.org> <20150426165541.GA14192@lst.de>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-1.atlantis.sk ([92.240.247.91]:57157 "EHLO
	smtp-1.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbbDZSYE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 26 Apr 2015 14:24:04 -0400
In-Reply-To: <20150426165541.GA14192@lst.de>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>, Doug Gilberg <dgilbert@interlog.com>, linux-scsi@vger.kernel.org

On Sunday 26 April 2015 18:55:41 Christoph Hellwig wrote:
> On Sun, Apr 26, 2015 at 04:57:01PM +0200, Ondrej Zary wrote:
> > This patch breaks my setup: "modprobe advansys" hangs.
> >
> > It works when all other patches are applied except this one.
>
> Oh damn, looks like the code does have issues in this case.
> So let's just drop this change for now.
>
>
> Jusr curious: do you have more than a single disk on this controller?

I was testing this with only one device attached: HP ScanJet IIp scanner.

-- 
Ondrej Zary
