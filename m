From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 00/17] lpfc updates for 11.4.0.0
Date: Mon, 05 Jun 2017 21:13:36 -0400
Message-ID: <yq14lvtex4v.fsf@oracle.com>
References: <20170602040711.21046-1-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20437 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751192AbdFFBNl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jun 2017 21:13:41 -0400
In-Reply-To: <20170602040711.21046-1-jsmart2021@gmail.com> (James Smart's
        message of "Thu, 1 Jun 2017 21:06:54 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>
Cc: linux-scsi@vger.kernel.org


Hi James,

> This patch set provides a number of bug fixes, code cleanups, and
> error handling in lpfc.
>
> The patches were cut against the Martin's 4.12/scsi-fixes tree.  There
> are no outside dependencies. The patches should merge via Martin's
> tree.

We're approaching rc5 and there are several hundred-liners in this
submission. The EQ delay logic patch in particular looks like a feature
rather than a bug fix.

How many of these are critical to get into 4.12 vs. 4.13?

-- 
Martin K. Petersen	Oracle Linux Engineering
