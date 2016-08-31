From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 13/17] smartpqi: remove timeout for cache flush operations
Date: Wed, 31 Aug 2016 16:47:54 +0200
Message-ID: <1861a5f9-4da0-0e3a-d5cd-f88dd8f9487c@redhat.com>
References: <147222977996.31214.8588187948847476082.stgit@brunhilda>
 <147222992420.31214.16768734205314588696.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49164 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935042AbcHaOr6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 31 Aug 2016 10:47:58 -0400
In-Reply-To: <147222992420.31214.16768734205314588696.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>, jejb@linux.vnet.ibm.com, Viswas.G@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Kevin.Barnett@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

On 26.8.2016 18:45, Don Brace wrote:
> From: Kevin Barnett <kevin.barnett@microsemi.com>
>
> Some cache flush operations can take longer than the
> timeout value. Best to not impose a time limit to
> handle all cases.
>
> Reviewed-by: Scott Teel <scott.teel@microsemi.com>
> Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
> Signed-off-by: Kevin Barnett <kevin.barnett@microsemi.com>
> Signed-off-by: Don Brace <don.brace@microsemi.com>
> ---

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

