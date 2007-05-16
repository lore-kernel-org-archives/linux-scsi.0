From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [PATCH] aacraid: fix panic on short Inquiry
Date: Wed, 16 May 2007 11:02:41 -0400
Message-ID: <1179327762.3787.26.camel@mulgrave.il.steeleye.com>
References: <AE4F746F2AECFC4DA4AADD66A1DFEF0197D9C4@otce2k301.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:55129 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754053AbXEPPCp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 May 2007 11:02:45 -0400
In-Reply-To: <AE4F746F2AECFC4DA4AADD66A1DFEF0197D9C4@otce2k301.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Wed, 2007-05-16 at 10:06 -0400, Salyzyn, Mark wrote:
> Reject, transfer_len is an unsigned ... modified patch enclosed.

Thanks ... I constructed the patch on the fly from a debugging version
at the site, so I forgot this change.  I'll put the modified version in.

James


