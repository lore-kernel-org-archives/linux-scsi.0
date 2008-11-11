From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: best userspace iscsi target lib?
Date: Tue, 11 Nov 2008 15:07:32 +0200
Message-ID: <49198394.6070709@panasas.com>
References: <4918B5B2.8050003@garzik.org> <4919796F.1020300@vlnb.net> <49197DFF.9080901@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:4767 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755134AbYKKNHU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Nov 2008 08:07:20 -0500
In-Reply-To: <49197DFF.9080901@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, linux-scsi <linux-scsi@vger.kernel.org>, Bart Van Assche <bart.vanassche@gmail.com>, scst-devel <scst-devel@lists.sourceforge.net>

Jeff Garzik wrote:
> Vladislav Bolkhovitin wrote:
>> Jeff Garzik wrote:
>>> Can someone recommend an open source userspace library that enables 
>>> one to implement a userspace iSCSI target?
>> Check SCST (http://scst.sf.net). Few weeks ago scst_local module added 
>> to it ability to create user space target drivers using regular sg/bsg 
>> interface. It's at the moment under active development, so still has a 
>> number of issues, but they shouldn't prevent you from evaluating it. You 
>> can find the code in the SVN using command:
>>
>> $ svn co https://scst.svn.sourceforge.net/svnroot/scst/trunk
>>
>> But there is a plenty of open source iSCSI targets in the world, 
>> including one fully implemented in user space, so I wonder, what's wrong 
>> with them to create another one?
> 
> None of them are massively distributed OSD and SBC targets, which are 
> part of my experiments in distributed computing :)
> 

OK now it sounds even more interesting. Do you have any public
information/documentation on these experiments.

There might be some interesting links on http://open-osd.org

also look up at: http://citeseerx.ist.psu.edu/viewdoc/summary?doi=10.1.1.1.4604
It's a project from UCSC that implements a local object storage SW. It might
look interesting for embedded systems that don't want to invest in a complete
file system, and might give better performance in implementation of OSD protocol.

> 	Jeff
> 

Boaz
