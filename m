From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 01/13] lpfc: Rework lpfc to allow different sli4 cq and eq handlers
Date: Tue, 06 Feb 2018 19:26:23 -0500
Message-ID: <yq1mv0l3as0.fsf@oracle.com>
References: <20180126193113.29610-1-jsmart2021@gmail.com>
        <20180126193113.29610-2-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:40160 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932106AbeBGA3g (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Feb 2018 19:29:36 -0500
In-Reply-To: <20180126193113.29610-2-jsmart2021@gmail.com> (James Smart's
        message of "Fri, 26 Jan 2018 11:31:01 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>
Cc: linux-scsi@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>


James,

I was on the verge of applying this as well but saw that you intended a
re-spin. Found a few typos while poring over these patches:

> Prepare the code for new hardwre by creating a sli4-based callout

hardware

> table that can be set based on if_type.

-- 
Martin K. Petersen	Oracle Linux Engineering
