From: Greg KH <greg@kroah.com>
Subject: Re: [RFC PATCH 0/4] Persistent device name using alias name
Date: Fri, 8 Jul 2011 07:54:08 -0700
Message-ID: <20110708145408.GA2283@kroah.com>
References: <20110708084547.2091.55262.stgit@ltc197.sdl.hitachi.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:34141 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752129Ab1GHO5m (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jul 2011 10:57:42 -0400
Content-Disposition: inline
In-Reply-To: <20110708084547.2091.55262.stgit@ltc197.sdl.hitachi.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nao Nishijima <nao.nishijima.xt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, kay.sievers@vrfy.org, jcm@redhat.com, dle-develop@lists.sourceforge.net, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, yrl.pp-manager.tt@hitachi.com, dgilbert@interlog.com, stefanr@s5r6.in-berlin.de, hare@suse.de

On Fri, Jul 08, 2011 at 05:45:47PM +0900, Nao Nishijima wrote:
> Hi,
> 
> This patch series provides an "alias name" of the disk into kernel and procfs
> messages. The user can assign a preferred name to an alias name of the device.
> 
> Based on previous discussion (*), I changed patches as follows
> - This is "alias name"
> - An "alias name" is stored in gendisk struct
> - Add document to Documentation/ABI/testing/sysfs-block
> - When the user changes an "alias name", kernel notifies udev
> 
> (*) http://marc.info/?l=linux-scsi&m=130812625531219&w=2

I don't like it and I don't think it will really solve the root problem
you are trying to address, but as the patches don't touch any code I
maintain, there's not much I can do to object to it.

greg k-h
