From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: best userspace iscsi target lib?
Date: Tue, 11 Nov 2008 17:05:11 +0300
Message-ID: <49199117.2050808@vlnb.net>
References: <4918B5B2.8050003@garzik.org> <4919796F.1020300@vlnb.net> <49197DFF.9080901@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:56453 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756170AbYKKOFG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Nov 2008 09:05:06 -0500
In-Reply-To: <49197DFF.9080901@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Bart Van Assche <bart.vanassche@gmail.com>, scst-devel <scst-devel@lists.sourceforge.net>

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

Yes, OSD is a good thing. I'd love to add an OSD backend in SCST.

> 	Jeff
> 
> 
> 
> 

