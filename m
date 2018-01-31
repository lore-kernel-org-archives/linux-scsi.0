From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Sorry about all the patch dropped email noise
Date: Wed, 31 Jan 2018 10:10:58 -0800
Message-ID: <1517422258.3937.75.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:59332 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751581AbeAaSK7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 31 Jan 2018 13:10:59 -0500
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 587B98EE16F
        for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2018 10:10:59 -0800 (PST)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id MWUoFa4lANq4 for <linux-scsi@vger.kernel.org>;
        Wed, 31 Jan 2018 10:10:59 -0800 (PST)
Received: from [153.66.254.194] (unknown [50.35.65.221])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id F3F758EE0BF
        for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2018 10:10:58 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

If you received it, just ignore it.  I didn't initialize my fixes tree
correctly before pulling in Martin's branch, so it wrongly sent a patch
dropped email for every patch in the misc tree (which has already been
routed to Linus).

James
