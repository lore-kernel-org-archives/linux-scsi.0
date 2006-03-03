From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [RFC] aic94xx: attaching to the sas transport class
Date: Fri, 03 Mar 2006 16:58:47 +0100
Message-ID: <440867B7.70703@s5r6.in-berlin.de>
References: <20060303101420.78398.qmail@web31806.mail.mud.yahoo.com> <1141399404.3928.5.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:43789 "EHLO
	statik.tu-cottbus.de") by vger.kernel.org with ESMTP
	id S1030219AbWCCP7K (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Mar 2006 10:59:10 -0500
In-Reply-To: <1141399404.3928.5.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: ltuikov@yahoo.com, "Tarte, Robert" <Robert_Tarte@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> Assuming the cages are all powered up, which is beyond
> the driver control, then serialising the scan will allow one to
> specify /dev/sda1 deterministically for root.

Does SAS provide a persistent globally unique property of a device, or
has SAS to rely on bus topology to uniqely identify devices?
-- 
Stefan Richter
-=====-=-==- --== ---==
http://arcgraph.de/sr/
