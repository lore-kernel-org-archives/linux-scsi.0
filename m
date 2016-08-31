From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 08/17] smartpqi: correct controller offline issue
Date: Wed, 31 Aug 2016 16:15:04 +0200
Message-ID: <528a28ec-0d68-4157-2db0-bcd816fa819b@redhat.com>
References: <147222977996.31214.8588187948847476082.stgit@brunhilda>
 <147222989409.31214.3810017071620268818.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41136 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933214AbcHaOPI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 31 Aug 2016 10:15:08 -0400
In-Reply-To: <147222989409.31214.3810017071620268818.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>, jejb@linux.vnet.ibm.com, Viswas.G@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Kevin.Barnett@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

On 26.8.2016 18:44, Don Brace wrote:
> From: Kevin Barnett <kevin.barnett@microsemi.com>
>
> Fixed a bug where the driver would not free all of the
> controller resources if the controller ever went offline.
>
> Reviewed-by: Scott Teel <scott.teel@microsemi.com>
> Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
> Signed-off-by: Kevin Barnett <kevin.barnett@microsemi.com>
> Signed-off-by: Don Brace <don.brace@microsemi.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

