From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 08/10] mpt3sas: set EEDP-escape-flags for SAS35 devices.
Date: Tue, 25 Oct 2016 16:42:51 +0200
Message-ID: <c0339732-87af-9dac-c65e-2da94396a3a8@redhat.com>
References: <1476966018-10457-1-git-send-email-suganath-prabu.subramani@broadcom.com>
 <1476966018-10457-9-git-send-email-suganath-prabu.subramani@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38080 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753640AbcJYOmy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Oct 2016 10:42:54 -0400
In-Reply-To: <1476966018-10457-9-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>, JBottomley@Parallels.com, jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, kashyap.desai@broadcom.com, krishnaraddi.mankani@broadcom.com, linux-kernel@vger.kernel.org, chaitra.basappa@broadcom.com, sreekanth.reddy@broadcom.com

On 20.10.2016 14:20, Suganath Prabu S wrote:
> An UNMAP command on a PI formatted device will leave the Logical Block
> Application Tag and Logical Block Reference Tag as all F's (for those LBAs
> that are unmapped). To avoid IO errors if those LBAs are subsequently read
> before they are written with valid tag fields, the MPI SCSI IO requests
> need to set the EEDPFlags element EEDP Escape Mode field, Bits [7:6]
> appropriately. A value of 2 should be set to disable all PI checks if the
> Logical Block Application Tag is 0xFFFF for PI types 1 and 2.  A value
> of 3 should be set to disable all PI checks if the Logical Block
> Application Tag is 0xFFFF and the Logical Block Reference Tag is
> 0xFFFFFFFF for PI type 3.
>
> Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
> Signed-off-by: Sathya Prakash <sathya.prakash@broadcom.com>
> Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas

