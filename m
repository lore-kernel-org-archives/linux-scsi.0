From: "Seymour, Shane M" <shane.seymour@hpe.com>
Subject: RE: [PATCH v3 02/17] be2iscsi: Fix mbox synchronization replacing
 spinlock with mutex
Date: Fri, 8 Jan 2016 07:02:44 +0000
Message-ID: <DDB9C85B850785449757F9914A034FCB445095AC@G9W0766.americas.hpqcorp.net>
References: <1450859676-22025-1-git-send-email-jitendra.bhivare@avagotech.com>
 <1450859676-22025-3-git-send-email-jitendra.bhivare@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:22352 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574AbcAHHDW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jan 2016 02:03:22 -0500
In-Reply-To: <1450859676-22025-3-git-send-email-jitendra.bhivare@avagotech.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jitendra Bhivare <jitendra.bhivare@avagotech.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>


> This is second part of actual fix for soft lockup.
>
> All mbox cmds issued using BMBX and MCC are synchronized using mutex mbox_lock
> instead of spin_lock. Used mutex_lock_interruptible where ever possible.
>
> Signed-off-by: Jitendra Bhivare <jitendra.bhivare@avagotech.com>

Reviewed-by: Shane Seymour <shane.seymour@hpe.com> 
