From: Oliver Neukum <oliver@neukum.name>
Subject: Re: [PATCH] SCSI hotplug support
Date: Tue, 15 Oct 2002 00:19:53 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200210150019.53689.oliver@neukum.name>
References: <200210142107.g9EL7IX04354@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <200210142107.g9EL7IX04354@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, andersen@codepoet.org
Cc: linux-scsi@vger.kernel.org

Am Montag, 14. Oktober 2002 23:07 schrieb James Bottomley:
> andersen@codepoet.org said:
> > If the user space interface were perfectly adequate, I would not have
> > written this patch.  User space does not have sufficient information
> > to know _which_ devices must to be added or removed. The best we can
> > do from user space is a full rescan of _all_ scsi host adaptors (http:/
> > /www.garloff.de/kurt/linux/rescan-scsi-bus.sh)  using something like
>
> The API you expose has identical inputs to the user space one.
>
> Therefore it seems to me that your spb2 driver must already know the values
> to fill in to use the API.  So what's wrong with triggering a hotplug event
> from this driver that causes the add/remove single device to be done from
> user level?

It's harder than doing it the simple way. User space really can do nothing but
do the call. Plus, you can use such a kernel API to really free the device's
memory, because you cannot know when user space, or indeed if, has
freed the device.
Doing it in kernel is the only sane thing.

	Regards
		Oliver

