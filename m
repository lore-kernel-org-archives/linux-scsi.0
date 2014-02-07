From: Kurt Miller <kurt@intricatesoftware.com>
Subject: Re: LSI SAS2008 SATA TRIM not working
Date: Fri, 07 Feb 2014 15:46:30 -0500
Message-ID: <1391805990.2761.4.camel@sonic.justonedata.com>
References: <1391730975.3449.16.camel@sonic.justonedata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 4133fa24.cst.lightpath.net ([65.51.250.36]:42033 "EHLO
	mail1.intricatesoftware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751576AbaBGUqk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Feb 2014 15:46:40 -0500
Received: from [10.0.0.21] (ool-435468f5.dyn.optonline.net [67.84.104.245])
	(authenticated bits=0)
	by mail1.intricatesoftware.com (8.14.5/8.14.3) with ESMTP id s17KkUhp000259
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Fri, 7 Feb 2014 15:46:34 -0500 (EST)
In-Reply-To: <1391730975.3449.16.camel@sonic.justonedata.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Thu, 2014-02-06 at 18:56 -0500, Kurt Miller wrote:
> Various sources indicate that LSI's SAS2008 controllers support TRIM
> when running their IT firmware (LSI [1] and this list [2]). However, I
> have not been able to get it working with Dell PERC H200 or H310 cross
> flashed into LSI IT firmware. Currently I'm testing with Samsung 840 EVO
> SATA SSDs. I have tried various LSI IT firmware versions (P14, P16, P18)
> and various Linux distributions (Ubuntu 13.10, Ubuntu 12.04, Ubuntu 14
> beta, RHEL 7 beta, Fedora 19).
>
> Is TRIM working for anyone using LSI SAS2008 controllers?

It turns out yes, TRIM is working for LSI SAS2008 controllers. However,
the Samsung 840 EVO's are not compatible with it and are also missing
from the LSI compatibility list for the controller [1]. When I got my
hands on an SSD that is on the list, TRIM worked as expected.

[1] http://www.lsi.com/downloads/Public/Host%20Bus%20Adapters/Host%20Bus
%20Adapters%20Common%20Files/LSI_6Gb_SAS_SATA_HBA_Compatibility_List.pdf

Regards,
-Kurt

