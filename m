From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 3/3] hpsa: do not timeout reset operations
Date: Fri, 10 Mar 2017 14:30:35 +0100
Message-ID: <62c54514-975b-2e23-27b7-9cccfa7e9268@redhat.com>
References: <148883542370.14177.274248778005931414.stgit@brunhilda>
 <148883549163.14177.17863155040436147975.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57002 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933821AbdCJNay (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 10 Mar 2017 08:30:54 -0500
In-Reply-To: <148883549163.14177.17863155040436147975.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>, joseph.szczypek@hpe.com, gerry.morong@microsemi.com, john.hall@microsemi.com, jejb@linux.vnet.ibm.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

On 6.3.2017 22:24, Don Brace wrote:
> resets can take longer than DEFAULT_TIMEOUT
>
> Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
> Reviewed-by: Scott Teel <scott.teel@microsemi.com>
> Signed-off-by: Don Brace <don.brace@microsemi.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>
tomash
