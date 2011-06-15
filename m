From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 1/3] [RFC] genhd: add a new attribute in device structure
Date: Wed, 15 Jun 2011 08:33:37 -0700
Message-ID: <20110615153337.GA10160@kroah.com>
References: <20110615081610.2237.44767.stgit@ltc233.sdl.hitachi.co.jp>
 <20110615081627.2237.9620.stgit@ltc233.sdl.hitachi.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:40144 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755191Ab1FOPkQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Jun 2011 11:40:16 -0400
Content-Disposition: inline
In-Reply-To: <20110615081627.2237.9620.stgit@ltc233.sdl.hitachi.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nao Nishijima <nao.nishijima.xt@hitachi.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, James.Bottomley@HansenPartnership.com, kay.sievers@vrfy.org, jcm@redhat.com, hare@suse.de, stefanr@s5r6.in-berlin.de, yrl.pp-manager.tt@hitachi.com

On Wed, Jun 15, 2011 at 05:16:28PM +0900, Nao Nishijima wrote:
> Allow users to set the preferred name of device via sysfs interface.
> 
> (Exsample) sda -> foo
> # echo foo > /sys/block/sda/preferred_name
> 
> Suggested-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> Suggested-by: Jon Masters <jcm@redhat.com>
> Signed-off-by: Nao Nishijima <nao.nishijima.xt@hitachi.com>

You don't document this new sysfs file (which is required), nor do you
explain what it is for and how to use it.

Please do that in this patch, and in a Documentation/ABI/ file for any
new sysfs file you create.

I still fail to understand how a "preferred" file will help anyone out
here at all...

greg k-h
