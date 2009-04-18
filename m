From: Grant Grundler <grundler@google.com>
Subject: Re: LSF Papers online?
Date: Fri, 17 Apr 2009 21:06:59 -0700
Message-ID: <da824cf30904172106j66b4b76eu8da80b8fe9816d77@mail.gmail.com>
References: <49E335BA.3020103@panasas.com>
	 <da824cf30904161436y1a886789mdb05f38a850c5b46@mail.gmail.com>
	 <yq1eivrx51n.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:43381 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbZDREHI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Apr 2009 00:07:08 -0400
Received: from spaceape10.eur.corp.google.com (spaceape10.eur.corp.google.com [172.28.16.144])
	by smtp-out.google.com with ESMTP id n3I472nK030885
	for <linux-scsi@vger.kernel.org>; Sat, 18 Apr 2009 05:07:03 +0100
Received: from yx-out-2324.google.com (yxm8.prod.google.com [10.190.4.8])
	by spaceape10.eur.corp.google.com with ESMTP id n3I470oQ011664
	for <linux-scsi@vger.kernel.org>; Fri, 17 Apr 2009 21:07:00 -0700
Received: by yx-out-2324.google.com with SMTP id 8so45566yxm.89
        for <linux-scsi@vger.kernel.org>; Fri, 17 Apr 2009 21:07:00 -0700 (PDT)
In-Reply-To: <yq1eivrx51n.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Zach Brown <zach.brown@oracle.com>, Chris Mason <chris.mason@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Tejun Heo <tj@kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Thu, Apr 16, 2009 at 9:44 PM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>>>>>> "Grant" =3D=3D Grant Grundler <grundler@google.com> writes:
>
> Grant> =C2=A0 =C2=A0 http://iou.parisc-linux.org/lsf2009/tripreport.t=
xt
>
> Just a correction to your 4KB sector support minutes:
>
> READ CAPACITY(16) does report the actual alignment. =C2=A0The same is=
 true
> for ATA IDENTIFY. =C2=A0The reporting method is slightly different be=
tween
> the two protocols but the net result is the same.

=46ixed - thanks!
grant
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
