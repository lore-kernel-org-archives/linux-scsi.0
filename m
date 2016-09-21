From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH] hpsa: correct call to hpsa_do_reset
Date: Wed, 21 Sep 2016 18:55:52 +0200
Message-ID: <6c571a34-1e44-105b-c03a-1fbe047bf066@redhat.com>
References: <147440415020.3922.8978668557368877094.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47756 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934023AbcIUQz4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 21 Sep 2016 12:55:56 -0400
In-Reply-To: <147440415020.3922.8978668557368877094.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>, jejb@linux.vnet.ibm.com, john.hall@microsemi.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

On 20.9.2016 22:42, Don Brace wrote:
> calling fill_cmd() using a MACRO definition not handled in
> switch statement causes BUG() to be called.
>
> Reviewed-by: Scott Teel <scott.teel@microsemi.com>
> Reviewed-by: Kevin Barnett <kevin.barnett@microsemi.com>
> Signed-off-by: Don Brace <don.brace@microsemi.com>

Looks good,
Reviewed-by: Tomas Henzl <thenzl@redhat.com>

