From: Mark Haverkamp <markh@osdl.org>
Subject: scsi_device_reprobe compile failure in scsi_misc_2.6
Date: Mon, 02 Oct 2006 11:33:17 -0700
Message-ID: <1159813997.3795.7.camel@markh3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:4077 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S965282AbWJBSdU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Oct 2006 14:33:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

It looks like a recent patch to scsi_device_reprobe() has introduced a
compile error.  It now checks the return value of device_reprobe() but
the patch to make device_reprobe() return int hasn't been applied to the
tree yet.

Mark.

-- 
Mark Haverkamp <markh@osdl.org>

