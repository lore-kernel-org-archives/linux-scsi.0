From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 1/6] qla2xxx: Only allow operational MBX to proceed
 during RESET.
Date: Mon, 5 Dec 2016 08:01:57 -0800
Message-ID: <20161205160157.GA11206@infradead.org>
References: <1480715097-13611-1-git-send-email-himanshu.madhani@cavium.com>
 <1480715097-13611-2-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44932 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751039AbcLEQCA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Dec 2016 11:02:00 -0500
Content-Disposition: inline
In-Reply-To: <1480715097-13611-2-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org

Can you describe the changes in the body a bit more?  Why do you
only want these commands to be sent?  Why is the warning added
when it takes longer than nessecary?  Otherwise this patch
looks fine to me.
