From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH] sd: Update thin provisioning support
Date: Thu, 16 Sep 2010 15:23:37 -0400
Message-ID: <AANLkTimvjxdMZuw9-ZNRaUM0H4-Jx3t9TOnMuQ0fX9_r@mail.gmail.com>
References: <yq1zkvqqikg.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40944 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754350Ab0IPTX6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Sep 2010 15:23:58 -0400
Received: by bwz11 with SMTP id 11so1904797bwz.19
        for <linux-scsi@vger.kernel.org>; Thu, 16 Sep 2010 12:23:57 -0700 (PDT)
In-Reply-To: <yq1zkvqqikg.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James.Bottomley@hansenpartnership.com, hch@lst.de, linux-scsi@vger.kernel.org

Hi Martin,

On Fri, Sep 10, 2010 at 1:22 AM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
> Add support for the Thin Provisioning VPD page and use the TPU and TP=
WS
> bits to switch between UNMAP and WRITE SAME(16) for discards. =A0If n=
o TP
> VPD page is present we fall back to old scheme where the max descript=
or
> count combined with the max lba count are used trigger UNMAP.
>
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

Nice to see this version includes the fall back to the old scheme.  Tha=
nks!

Acked-by: Mike Snitzer <snitzer@redhat.com>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
