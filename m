From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: TCM/LIO ib_srpt testing
Date: Wed, 18 May 2011 12:19:33 +0200
Message-ID: <BANLkTikyHRsskL+4kbiOUwexJg1Medb+hw@mail.gmail.com>
References: <BANLkTim5inFCXMwnFz=4CHrAmhXMYyMscw@mail.gmail.com> <1305668263.2856.235.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:55392 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755620Ab1ERKTx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 May 2011 06:19:53 -0400
Received: by vws1 with SMTP id 1so971314vws.19
        for <linux-scsi@vger.kernel.org>; Wed, 18 May 2011 03:19:53 -0700 (PDT)
In-Reply-To: <1305668263.2856.235.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Vasilis Liaskovitis <vliaskov@gmail.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>

On Tue, May 17, 2011 at 11:37 PM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
> On Tue, 2011-05-17 at 12:37 +0200, Vasilis Liaskovitis wrote:
> > In the past, using branch tcm_ib_srpt-38, I have successfully
> > initialized the srp target and initiator with the "manual steps" in=
:
> > http://linux-iscsi.org/wiki/SCSI_RDMA_Protocol#Manual_steps
> >
> > However with master, the manual steps fail at:
> > root@server1:~# mkdir -p /sys/kernel/config/target/srpt/mlx4_0/mlx4=
_0/lun/lun_0
> > mkdir: cannot create directory
> > `/sys/kernel/config/target/srpt/mlx4_0': Invalid argument
> > Has the recommended ib_srpt initialization procedure changed recent=
ly?
>
> Yes. =A0In order for ib_srpt to properly work with rtslib+rtsadmin, t=
he
> control plane has been changed from Bart's original patch to referenc=
e
> HW IB Port GUID instead of the symbolic /sys/class/infiniband/ name

Most users expect the original behavior. If you agree I can prepare a
new patch where the target name format can be selected via a kernel
module parameter and in which Christoph Hellwig's recent comments are
addressed too.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
