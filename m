From: Olaf Hering <olh@suse.de>
Subject: Re: improve sg_luns output for iscsi
Date: Thu, 8 Mar 2007 09:53:03 +0100
Message-ID: <20070308085303.GA28924@suse.de>
References: <20070306180428.GA16826@suse.de> <2894.1173207056@bebe.enoyolf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:55608 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030313AbXCHIxR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Mar 2007 03:53:17 -0500
Content-Disposition: inline
In-Reply-To: <2894.1173207056@bebe.enoyolf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doug Maxey <dwm@enoyolf.org>
Cc: Douglas Gilbert <dougg@torque.net>, linux-scsi@vger.kernel.org

On Tue, Mar 06, Doug Maxey wrote:

> So to me, using 
> sg_luns |tail -1 
> should get the line with the singleton lun in it, albeit with some 
> amount of leading whitespace.

In the example above, if installing onto sdc, tail -n 1 would give the
lun value from sdd.

> Can you extract some value from the installer that will give you the 
> path to the target?

Its hopefully somewhere in sysfs, just where?

You can not expect that the bootfile was loaded from iscsi when installing
onto iscsi.
