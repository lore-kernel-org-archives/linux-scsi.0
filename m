From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 1/1] scsi: cover up bugs^W^W^WFix up compiler warnings
 in megaraid driver
Date: Fri, 25 May 2007 14:45:34 -0700
Message-ID: <20070525144534.a76e59b8.akpm@linux-foundation.org>
References: <200705232311.l4NNBlfZ007264@shell0.pdx.osdl.net>
	<0631C836DBF79F42B5A60C8C8D4E8229AE1465@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:44383 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757532AbXEYVqO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 May 2007 17:46:14 -0400
In-Reply-To: <0631C836DBF79F42B5A60C8C8D4E8229AE1465@NAMAIL2.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Patro, Sumant" <Sumant.Patro@lsi.com>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, mbligh@google.com

On Fri, 25 May 2007 14:28:19 -0600 "Patro, Sumant" <Sumant.Patro@lsi.com> wrote:

> Ack.

Thanks.



While we're here...

box:/usr/src/25> grep -i lsi MAINTAINERS
LSILOGIC MPT FUSION DRIVERS (FC/SAS/SPI)
M:      Eric.Moore@lsi.com
M:      support@lsi.com
L:      mpt_linux_developer@lsi.com
W:      http://www.lsilogic.com/support
LSILOGIC/SYMBIOS/NCR 53C8XX and 53C1010 PCI-SCSI drivers
W:      http://megaraid.lsilogic.com
USB KAWASAKI LSI DRIVER
M:      uclinux-v850@lsi.nec.co.jp

box:/usr/src/25> grep -i sumant MAINTAINERS   
box:/usr/src/25> 

Could I ask that you review the MAINTAINERS file and ensure that
all appropriate lsil developers are appropriately mentioned and that
all drivers which lsil look after have the appropriate entries?

Thanks.
