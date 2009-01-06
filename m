From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 09/18] osd_ktests: Test Attribute lists
Date: Tue, 06 Jan 2009 18:50:37 +0200
Message-ID: <49638BDD.1010700@panasas.com>
References: <49636507.8060808@panasas.com> <1231251624-20284-1-git-send-email-bharrosh@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:21115 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751463AbZAFQuk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jan 2009 11:50:40 -0500
In-Reply-To: <1231251624-20284-1-git-send-email-bharrosh@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd ml <osd-dev@open-osd.org>
Cc: Andrew Morton <akpm@linux-foundation.org>

Boaz Harrosh wrote:
> Add tests for setting/getting Attribute lists. All combinations
> of read/write with set/get attributes are tested.
> (6 possibilities), So all but data integrity request structure
> layouts are attempted.
> 
> This test passes against the IBM-OSD-SIM OSDv1 target.
> 
> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> Reviewed-by: Benny Halevy <bhalevy@panasas.com>

If it is decided to drop the in kernel test
then Just drop this patch to.

Thanks
Boaz
