From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/3] tcm ibmvscsis driver
Date: Wed, 23 Mar 2011 10:19:37 -0500
Message-ID: <4D8A0F89.201@linux.vnet.ibm.com>
References: <20110307134033K.fujita.tomonori@lab.ntt.co.jp> <1299508803.12730.1.camel@mulgrave.site> <4D83C78D.5040908@linux.vnet.ibm.com> <20110321100909E.fujita.tomonori@lab.ntt.co.jp> <4D87CF99.7040008@linux.vnet.ibm.com> <4D87D1B3.2030106@linux.vnet.ibm.com> <1300747720.21880.95.camel@haakon2.linux-iscsi.org> <4D889BB4.4010102@linux.vnet.ibm.com> <1300831607.21880.365.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e8.ny.us.ibm.com ([32.97.182.138]:53260 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756257Ab1CWPTl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Mar 2011 11:19:41 -0400
Received: from d01dlp02.pok.ibm.com (d01dlp02.pok.ibm.com [9.56.224.85])
	by e8.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p2NEt5GU030646
	for <linux-scsi@vger.kernel.org>; Wed, 23 Mar 2011 10:55:05 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 46B336E803C
	for <linux-scsi@vger.kernel.org>; Wed, 23 Mar 2011 11:19:39 -0400 (EDT)
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p2NFJcKq476538
	for <linux-scsi@vger.kernel.org>; Wed, 23 Mar 2011 11:19:39 -0400
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p2NFJcc0005340
	for <linux-scsi@vger.kernel.org>; Wed, 23 Mar 2011 09:19:38 -0600
In-Reply-To: <1300831607.21880.365.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James.Bottomley@suse.de, linux-scsi@vger.kernel.org

On 03/22/2011 05:06 PM, Nicholas A. Bellinger wrote:
>>>> I'm also seeing disktest complain on the client about commands taking longer than 120 seconds
>>>> on occasion, which may play into the performance issue I mentioned in my previous mail.
>>>>
>>>
>>> Mmmm, please verify with RAMDISK_MCP backends as well, as by default
>>> FILEIO has O_SYNC enabled..  This does seem strange for LTP disktest
>>> however..

With RAMDISK_MCP I don't see any of the problems seen with RAMDISK_DR. Additionally,
disktest is running much snappier. I'm seeing between 30 and 60 MB/sec on the read workload
and between 100 and 300 MB/sec on the writes. 

I'm having some trouble with multiple LUNs, however. Perhaps this is more
configuration issues, but if I create a lun_1 directory and link to a second
device, the client just sees two devices which seems to be both mapped to
the device mapped at lun_0.

Thanks,

Brian


-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center


