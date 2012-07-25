From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [resend PATCH 1/5] libata: reset once
Date: Wed, 25 Jul 2012 01:20:58 -0400
Message-ID: <500F823A.5040303@pobox.com>
References: <20120710040434.26529.86552.stgit@dwillia2-linux.jf.intel.com> <20120710040547.26529.78860.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:48510 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102Ab2GYFVH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jul 2012 01:21:07 -0400
In-Reply-To: <20120710040547.26529.78860.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: JBottomley@parallels.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Tejun Heo <tj@kernel.org>

On 07/10/2012 12:05 AM, Dan Williams wrote:
> Hotplug testing with libsas currently encounters a 55 second wait for
> link recovery to give up.  In the case where the user trusts the
> response time of their devices permit the recovery attempts to be
> limited to one.
>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Acked-by: Jeff Garzik <jgarzik@redhat.com>

