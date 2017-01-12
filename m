From: Robert LeBlanc <robert@leblancnet.us>
Subject: Re: iscsi_trx going into D state
Date: Thu, 12 Jan 2017 14:26:05 -0700
Message-ID: <CAANLjFotqoC8TKGypD2uqoADRq5NxDmXgz-B7THKy_HH_7u9hg@mail.gmail.com>
References: <CAANLjFoj9-qscJOSf2jtKYt2+4cQxMHNJ9q2QTey4wyG5OTSAA@mail.gmail.com>
 <CAANLjFqvtqFu85Aivg6K8XB0rMub03KbBSCq8Kj=Cg+ybxu3pw@mail.gmail.com>
 <CAANLjFpbE9-B8qWtU5nDfg4+t+kD8TSVy0JOfN+zuFYsZ05_Dg@mail.gmail.com>
 <CAANLjFpEpJ4647u9R-7phf68fw--pOfThbp5Sntd4c7DdRSwwQ@mail.gmail.com>
 <CAANLjFooGrt51a9rOy8TKMyXyxBYmGEPm=h1YJm81Nj6YS=5yg@mail.gmail.com>
 <CAANLjFrZrTPUuzP_NjkgG5h_YwwYKEWT-KzVjTvuXZ1d04z6Fg@mail.gmail.com>
 <CAANLjFpSnQ7ApOK5HDRHXQQeQNGWLUv4e+2N=_e-zBeziYm5tw@mail.gmail.com>
 <CAANLjForEkO6RXw7KJYrTJD=f0S8FE73vvwNQcL_ARFdFoDQqg@mail.gmail.com>
 <1030906614.13148012.1483722413675.JavaMail.zimbra@redhat.com>
 <CAANLjFocE2fbO_oWRiEVCt0=mfmgrLy9qWqqg=TH_jZS3PXn0g@mail.gmail.com> <CAANLjFpRCwGSh=HV12dc_OtFKgcjQqERSPirqxWD1w0N-G_mCg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:36232 "EHLO
        mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750760AbdALV12 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Jan 2017 16:27:28 -0500
Received: by mail-oi0-f41.google.com with SMTP id u143so38222441oif.3
        for <linux-scsi@vger.kernel.org>; Thu, 12 Jan 2017 13:26:06 -0800 (PST)
In-Reply-To: <CAANLjFpRCwGSh=HV12dc_OtFKgcjQqERSPirqxWD1w0N-G_mCg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Laurence Oberman <loberman@redhat.com>
Cc: Doug Ledford <dledford@redhat.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Zhu Lingshan <lszhu@suse.com>, linux-rdma <linux-rdma@vger.kernel.org>, linux-scsi@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>, Christoph Hellwig <hch@lst.de>

Sorry sent prematurely...

On Thu, Jan 12, 2017 at 2:22 PM, Robert LeBlanc <robert@leblancnet.us> wrote:
> I'm having trouble replicating the D state issue on Infiniband (I was
> able to trigger it reliably a couple weeks back, I don't know if OFED
> to verify the same results happen there as well.

I'm having trouble replicating the D state issue on Infiniband (I was
able to trigger it reliably a couple weeks back, I don't know if OFED
being installed is altering things but it only installed for 3.10. The
ConnectX-4-LX exposes the issue easily if you have those cards.) to
verify the same results happen there as well.

----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
