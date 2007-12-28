From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: Open-FCoE on linux-scsi
Date: Sat, 29 Dec 2007 04:11:29 +0900
Message-ID: <200712281911.lBSJBWnB020367@mbox.iij4u.or.jp>
References: <10A7D0016239E24092DEF05CCC582E43028A671C@fmsmsx411.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:54386 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751430AbXL1TLo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Dec 2007 14:11:44 -0500
In-Reply-To: <10A7D0016239E24092DEF05CCC582E43028A671C@fmsmsx411.amr.corp.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: robert.w.love@intel.com
Cc: linux-scsi@vger.kernel.org, yi.zou@intel.com, christopher.leech@intel.com, vasu.dev@intel.com, fujita.tomonori@lab.ntt.co.jp

From: "Love, Robert W" <robert.w.love@intel.com>
Subject: Open-FCoE on linux-scsi
Date: Tue, 27 Nov 2007 15:40:05 -0800

> Hello SCSI mailing list,
> 
> 	I'd just like to introduce ourselves a bit before we get
> started. My name is Robert Love and I'm joined by a team of engineers
> including Vasu Dev, Chris Leech and Yi Zou. We are committed to
> maintaining the Open-FCoE project. Aside from Intel engineers we expect
> engineers from other companies to contribute to Open-FCoE. 
> 
> 	Our goal is to get the initiator code upstream. We have a lot of
> working code but recognize that we're early in this project's
> development. We're looking for direction from you, the experts, on what
> this project should grow into.

I've just added a new fcoe target driver to tgt:

http://stgt.berlios.de/

The driver runs in user space unlike your target mode driver (I just
modified your FCoE code to run it in user space).

The initiator driver succeeded to log in a target, see logical units,
and perform some I/Os. It's still very unstable but it would be
useful for FCoE developers.


I would like to help you push the Open-FCoE initiator to mainline
too. What are on your todo list and what you guys working on now?
