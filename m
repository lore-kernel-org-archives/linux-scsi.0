From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 0/5] mpt2sas: enhancements for 2.6.31 kernel
Date: Mon, 18 May 2009 12:58:52 -0600
Message-ID: <20090518185850.GA26609@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og105.obsmtp.com ([64.18.2.163]:53216 "EHLO
	exprod7og105.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbZERSxF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 May 2009 14:53:05 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org

Please consider for the 2.6.31 merge.

Here are set of patchs posted over a month that missed 2.6.30 window.
This includes LUN reset and T10 DIF support.

Signed-off-by: Eric Moore <eric.moore@lsi.com>

[PATCH 1/5] mpt2sas: T10 DIF Support - EEDP
[PATCH 2/5] mpt2sas: LUN Reset Support
[PATCH 3/5] mpt2sas: add query task support for MPT2COMMAND  ioctl
[PATCH 4/5] mpt2sas: using the same naming convention for all static function
[PATCH 5/5] mpt2sas: bump driver version to 01.100.03.00

