From: Jeff Garzik <jeff@garzik.org>
Subject: Re: best userspace iscsi target lib?
Date: Tue, 11 Nov 2008 09:02:05 -0500
Message-ID: <4919905D.1040702@garzik.org>
References: <4918B5B2.8050003@garzik.org> <4919796F.1020300@vlnb.net> <49197DFF.9080901@garzik.org> <49198394.6070709@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:43654 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755487AbYKKOCQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Nov 2008 09:02:16 -0500
In-Reply-To: <49198394.6070709@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, linux-scsi <linux-scsi@vger.kernel.org>, Bart Van Assche <bart.vanassche@gmail.com>, scst-devel <scst-devel@lists.sourceforge.net>

Boaz Harrosh wrote:
> Jeff Garzik wrote:
>> Vladislav Bolkhovitin wrote:
>>> Jeff Garzik wrote:
>>>> Can someone recommend an open source userspace library that enables 
>>>> one to implement a userspace iSCSI target?
>>> Check SCST (http://scst.sf.net). Few weeks ago scst_local module added 
>>> to it ability to create user space target drivers using regular sg/bsg 
>>> interface. It's at the moment under active development, so still has a 
>>> number of issues, but they shouldn't prevent you from evaluating it. You 
>>> can find the code in the SVN using command:
>>>
>>> $ svn co https://scst.svn.sourceforge.net/svnroot/scst/trunk
>>>
>>> But there is a plenty of open source iSCSI targets in the world, 
>>> including one fully implemented in user space, so I wonder, what's wrong 
>>> with them to create another one?
>> None of them are massively distributed OSD and SBC targets, which are 
>> part of my experiments in distributed computing :)
>>
> 
> OK now it sounds even more interesting. Do you have any public
> information/documentation on these experiments.

If I am at the point of looking for userspace target libraries, then you 
can be sure the SCSI piece does not yet exist...  :)  I'm working on 
various building blocks related to distributed computing in my spare 
time (gotta string together all those cheap SATA disks, ya know).

One of the experiments is replicated/shared, multi-node storage exported 
via an iSCSI interface.  Doing similar things by wedding NFS version 4 
(http://linux.yyz.us/projects/nfsv4.html) with distributed storage.

	Jeff



