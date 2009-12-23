From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: mvsas: Disks detected in 'wrong' order.
Date: Wed, 23 Dec 2009 15:02:55 +0100
Message-ID: <4B32230F.4010901@s5r6.in-berlin.de>
References: <30140.87.210.74.220.1261570095.squirrel@ketsers.dhs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:40816 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755884AbZLWODJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Dec 2009 09:03:09 -0500
In-Reply-To: <30140.87.210.74.220.1261570095.squirrel@ketsers.dhs.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Caspar Smit <c.smit@truebit.nl>
Cc: linux-scsi@vger.kernel.org

Caspar Smit wrote:
> Previous drivers I used (from scst and from supermicro) assigned /dev/sdb
> to slot 0, sdc to slot 1, etc.. like it should.

No, it should
  1. assign a unique device name to a device once it was discovered,
  2. discover devices as quickly as possible, which in turn usually
     means in parallel, and that means in random order.

The kernel's device names do not mean anything.  (They never did.)  Use
udev's /dev/disk/by-*/ symlinks, or partition labels or IDs, whenever
you need not only unique but also persistent device names.
-- 
Stefan Richter
-=====-==--= ==-- =-===
http://arcgraph.de/sr/
