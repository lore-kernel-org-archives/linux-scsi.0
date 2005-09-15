From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: RE: [PATCH 2/2] fusion SAS support (mptsas driver)
Date: Thu, 15 Sep 2005 12:47:51 -0600
Message-ID: <91888D455306F94EBD4D168954A9457C0407A562@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:45037 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1030573AbVIOSs1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Sep 2005 14:48:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: jejb@steeleye.com, linux-scsi@vger.kernel.org

On Thursday, September 15, 2005 6:19 AM, Christoph Hellwig wrote: 
> 
> Did you get any compile errors in scsi_transport_sas.c?  
> sas_host_setup
> changed the prototype from
> 
> 	static int sas_host_setup(struct device *dev)
> 
> to
> 
> 	static int sas_host_setup(struct transport_container *tc,
> 		struct device *dev, struct class_device *cdev)
> 
> recently, and you're oops looks like you have a mismatch.
>

That fix's it, however before there were no compile errors.

When I watch real closely while it compiled, and I saw
the warning

scsi_transport_sas.c: line 170 warning: initialization from incompatible
pointer type

