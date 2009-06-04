From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [Bug 13452] New: When log in a iscsi target it's fail and there
 is a bug scsi related
Date: Thu, 04 Jun 2009 12:09:30 -0500
Message-ID: <4A27FFCA.1000606@cs.wisc.edu>
References: <bug-13452-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:60302 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751077AbZFDRJf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Jun 2009 13:09:35 -0400
In-Reply-To: <bug-13452-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org


> I'm using a 2.6.27.5-hg Xen kernel. Modules iscsi_tcp and libiscsi are loaded
> but when I log in a target iscsi syslog says that there is a kernel bug in
> /var/xen/linux-2.6.27-xen.hg/drivers/scsi/scsi_lib.c:1759. I have download a
> mainline kernel 2.6.27.5 and the source code differs.
> 

What is hg xen?

This is close to
http://groups.google.com/group/open-iscsi/browse_thread/thread/c4ddd07c06546864/791c69f2e2a0d46d?lnk=gst&q=oops+xen#791c69f2e2a0d46d

scsi_alloc_queue calls blk_queue_bounce_limit so it could be the same 
bug but moved around due to differences on those kernels.

Is there a newer kernel? I do not remember the problem or solution. It 
was in the xen code. I will do some more searching, but if there is a 
newer kernel could you give it a try?
