From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 03/19] qla2xxx: Limit iIDMA speed adjustments.
Date: Sat, 22 Sep 2007 12:01:20 -0500
Message-ID: <1190480480.3347.28.camel@localhost.localdomain>
References: <20070920210422.GE8456@plap3.qlogic.org>
	 <1190322470-15543-3-git-send-email-andrew.vasquez@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:55094 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752722AbXIVRBX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 22 Sep 2007 13:01:23 -0400
In-Reply-To: <1190322470-15543-3-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, Seokmann Ju <seokmann.ju@qlogic.com>

On Thu, 2007-09-20 at 14:07 -0700, Andrew Vasquez wrote:
> Do not adjust the iIDMA speed on ports which have a faster
> link-speed than the HBA itself.

This one doesn't actually apply.  It conflicts with your previous 

[SCSI] qla2xxx: Add iIDMA support.

patch.

James


