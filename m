From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: [RFC PATCH 2.6.9-rc2] Add sysfs queue depth override to qla2xxx
Date: Sun, 26 Sep 2004 23:25:33 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040927062533.GA184410@sgi.com>
References: <20040927061003.GA182890@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:35463 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S266183AbUI0GZi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Sep 2004 02:25:38 -0400
Received: from cthulhu.engr.sgi.com (cthulhu.engr.sgi.com [192.26.80.2])
	by omx2.sgi.com (8.12.11/8.12.9/linux-outbound_gateway-1.1) with ESMTP id i8R7ZYRX004919
	for <linux-scsi@vger.kernel.org>; Mon, 27 Sep 2004 00:35:34 -0700
Received: from classic.engr.sgi.com (classic.engr.sgi.com [163.154.5.111])
	by cthulhu.engr.sgi.com (SGI-8.12.5/8.12.5) with ESMTP id i8R6PYY914067231
	for <linux-scsi@vger.kernel.org>; Sun, 26 Sep 2004 23:25:35 -0700 (PDT)
Received: from classic.engr.sgi.com (localhost [127.0.0.1])
	by classic.engr.sgi.com (SGI-8.12.5/8.12.5) with ESMTP id i8R6PYjn182273
	for <linux-scsi@vger.kernel.org>; Sun, 26 Sep 2004 23:25:34 -0700 (PDT)
Received: (from jeremy@localhost)
	by classic.engr.sgi.com (SGI-8.12.5/8.12.5/Submit) id i8R6PXO8184495
	for linux-scsi@vger.kernel.org; Sun, 26 Sep 2004 23:25:33 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20040927061003.GA182890@sgi.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Sun, Sep 26, 2004 at 11:10:03PM -0700, Jeremy Higdon wrote:
> This patch is to QLA2xxx version 8.00.00b15-k, and it allows users
> to override the default driver queue depth for a target by making
> the queue_depth sysfs attribute writeable.
> 
> I based this on the code in the 53c700 driver.
> 
> Andrew, please apply if it looks correct to you and James.
> 
> Let me know if you'd like me to regenerate against a different qla2xxx
> version.
> 
> thanks
> 
> Jeremy

signed-off-by: Jeremy Higdon <jeremy@sgi.com>
