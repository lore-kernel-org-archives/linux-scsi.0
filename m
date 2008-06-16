From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: [RFC] Move FC definitions from zfcp to global header
Date: Mon, 16 Jun 2008 12:18:24 +0200
Message-ID: <20080616101823.GB7228@schmichrtp.de.ibm.com>
References: <20080612130245.GA13761@schmichrtp.de.ibm.com> <10A7D0016239E24092DEF05CCC582E4303DF5C54@fmsmsx411.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.29.152]:44570 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699AbYFPKS1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Jun 2008 06:18:27 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate3.de.ibm.com (8.13.8/8.13.8) with ESMTP id m5GAIQVE164436
	for <linux-scsi@vger.kernel.org>; Mon, 16 Jun 2008 10:18:26 GMT
Received: from d12av01.megacenter.de.ibm.com (d12av01.megacenter.de.ibm.com [9.149.165.212])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m5GAIPmn3076152
	for <linux-scsi@vger.kernel.org>; Mon, 16 Jun 2008 12:18:25 +0200
Received: from d12av01.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av01.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m5GAIPwe018474
	for <linux-scsi@vger.kernel.org>; Mon, 16 Jun 2008 12:18:25 +0200
Content-Disposition: inline
In-Reply-To: <10A7D0016239E24092DEF05CCC582E4303DF5C54@fmsmsx411.amr.corp.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Love, Robert W" <robert.w.love@intel.com>
Cc: linux-scsi@vger.kernel.org

On Thu, Jun 12, 2008 at 08:19:22AM -0700, Love, Robert W wrote:
> This is the approach that the Open-FCoE re-architecture tree has taken,
> at least in regards to having common FC definitions. The only difference
> being that our tree has a bunch of headers in include/scsi/fc/. Ours are
> split out into about 8 files; however, we shouldn't be using all of
> them, so consolidating the necessary/used definitions into one file
> should work well for us.

I don't know if one file for everything FC related or a split in
different files (e.g. fc_gs.h, fc_ls.h, ...) would be better. I went
with one file to make the work simpler.

Christof
