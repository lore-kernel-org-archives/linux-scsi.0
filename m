From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] SCSI hotplug support
Date: Mon, 14 Oct 2002 14:07:18 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200210142107.g9EL7IX04354@localhost.localdomain>
References: <andersen@codepoet.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id OAA21988
	for <linux-scsi@vger.kernel.org>; Mon, 14 Oct 2002 14:07:21 -0700
In-Reply-To: Message from Erik Andersen <andersen@codepoet.org>
   of "Mon, 14 Oct 2002 14:37:49 MDT." <20021014203749.GA24904@codepoet.org>
List-Id: linux-scsi@vger.kernel.org
To: andersen@codepoet.org
Cc: linux-scsi@vger.kernel.org

andersen@codepoet.org said:
> If the user space interface were perfectly adequate, I would not have
> written this patch.  User space does not have sufficient information
> to know _which_ devices must to be added or removed. The best we can
> do from user space is a full rescan of _all_ scsi host adaptors (http:/
> /www.garloff.de/kurt/linux/rescan-scsi-bus.sh)  using something like

The API you expose has identical inputs to the user space one.

Therefore it seems to me that your spb2 driver must already know the values to 
fill in to use the API.  So what's wrong with triggering a hotplug event from 
this driver that causes the add/remove single device to be done from user 
level?

James


