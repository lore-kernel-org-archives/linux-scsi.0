From: Bryan Henderson <hbryan@us.ibm.com>
Subject: RE: How does a SCSI device gets a target ID?
Date: Fri, 11 Mar 2005 12:39:19 -0800
Message-ID: <OF134A0EB8.3D38AF6B-ON88256FC1.006C7DC5-88256FC1.0071740C@us.ibm.com>
References: <267988DEACEC5A4D86D5FCD780313FBB0575F562@exch-03.noida.hcltech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Received: from e1.ny.us.ibm.com ([32.97.182.141]:923 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261686AbVCKUkQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Mar 2005 15:40:16 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e1.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j2BKe8OA003201
	for <linux-scsi@vger.kernel.org>; Fri, 11 Mar 2005 15:40:08 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j2BKe84h074070
	for <linux-scsi@vger.kernel.org>; Fri, 11 Mar 2005 15:40:08 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11/8.12.11) with ESMTP id j2BKe8A0006612
	for <linux-scsi@vger.kernel.org>; Fri, 11 Mar 2005 15:40:08 -0500
In-Reply-To: <267988DEACEC5A4D86D5FCD780313FBB0575F562@exch-03.noida.hcltech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Rajat Jain, Noida" <rajatj@noida.hcltech.com>
Cc: linux-scsi@vger.kernel.org

>Every time I plug / unplug the disk, I have to echo "scsi
>add-single-device"/"scsi remove single-device" (with correct traget ID) 
to
>/proc/scsi/scsi. I wanted to automate this process, I wanted the disk to 
get
>detected and installed the moment it is inserted / removed. Can I do 
that? I
>don't mind writing a kernel module if need be.

This is the wonderful world of hotplug.  I don't know anything about 
hotplug -- my expertise on SCSI comes from an era when it wasn't even 
electrically possible (allowable, anyway) to add a disk to a SCSI bus 
without powering down.

So I hope someone on the list will give us an overview of the state of 
hotplug and SCSI.

