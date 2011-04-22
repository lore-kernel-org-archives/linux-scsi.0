From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [Bug 33802] list_del corruption in sd driver since 2.6.39-rc4
Date: Fri, 22 Apr 2011 08:55:23 -0500
Message-ID: <1303480523.2590.5.camel@mulgrave.site>
References: <bug-33802-11613@https.bugzilla.kernel.org/>
	 <201104220925.p3M9Phuo024208@demeter2.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51343 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755372Ab1DVNz2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Apr 2011 09:55:28 -0400
In-Reply-To: <201104220925.p3M9Phuo024208@demeter2.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org

On Fri, 2011-04-22 at 09:25 +0000, from Stefan Richter
<stefanr@s5r6.in-berlin.de>  2011-04-22 09:25:42 ---
> PS,
> in my case the bug happened not during boot but during power-up of a monitor
> with built-in USB card reader.  Such a power-up happened circa 10 times in that
> 2.6.39-rc3 session --- plus a few other plug-in events of USB and FireWire
> disks --- without the bug hitting.

The taxonomy also looks like it may be related to this

http://marc.info/?t=130253369300004

The fix we'll be pushing shortly to git head is

http://marc.info/?l=linux-kernel&m=130271409412095

James


