From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 4/4] fusion: fibre channel: don't sync cache if remote
	port deleted
Date: Tue, 01 Aug 2006 09:58:23 -0500
Message-ID: <1154444303.3446.11.camel@mulgrave.il.steeleye.com>
References: <44CE3BC0.8020901@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:30939 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750727AbWHAO63 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Aug 2006 10:58:29 -0400
In-Reply-To: <44CE3BC0.8020901@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: linux-scsi@vger.kernel.org

On Mon, 2006-07-31 at 12:20 -0500, Michael Reed wrote:
> mptscsih_slave_destroy issues an unconditional synchronize cache.

A) mptscsih_slave_destroy shouldn't be doing this ... it should be
relying on the functionality in the mid-layer.

> It is not necessary for fibre channel devices for which the rport
> has been deleted.  This patch creates a new function,
> mptfc_slave_destroy(), which implements the appropriate test.

So, this is really code that shouldn't be in a driver, it should be
higher up.

The other three patches look fine.

James


