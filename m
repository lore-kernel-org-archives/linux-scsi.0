From: Brian King <brking@us.ibm.com>
Subject: Re: How to add/drop SCSI drives from within the driver?
Date: Wed, 08 Dec 2004 17:46:38 -0600
Message-ID: <41B7925E.5070700@us.ibm.com>
References: <0E3FA95632D6D047BA649F95DAB60E570230CA8C@exa-atlanta>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:1436 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261406AbULHXqk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Dec 2004 18:46:40 -0500
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E570230CA8C@exa-atlanta>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Bagalkote, Sreenivas" <sreenib@lsil.com>
Cc: Matt Domsch <Matt_Domsch@dell.com>, 'James Bottomley' <James.Bottomley@SteelEye.com>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "'bunk@fs.tum.de'" <bunk@fs.tum.de>, 'Andrew Morton' <akpm@osdl.org>, "Ju, Seokmann" <sju@lsil.com>, "Doelfel, Hardy" <hdoelfel@lsil.com>, "Mukker, Atul" <Atulm@lsil.com>

Bagalkote, Sreenivas wrote:
> Adding a drive:- For application to use sysfs to scan newly added drive,
> it needs to know the HCTL (SCSI address - Host, Channel, Target & Lun)
> of the drive. Driver is the only one that knows the mapping between a 
> drive and the corresponding HCTL.

Can you explain from a high level how megaraid adds logical devices?
I assume a management app of some sort sends a command to the adapter
to create a disk array. What interface is used for this?
Does this trigger any notification from the adapter to the device
driver?

> Removing a drive:- There is no sane way for the application to map out
> drives to /dev/sd<x>. 

This information is all available in sysfs. Have you looked at libsysfs
at all?



-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

