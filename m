From: shyam.iyer.t@gmail.com
Subject: Thin provisioning trivial Update
Date: Sat, 26 Feb 2011 01:59:43 -0500
Message-ID: <1298703585-15387-1-git-send-email-shyam_iyer@dell.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:62621 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393Ab1BZHAO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 26 Feb 2011 02:00:14 -0500
Received: by qyg14 with SMTP id 14so2072783qyg.19
        for <linux-scsi@vger.kernel.org>; Fri, 25 Feb 2011 23:00:13 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The first patch logs a kernel warning message for the THIN PROVISIONING SOFT THRESHOLD REACHED Unit Attention
The second patch adds the THIN PROVISIONING SOFT THRESHOLD REACHED Unit Attention to scsi constants
