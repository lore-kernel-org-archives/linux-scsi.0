From: Boaz Harrosh <bharrosh@panasas.com>
Subject: gdth: resend missing patches for 2.6.24 stable
Date: Wed, 27 Feb 2008 15:17:20 -0800
Message-ID: <47C5EF80.4080600@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.182]:30920 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762152AbYB0WSK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Feb 2008 17:18:10 -0500
Received: by el-out-1112.google.com with SMTP id v27so2687049ele.23
        for <linux-scsi@vger.kernel.org>; Wed, 27 Feb 2008 14:18:09 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tobias Oetiker <tobi@oetiker.ch>, allied internet ag- Stefan Priebe <s.priebe@allied-internet.ag>, Jon Chelton <jchelton@ffpglobal.com>, James Bottomley <James.Bottomley@HansenPartn>
Cc: Andrew Morton <akpm@linux-foundation.org>, Dave Milter <davemilter@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>

Resending bugfix patches for gdth driver
they have all been tested and are necessary for
normal gdth operation.

The patches are for and based on Linux-2.6.24. here is the list of patches:
   [PATCH 3/5] gdth: bugfix for the at-exit problems
   [PATCH 4/5] gdth: fix to internal commands execution
   [PATCH 5/5] gdth: remove gdth cooked up command accessors

Thanks in advance
Boaz



