From: Patrick Mochel <mochel@osdl.org>
Subject: Re: driverfs is not for everything! (was: [PATCH] /proc/scsi/map )
Date: Tue, 25 Jun 2002 11:38:53 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.33.0206251136570.8496-100000@geena.pdx.osdl.net>
References: <200206241809.g5OI9Ds02886@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <200206241809.g5OI9Ds02886@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: "Grover, Andrew" <andrew.grover@intel.com>, 'David Brownell' <david-b@pacbell.net>, 'Nick Bellinger' <nickb@attheoffice.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org


> I think the qualification for appearing in driverfs is actually possessing a 
> driver.  Therefore, we accept FC and iSCSI.  Things which appear as 
> FileSystems are debatable, but not anything which has a real device driver.

The qualification for appearing in the device tree is the physical 
presence of the device, regardless of the presence of a driver to control 
it. (This typically depends on the presence of the bus driver so it can 
discover the device.) Presence in the device tree implies presence in 
driverfs.

	-pat

