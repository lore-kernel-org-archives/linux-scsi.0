From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] bfa: remove bfa_fcs_mod_s
Date: Mon, 09 Jan 2017 23:35:49 -0500
Message-ID: <yq1tw97cz16.fsf@oracle.com>
References: <1483868475-2949-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47939 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751759AbdAJEf7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jan 2017 23:35:59 -0500
In-Reply-To: <1483868475-2949-1-git-send-email-hch@lst.de> (Christoph
        Hellwig's message of "Sun, 8 Jan 2017 10:41:15 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, anil.gurumurthy@qlogic.com, sudarsana.kalluru@qlogic.com, keescook@chromium.org

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> Just call the functions directly instead of obsfucating the
Christoph> call chain.  This was in reply to a patch from Kees Cook to
Christoph> constify the function pointer struct bfa_fcs_mod_s, but it
Christoph> turns out there is no reason to have this indirection at all.

Applied to 4.11/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
