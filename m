From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] bfa: remove bfa_module_s madness
Date: Wed, 19 Apr 2017 22:14:17 -0400
Message-ID: <yq1k26frfk6.fsf@oracle.com>
References: <20170413080256.12451-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51845 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1765900AbdDTCO0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Apr 2017 22:14:26 -0400
In-Reply-To: <20170413080256.12451-1-hch@lst.de> (Christoph Hellwig's message
        of "Thu, 13 Apr 2017 10:02:56 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: martin.petersen@oracle.com, anil.gurumurthy@qlogic.com, sudarsana.kalluru@qlogic.com, keescook@chromium.org, linux-scsi@vger.kernel.org

Christoph Hellwig <hch@lst.de> writes:

> Just call the functions directly and remove a giant pile of
> boilerplate code.

Applied to 4.12/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
