From: Patrick Mochel <mochel@osdl.org>
Subject: Re: [PATCH] /proc/scsi/map
Date: Tue, 25 Jun 2002 09:46:23 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.33.0206250940370.8496-100000@geena.pdx.osdl.net>
References: <1024769900.6875.139.camel@subjeKt>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <1024769900.6875.139.camel@subjeKt>
List-Id: linux-scsi@vger.kernel.org
To: Nick Bellinger <nickb@attheoffice.org>
Cc: David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org


> This reiterates the need for a sound logical device naming scheme that
> fits into driverfs without mucking up the basic structure.  Not being a
> expert on naming, the least offensive format I can think with regard to
> iSCSI would be something along the lines of:

The device model will not give devices default names. It will pass the 
responsibility to userspace, along with the path to the device via 
/sbin/hotplug. From the patch, the userspace agent can derive various 
things from the device's directory, including the device type and the UUID 
of the device. From this, userspace can look up what to name the device. 

	-pat

