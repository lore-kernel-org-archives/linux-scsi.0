From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [RFC][PATCH] fix for async scsi scan sysfs problem (resend)
Date: Sun, 12 Aug 2007 18:26:41 -0600
Message-ID: <20070813002641.GA16277@parisc-linux.org>
References: <20070419132459.GB1481@korben.rdu.redhat.com> <1176991356.31764.3.camel@mulgrave.il.steeleye.com> <20070419150655.GC1481@korben.rdu.redhat.com> <20070421002345.673d9988.akpm@linux-foundation.org> <20070421135956.GA22873@korben.rdu.redhat.com> <20070423181318.GD22873@korben.rdu.redhat.com> <1177352786.6284.51.camel@mulgrave.il.steeleye.com> <463A3F79.80809@emulex.com> <20070811150454.GA5808@droopy.oc.cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:43633 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759821AbXHMA0n (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Aug 2007 20:26:43 -0400
Content-Disposition: inline
In-Reply-To: <20070811150454.GA5808@droopy.oc.cox.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jurij Smakov <jurij@wooyd.org>
Cc: James Smart <James.Smart@Emulex.Com>, James Bottomley <James.Bottomley@SteelEye.com>, Josef Bacik <jwhiter@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Sat, Aug 11, 2007 at 04:04:54PM +0100, Jurij Smakov wrote:
> [Please keep me on CC, as I'm not on LKML.]
> I've recently got a Sun Blade 1000 box with a QLA2200 controller, and 
> I'm bumping into exact same problem with 2.6.22:

Please try
http://marc.info/?l=linux-scsi&m=118289275414202
which fixes a number of problems with the async scanning code.

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
