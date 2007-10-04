From: malahal@us.ibm.com
Subject: [RFC] [PATCH 0/2] blk request timeout handler patches
Date: Thu, 4 Oct 2007 11:12:59 -0700
Message-ID: <20071004181259.GA16689@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:46409 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755759AbXJDSNC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Oct 2007 14:13:02 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e33.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l94ID1fm003147
	for <linux-scsi@vger.kernel.org>; Thu, 4 Oct 2007 14:13:01 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l94ID0hw459996
	for <linux-scsi@vger.kernel.org>; Thu, 4 Oct 2007 12:13:00 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l94ID0HO018458
	for <linux-scsi@vger.kernel.org>; Thu, 4 Oct 2007 12:13:00 -0600
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jens.axboe@oracle.com

I refreshed the blk layer timeout patch from Mike Christie to 2.6.23-rc8-mm1.
Fixed couple of places where scsi_dispatch_cmd() wasn't stopping timers.

Thanks, Malahal.
