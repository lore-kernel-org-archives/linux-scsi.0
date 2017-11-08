From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 2/2] tcmu: Add a missing unlock on an error path
Date: Wed, 08 Nov 2017 01:43:29 -0800
Message-ID: <1510134209.29624.73.camel@haakon3.daterainc.com>
References: <20171108084415.dn443crpreqwqoiw@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:50038 "EHLO
        linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750818AbdKHJna (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Nov 2017 04:43:30 -0500
In-Reply-To: <20171108084415.dn443crpreqwqoiw@mwanda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Mike Christie <mchristi@redhat.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, kernel-janitors@vger.kernel.org

On Wed, 2017-11-08 at 11:44 +0300, Dan Carpenter wrote:
> We added a new error path here but we forgot to drop the lock first
> before returning.
> 
> Fixes: 0d44374c1aae ("tcmu: fix double se_cmd completion")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied to target-pending/for-next.

Thanks DanC !
