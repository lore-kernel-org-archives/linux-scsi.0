From: Juergen Gross <jgross@suse.com>
Subject: Re: [PATCH] xen/scsifront: use offset_in_page() macro
Date: Mon, 24 Apr 2017 07:05:16 +0200
Message-ID: <ca4bb9e8-b614-a24d-e533-70ce75ff288f@suse.com>
References: <4dbc77ccaaed98b183cf4dba58a4fa325fd65048.1492758503.git.geliangtang@gmail.com>
 <b066ac954374a00bca91fadf3f2d5aba0eb8cb0a.1492758340.git.geliangtang@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46220 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1165076AbdDXFFT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 24 Apr 2017 01:05:19 -0400
In-Reply-To: <b066ac954374a00bca91fadf3f2d5aba0eb8cb0a.1492758340.git.geliangtang@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Geliang Tang <geliangtang@gmail.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: xen-devel@lists.xenproject.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On 22/04/17 03:21, Geliang Tang wrote:
> Use offset_in_page() macro instead of open-coding.
> 
> Signed-off-by: Geliang Tang <geliangtang@gmail.com>

Reviewed-by: Juergen Gross <jgross@suse.com>


Thanks,

Juergen
