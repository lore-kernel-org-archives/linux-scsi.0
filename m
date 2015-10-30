From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 1 19/25] hpsa: eliminate fake lun0 enclosures
Date: Fri, 30 Oct 2015 15:12:26 +0100
Message-ID: <56337ACA.5030000@redhat.com>
References: <20151028215206.5323.84194.stgit@brunhilda>
 <20151028220625.5323.81676.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36344 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030592AbbJ3OMa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Oct 2015 10:12:30 -0400
In-Reply-To: <20151028220625.5323.81676.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

On 28.10.2015 23:06, Don Brace wrote:
> From: Scott Teel <scott.teel@pmcs.com>
>
> We don't need to create fake enclosure devices at Lun0
> in external target array configurations anymore.
> This was done to support Pre-SCSI rev 5 controllers
> that didn't suppoprt report luns commands, so the
> SCSI layer had to scan targets. If there was no
> LUN at LUN 0, then the target scan would stop, and
> move to the next target.  Lun0 enclosure device
> was added to prevent sparsely-numbered LUNs from
> being missed.
>
> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
> Reviewed-by: Justin Lindley <justin.lindley@pmcs.com>
> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
> Signed-off-by: Don Brace <don.brace@pmcs.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas

