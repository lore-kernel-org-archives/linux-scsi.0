From: Oliver Neukum <oliver@neukum.name>
Subject: Re: [PATCH] SCSI hotplug support
Date: Tue, 15 Oct 2002 09:53:29 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200210150953.29905.oliver@neukum.name>
References: <200210142107.g9EL7IX04354@localhost.localdomain> <200210150019.53689.oliver@neukum.name> <20021015002252.GE1274@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021015002252.GE1274@redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, andersen@codepoet.org, linux-scsi@vger.kernel.org


> > It's harder than doing it the simple way. User space really can do
> > nothing but do the call.
>
> Not true, see my last email.  User space can do a *lot* more than just
> make the call to add the device, and as a matter of fact it already does.

But surely it can do more if it can be called with knowledge of a device node,
can't it? Nobody argues against doing a hotplug call. But divorcing
recognisition on the bus and attaching a driver to it seems to be bad
to me. After all there's nothing you can do with a SCSI device without device
node.
Plus you keep a difference between the coldplugging and the hotplugging case,
which is not nice.

> > Plus, you can use such a kernel API to really free the device's
> > memory, because you cannot know when user space, or indeed if, has
> > freed the device.
>
> Not true at all.  Define a revoke/slave_detach entry point to your driver
> and you get called when the device is removed so that you can free up any
> of your resources.

I see.

	Regards
		Oliver

