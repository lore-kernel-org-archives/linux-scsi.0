From: Patrick Mochel <mochel@osdl.org>
Subject: Re: [RFC] Multi-path IO in 2.5/2.6 ?
Date: Tue, 10 Sep 2002 10:21:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0209101019280.1032-100000@cherise.pdx.osdl.net>
References: <20020909170847.A24352@eng2.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <20020909170847.A24352@eng2.beaverton.ibm.com>
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Lars Marowsky-Bree <lmb@suse.de>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


> > > Generic device naming consistency is a problem if multiple devices
> > > show up with the same id.
> > 
> > Patrick Mochel has an open task to come up with a solution to this.
> 
> I don't think this can be solved if multiple devices show up with the same
> id. If I have five disks that all say I'm disk X, how can there be one
> name or handle for it from user level?

Easy: you map the unique identifier of the device to a name in userspace.  
In our utopian future, /sbin/hotplug is called with that unique ID as one
of its parameters. It searches for, and finds names based on the ID is. If
the name(s) already exist, then it doesn't continue.


	-pat
