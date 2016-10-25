From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 07/10] mpt3sas: Increased/Additional MSIX support for
 SAS35 devices.
Date: Tue, 25 Oct 2016 16:41:45 +0200
Message-ID: <3db63ff0-19cb-082c-5479-ae1664fba72e@redhat.com>
References: <1476966018-10457-1-git-send-email-suganath-prabu.subramani@broadcom.com>
 <1476966018-10457-8-git-send-email-suganath-prabu.subramani@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57992 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751804AbcJYOlt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Oct 2016 10:41:49 -0400
In-Reply-To: <1476966018-10457-8-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>, JBottomley@Parallels.com, jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, kashyap.desai@broadcom.com, krishnaraddi.mankani@broadcom.com, linux-kernel@vger.kernel.org, chaitra.basappa@broadcom.com, sreekanth.reddy@broadcom.com

On 20.10.2016 14:20, Suganath Prabu S wrote:
> For SAS35 devices MSIX vectors are inceased to 128 from 96. To support this
> Reply post host index register count is increased to 16. Also variable
> msix96_vector is replaced with combined_reply_queue and variable
> combined_reply_index_count is added to set different values for SAS3 and
> SAS35 devices.
>
> Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
> Signed-off-by: Sathya Prakash <sathya.prakash@broadcom.com>
> Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas

