From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: git-scsi-misc build error
Date: Tue, 31 Jul 2007 17:30:52 -0500
Message-ID: <1185921052.3468.51.camel@localhost.localdomain>
References: <20070731152732.ae8d251d.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:37301 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751816AbXGaWay (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Jul 2007 18:30:54 -0400
In-Reply-To: <20070731152732.ae8d251d.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: FUJITA Tomonori <tomof@acm.org>, linux-scsi@vger.kernel.org

On Tue, 2007-07-31 at 15:27 -0700, Andrew Morton wrote:
> ERROR: "scsi_tgt_it_nexus_create" [drivers/scsi/scsi_transport_srp.ko] undefined!
> ERROR: "scsi_tgt_it_nexus_destroy" [drivers/scsi/scsi_transport_srp.ko] undefined!
> 
> This bug was reported about seven times against 2.6.23-rc1-mm1's
> git-scsi-target, and now it has been moved into git-scsi-misc.

Yes ... Tomo's on the hook for a better fix, which is promised.

James


