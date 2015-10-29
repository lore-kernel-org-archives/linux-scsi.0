From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 1 03/25] hpsa: check for null arguments to dev_printk
Date: Thu, 29 Oct 2015 14:41:32 +0100
Message-ID: <5632220C.2000207@redhat.com>
References: <20151028215206.5323.84194.stgit@brunhilda>
 <20151028220447.5323.79638.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55145 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932088AbbJ2Nlg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Oct 2015 09:41:36 -0400
In-Reply-To: <20151028220447.5323.79638.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

On 28.10.2015 23:04, Don Brace wrote:
> Check for NULLs.

How is the devtype change related to this?

Please next time use separated patch for every change.

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Cheers,
Tomas

