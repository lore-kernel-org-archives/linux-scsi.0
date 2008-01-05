From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Open-FCoE on linux-scsi
Date: Sat, 05 Jan 2008 01:09:56 +0100
Message-ID: <477ECAD4.8010809@s5r6.in-berlin.de>
References: <200801031035.m03AZYcJ012171@mbox.iij4u.or.jp><10A7D0016239E24092DEF05CCC582E4302BB789B@fmsmsx411.amr.corp.intel.com><477E1C69.9010203@s5r6.in-berlin.de> <20080104205938U.fujita.tomonori@lab.ntt.co.jp> <08FE5CC30C9A3F41BF819A502CF7BF6E029FF0B8@fmsmsx411.amr.corp.intel.com> <477EC411.9040703@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:33083 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753621AbYAEAKP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Jan 2008 19:10:15 -0500
In-Reply-To: <477EC411.9040703@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Dev, Vasu" <vasu.dev@intel.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, "Love, Robert W" <robert.w.love@intel.com>, tomof@acm.org, "Zou, Yi" <yi.zou@intel.com>, "Leech, Christopher" <christopher.leech@intel.com>, linux-scsi@vger.kernel.org

Stefan Richter wrote:
> I.e. you have SCSI command set layer -- SCSI core -- SCSI transport
> layer -- interconnect layer.

The interconnect layer could be split further:
SCSI command set layer -- SCSI core -- SCSI transport layer (FCP) --
Fibre Channel core -- Fibre Channel card drivers, FCoE drivers.

But this would only really make sense if anybody would implement
additional FC-4 drivers besides FCP, e.g. RFC 2625, which would also sit
on top of Fibre Channel core.
-- 
Stefan Richter
-=====-==--- ---= --=-=
http://arcgraph.de/sr/
