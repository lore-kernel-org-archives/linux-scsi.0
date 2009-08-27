From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: [PATCH 06/64] libfc: Export FC headers
Date: Thu, 27 Aug 2009 12:27:39 +0200
Message-ID: <20090827102739.GC5125@schmichrtp>
References: <20090825205826.1553.94414.stgit@localhost.localdomain> <20090825205858.1553.17654.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.17.164]:32955 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbZH0K1j (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Aug 2009 06:27:39 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate4.de.ibm.com (8.13.1/8.13.1) with ESMTP id n7RAReRa023728
	for <linux-scsi@vger.kernel.org>; Thu, 27 Aug 2009 10:27:40 GMT
Received: from d12av04.megacenter.de.ibm.com (d12av04.megacenter.de.ibm.com [9.149.165.229])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n7RARei02621484
	for <linux-scsi@vger.kernel.org>; Thu, 27 Aug 2009 12:27:40 +0200
Received: from d12av04.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av04.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n7RARdSC029918
	for <linux-scsi@vger.kernel.org>; Thu, 27 Aug 2009 12:27:40 +0200
Content-Disposition: inline
In-Reply-To: <20090825205858.1553.17654.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Love <robert.w.love@intel.com>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

On Tue, Aug 25, 2009 at 01:58:58PM -0700, Robert Love wrote:
> Export fc_els.h, fc_fs.h, fc_gs.h and fc_ns.h so that they
> may be used by applications.
> 
> This will be needed for FC Passthrough applications like fcping,
> but could be used by other applications.

Are there already plans to implement tools like fcping? I have heard
people thinking about the idea, but i am not aware of a project
working on this.

--
Christof Schmitt
