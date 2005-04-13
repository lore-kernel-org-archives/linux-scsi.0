From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: RE: [PATCH] mptscsih: MODULE_PARM() -> module_param()
Date: Wed, 13 Apr 2005 10:02:43 -0600
Message-ID: <91888D455306F94EBD4D168954A9457C01F7C108@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:46566 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261382AbVDMQDG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Apr 2005 12:03:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Magnus Damm <damm@opensource.se>, SCSI Mailing List <linux-scsi@vger.kernel.org>, mpt_linux_developer@lsil.com

This request makes very good sense.  
I'm working on this, and hopefully resubmit everthing
very soon.

Regards,
Eric Moore

On Tuesday, April 12, 2005 10:38 AM, James Bottomley wrote:
> 
> On Tue, 2005-04-05 at 14:30 -0600, Moore, Eric Dean wrote:
> > Ok fine - This fix is already there in the series of patches
> > I provided a week ago for splitting the mpt fusion drivers
> > into seperate bus type drivers.
> > 
> > James any word on whether those series of patches will get
> > approved?
> 
> The patches themselves look fine.  However, there's a problem which I
> just discovered on putting it together and taking it for a test spin:
> the MODULE_DEVICE_TABLE directive is still in mptbase.  This 
> means that
> the udev/hotplug system thinks that when it's loaded mptbase
> everything's done, which now means that everyone loses their devices
> since the upper drivers aren't loaded.  To make this all work and keep
> the distros happy, the MODULE_DEVICE_TABLE has to be split out and
> placed into the mptspi or mptfc components.
> 
> James
> 
> 
