From: Michael Neuling <mikey@neuling.org>
Subject: Re: [PATCH v4 0/3] CXL Flash Error Recovery and Superpipe
Date: Tue, 11 Aug 2015 11:32:19 +1000
Message-ID: <1439256739.5081.36.camel@neuling.org>
References: <1439226565-7700-1-git-send-email-mrochs@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:48232 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932740AbbHKBcV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Aug 2015 21:32:21 -0400
In-Reply-To: <1439226565-7700-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, brking@linux.vnet.ibm.com, wenxiong@linux.vnet.ibm.com, hch@infradead.org, imunsie@au1.ibm.com, dja@ozlabs.au.ibm.com

> This patch set is intended for the 4.3 release and adds support for
> error recovery and the superpipe features provided by the IBM CXL
> Flash adapter. The superpipe function was originally presented in an
> RFC patch set in late April. To aid with the review of the superpipe
> portion of these enhancements, we have further split it across the
> last two patches in this set. Please reference the changelog below
> for details on what has been altered from previous versions of this
> patchset.

Worth noting here that this depends on the original cxlflash patch from
here:
  http://permalink.gmane.org/gmane.linux.scsi/102357

> v4 Changes:
> - Removes patch of legacy fixes/refactoring

Are you going to repost these as a separate series?

Mikey


