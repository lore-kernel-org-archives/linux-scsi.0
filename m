From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 1/2] tcmu: Fix some memory corruption
Date: Wed, 08 Nov 2017 01:43:05 -0800
Message-ID: <1510134185.29624.72.camel@haakon3.daterainc.com>
References: <20171108084344.hmqtb5k2puzh3sc6@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:40284 "EHLO
        linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750818AbdKHJnH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Nov 2017 04:43:07 -0500
In-Reply-To: <20171108084344.hmqtb5k2puzh3sc6@mwanda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Kenjiro Nakayama <nakayamakenjiro@gmail.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, kernel-janitors@vger.kernel.org

On Wed, 2017-11-08 at 11:43 +0300, Dan Carpenter wrote:
> "udev->nl_reply_supported" is an int but on 64 bit arches we are writing
> 8 bytes of data to it so it corrupts four bytes beyond the end of the
> struct.
> 
> Fixes: b849b4567549 ("target: Add netlink command reply supported option for each device")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 

Applied to target-pending/for-next.
