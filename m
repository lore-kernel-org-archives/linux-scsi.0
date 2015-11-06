From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v2 01/27] hpsa: remove unused parameter hostno
Date: Fri, 6 Nov 2015 15:22:35 +0100
Message-ID: <563CB7AB.9010904@redhat.com>
References: <20151104214910.15472.23179.stgit@brunhilda>
 <20151104215001.15472.10879.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44975 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746AbbKFOWj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Nov 2015 09:22:39 -0500
In-Reply-To: <20151104215001.15472.10879.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

On 4.11.2015 22:50, Don Brace wrote:
> This parameter was once used before scan_start was defined
> but now it is no longer used.
>
> Signed-off-by: Don Brace <don.brace@pmcs.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas

