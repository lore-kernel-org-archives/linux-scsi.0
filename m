From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 1 01/25] hpsa: stop zeroing reset_cmds_out and
 ioaccel_cmds_out during rescan
Date: Thu, 29 Oct 2015 14:25:54 +0100
Message-ID: <56321E62.5060501@redhat.com>
References: <20151028215206.5323.84194.stgit@brunhilda>
 <20151028220435.5323.57054.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54430 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932088AbbJ2NZ6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Oct 2015 09:25:58 -0400
In-Reply-To: <20151028220435.5323.57054.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

On 28.10.2015 23:04, Don Brace wrote:
> pulling the rug out from under the reset handler
> likewise for ioaccel_cmds_out
>
> Signed-off-by: Don Brace <don.brace@pmcs.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas

