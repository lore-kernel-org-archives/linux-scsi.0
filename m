From: Graham Reed <greed@pobox.com>
Subject: Re: mvsas panic
Date: Sun, 28 Feb 2010 23:40:36 -0500
Message-ID: <AEDC195E-A1C5-413A-B264-35F15ED4AAF7@pobox.com>
References: <87d699441002281928u7e57f4a1saacddd020a6d6c3f@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:59525 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310Ab0CAEkk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Feb 2010 23:40:40 -0500
In-Reply-To: <87d699441002281928u7e57f4a1saacddd020a6d6c3f@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ilia Mirkin <imirkin@alum.mit.edu>
Cc: linux-scsi@vger.kernel.org

I'd suggest you try the MVSAS patch posted by Srinivas on Feb 16 this year, <http://marc.info/?l=linux-scsi&m=126631870018248&w=2>.  Subject is "[PATCH] MVSAS: hot plug handling and IO issues".

It seems to fix several problems; mine was having the connections hang during MD RAID operations, wedging an entire device.  Though hotplug is working for me with it, too.

I've got my card running 8 SATA drives now, and had it do a RAID1 "check" on 3 pairs (6 drives in total) at once, and no wedging or panics or even warnings this time.

And I can now get the documented maximum sustained read speed from my drives, rather than the PCI legacy bottleneck I used to get.

