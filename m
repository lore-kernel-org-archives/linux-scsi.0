From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [patch 17/30] scsi: fix uaccess handling
Date: Fri, 15 Dec 2006 21:38:56 +0100
Message-ID: <20061215203856.GA10684@osiris.ibm.com>
References: <200612042319.kB4NJh8v008777@shell0.pdx.osdl.net> <1166212214.2846.50.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.29.151]:10496 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431AbWLOUjA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Dec 2006 15:39:00 -0500
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate2.de.ibm.com (8.13.8/8.13.8) with ESMTP id kBFKcwNM127142
	for <linux-scsi@vger.kernel.org>; Fri, 15 Dec 2006 20:38:59 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id kBFKcw3o3027016
	for <linux-scsi@vger.kernel.org>; Fri, 15 Dec 2006 21:38:58 +0100
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id kBFKcw9W029177
	for <linux-scsi@vger.kernel.org>; Fri, 15 Dec 2006 21:38:58 +0100
Content-Disposition: inline
In-Reply-To: <1166212214.2846.50.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: akpm@osdl.org, linux-scsi@vger.kernel.org

On Fri, Dec 15, 2006 at 01:50:14PM -0600, James Bottomley wrote:
> On Mon, 2006-12-04 at 15:18 -0800, akpm@osdl.org wrote:
> > From: Heiko Carstens <heiko.carstens@de.ibm.com>
> >
> > Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> > Signed-off-by: Andrew Morton <akpm@osdl.org>
> 
> No in current form ... an update is on the list.

I'll leave it to somebody else to test and send the updated patch.
