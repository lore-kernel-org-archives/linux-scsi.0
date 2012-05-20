From: Jonathan Nieder <jrnieder@gmail.com>
Subject: [3.0.y, 3.2.y, 3.3.y] Re: [PATCH 05/10] hpsa: Fix problem with
 MSA2xxx devices
Date: Sun, 20 May 2012 04:47:35 -0500
Message-ID: <20120520094735.GA14683@burratino>
References: <20120119200042.17835.93058.stgit@beardog.cce.hp.com>
 <20120119200104.17835.29536.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51755 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009Ab2ETJrn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 20 May 2012 05:47:43 -0400
Content-Disposition: inline
In-Reply-To: <20120119200104.17835.29536.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: stable@vger.kernel.org
Cc: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>, Steven Williamson <steven.williamson@dialogue.net>, james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, mikem@beardog.cce.hp.com, stephenmcameron@gmail.com, thenzl@redhat.com, scott.teel@hp.com, akpm@linux-foundation.org

Hi Greg and Ben,

Please consider

  9bc3711cbb67 [SCSI] hpsa: Fix problem with MSA2xxx devices

for application to next week's 3.0.y, 3.2.y, and 3.3.y trees.

As Steven Williamson noticed[1], without this patch:

> The hpsa driver fails to correctly assign devices when there are
> multiple paths on at least the Smart Array 712m with the latest
> firmware.
>
> The end result is only one device node is created in /dev and multipath
> tools then only detect one path.

He tested this patch + fda38518f236 "[SCSI] hpsa: add P2000 to list of
shared SAS devices" (which is already in v3.0) on top of a
2.6.32.y-based kernel and found:

> Applying the patch here:
> http://www.spinics.net/lists/linux-scsi/msg56690.html
> to the current stable version of the squeeze kernel fixes the issue.
>
> This was tested on a Smart Array 712m, connected via 2 SAS switches to a
> HP P2000 G3 SAS Array.

Stephen, are any other patches from the series at [2] or elsewhere
candidates for inclusion in stable trees?

Thanks and hope that helps,
Jonathan

[1] http://bugs.debian.org/661057
[2] http://thread.gmane.org/gmane.linux.kernel/1241509
