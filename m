From: "Grover, Andrew" <andrew.grover@intel.com>
Subject: RE: driverfs is not for everything! (was: [PATCH] /proc/scsi/map
	)
Date: Mon, 24 Jun 2002 11:37:04 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <59885C5E3098D511AD690002A5072D3C02AB7F55@orsmsx111.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <James.Bottomley@steeleye.com>, "Grover, Andrew" <andrew.grover@intel.com>
Cc: 'David Brownell' <david-b@pacbell.net>, 'Nick Bellinger' <nickb@attheoffice.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Patrick Mochel <mochel@osdl.org>

> From: James Bottomley [mailto:James.Bottomley@steeleye.com] 
> andrew.grover@intel.com said:
> > If a device can be accessed by multiple machines concurrently, it
> > should not be in driverfs. 
> 
> On that argument, we'll eliminate almost all Fibre Channel devices!
> 
> I think the qualification for appearing in driverfs is 
> actually possessing a 
> driver.  Therefore, we accept FC and iSCSI.  Things which appear as 
> FileSystems are debatable, but not anything which has a real 
> device driver.

OK that makes sense.

Regards -- Andy
