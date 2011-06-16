From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/3] [RFC] genhd: add a new attribute in device
 structure
Date: Thu, 16 Jun 2011 18:48:17 -0400
Message-ID: <1308264497.2436.163.camel@mulgrave>
References: <20110615081610.2237.44767.stgit@ltc233.sdl.hitachi.co.jp>
	 <20110615081627.2237.9620.stgit@ltc233.sdl.hitachi.co.jp>
	 <20110615153337.GA10160@kroah.com> <4DF9F11F.705@hitachi.com>
	 <20110616154129.GA31498@kroah.com> <1308239454.2436.34.camel@mulgrave>
	 <4DFA3E1A.9050207@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:41809 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753510Ab1FPWsV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Jun 2011 18:48:21 -0400
In-Reply-To: <4DFA3E1A.9050207@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: Greg KH <greg@kroah.com>, Nao Nishijima <nao.nishijima.xt@hitachi.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kay.sievers@vrfy.org, jcm@redhat.com, hare@suse.de, stefanr@s5r6.in-berlin.de, yrl.pp-manager.tt@hitachi.com

On Thu, 2011-06-16 at 13:32 -0400, Douglas Gilbert wrote:
> As James' notes each storage device can only have one
> "preferred name" at a time. But how can that preferred name
> be represented in sysfs ? If /sys/block/<kernel_name>
> suddenly changed to /sys/block/<preferred_name> that would
> be very disruptive. I would prefer something like
> /sys/class/block_preferred_name/<preferred_name> was introduced
> as a symlink to /sys/block/<kernel_name> but that would require
> that all <preferred_name>s were unique. [Not a bad restriction
> IMO]. If the <preferred_name> was only placed in the
> /sys/block/<kernel_name> directory that would be ugly from
> the user space tool point of view.

Right, so the only proposal for sysfs is the addition of the
preferred_name file to devices, nothing more.  The entire sysfs tree
structure would be left intact.  This is what gets us out of the
problems that a real rename causes.

James


