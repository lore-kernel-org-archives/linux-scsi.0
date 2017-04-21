From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3] scsi/bfa: use designated initializers
Date: Fri, 21 Apr 2017 10:13:27 -0400
Message-ID: <yq18tmtn914.fsf@oracle.com>
References: <20170420220002.GA65324@beast>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51935 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1040523AbdDUONo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Apr 2017 10:13:44 -0400
In-Reply-To: <20170420220002.GA65324@beast> (Kees Cook's message of "Thu, 20
        Apr 2017 15:00:02 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Christoph Hellwig <hch@lst.de>, Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Kees Cook <keescook@chromium.org> writes:

Kees,

> Prepare to mark sensitive kernel structures for randomization by
> making sure they're using designated initializers. This also
> initializes the array members using the enum used to look up
> __port_action entries.

Applied to 4.12/scsi-queue.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
