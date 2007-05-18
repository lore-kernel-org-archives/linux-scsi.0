From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Asynchronous scsi scanning
Date: Fri, 18 May 2007 16:00:26 +0200
Message-ID: <464DB17A.4050004@s5r6.in-berlin.de>
References: <a781481a0705171013j7ddc48edxfb4bdba515a3f53c@mail.gmail.com> <20070517172023.GL10562@parisc-linux.org> <a781481a0705171041y3c3b7fe1m2aa6a8805807942c@mail.gmail.com> <20070517182414.GA12170@infradead.org> <a781481a0705171147s1ef5c205y8873d0bfa201f928@mail.gmail.com> <20070517185115.GA13207@infradead.org> <a781481a0705171204o5b25fafdm36d5970acf9119cd@mail.gmail.com> <20070517193953.GM10562@parisc-linux.org> <20070517194326.GC30571@kvack.org> <20070517213043.GN10562@parisc-linux.org> <20070517214234.GA398@redhat.com> <464CD092.6050300@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:39790 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754522AbXEROA1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 May 2007 10:00:27 -0400
In-Reply-To: <464CD092.6050300@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Peter Jones <pjones@redhat.com>
Cc: Dave Jones <davej@redhat.com>, Matthew Wilcox <matthew@wil.cx>, Benjamin LaHaise <bcrl@kvack.org>, James Bottomley <james.bottomley@steeleye.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, kernel-packagers@vger.kernel.org

Peter Jones wrote:
> So really, either way means we need to update the tools.  It also 
> doesn't really solve the problem -- when I insert "usb-storage", the 
> SCSI scan may still finish while we're still enumerating the bus for USB 
> devices. (I'd be willing to believe I'm wrong about this specific 
> example, but I suspect the principle still applies for some other driver.)
> 
> In practice, we wind up doing the compare/timeout loop as on 
> /proc/scsi/scsi, but on /proc/bus/usb/devices or 
> /sys/bus/ieee1394/drivers/sbp2 instead.

sbp2 and its successor fw-sbp2 are not yet integrated with
scsi_wait_scan, but should be _some_ day.
http://bugzilla.kernel.org/show_bug.cgi?id=3225#c2
-- 
Stefan Richter
-=====-=-=== -=-= =--=-
http://arcgraph.de/sr/
