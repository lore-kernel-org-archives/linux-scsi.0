From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 09/17] smartpqi: correct event acknowledgment timeout
 issue
Date: Wed, 31 Aug 2016 16:43:38 +0200
Message-ID: <68eabf6e-618d-8a14-8636-6443d72fdf77@redhat.com>
References: <147222977996.31214.8588187948847476082.stgit@brunhilda>
 <147222990010.31214.2025743657616417732.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58376 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935144AbcHaOnl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 31 Aug 2016 10:43:41 -0400
In-Reply-To: <147222990010.31214.2025743657616417732.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>, jejb@linux.vnet.ibm.com, Viswas.G@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Kevin.Barnett@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

On 26.8.2016 18:45, Don Brace wrote:
> From: Kevin Barnett <kevin.barnett@microsemi.com>
>
> the driver no longer waits for the firmware to consume
> the event ack IU.
>
> Reviewed-by: Scott Teel <scott.teel@microsemi.com>
> Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
> Signed-off-by: Kevin Barnett <kevin.barnett@microsemi.com>
> Signed-off-by: Don Brace <don.brace@microsemi.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

