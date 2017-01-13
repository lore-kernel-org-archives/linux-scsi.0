From: Laurence Oberman <loberman@redhat.com>
Subject: Re: iscsi_trx going into D state
Date: Fri, 13 Jan 2017 10:10:14 -0500 (EST)
Message-ID: <1449740553.15880491.1484320214006.JavaMail.zimbra@redhat.com>
References: <CAANLjFoj9-qscJOSf2jtKYt2+4cQxMHNJ9q2QTey4wyG5OTSAA@mail.gmail.com> <CAANLjFrZrTPUuzP_NjkgG5h_YwwYKEWT-KzVjTvuXZ1d04z6Fg@mail.gmail.com> <CAANLjFpSnQ7ApOK5HDRHXQQeQNGWLUv4e+2N=_e-zBeziYm5tw@mail.gmail.com> <CAANLjForEkO6RXw7KJYrTJD=f0S8FE73vvwNQcL_ARFdFoDQqg@mail.gmail.com> <1030906614.13148012.1483722413675.JavaMail.zimbra@redhat.com> <CAANLjFocE2fbO_oWRiEVCt0=mfmgrLy9qWqqg=TH_jZS3PXn0g@mail.gmail.com> <CAANLjFpRCwGSh=HV12dc_OtFKgcjQqERSPirqxWD1w0N-G_mCg@mail.gmail.com> <CAANLjFotqoC8TKGypD2uqoADRq5NxDmXgz-B7THKy_HH_7u9hg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx6-phx2.redhat.com ([209.132.183.39]:56023 "EHLO
        mx6-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751841AbdAMPK1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Jan 2017 10:10:27 -0500
In-Reply-To: <CAANLjFotqoC8TKGypD2uqoADRq5NxDmXgz-B7THKy_HH_7u9hg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert LeBlanc <robert@leblancnet.us>
Cc: Doug Ledford <dledford@redhat.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Zhu Lingshan <lszhu@suse.com>, linux-rdma <linux-rdma@vger.kernel.org>, linux-scsi@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>, Christoph Hellwig <hch@lst.de>



----- Original Message -----
> From: "Robert LeBlanc" <robert@leblancnet.us>
> To: "Laurence Oberman" <loberman@redhat.com>
> Cc: "Doug Ledford" <dledford@redhat.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, "Zhu Lingshan"
> <lszhu@suse.com>, "linux-rdma" <linux-rdma@vger.kernel.org>, linux-scsi@vger.kernel.org, "Sagi Grimberg"
> <sagi@grimberg.me>, "Christoph Hellwig" <hch@lst.de>
> Sent: Thursday, January 12, 2017 4:26:05 PM
> Subject: Re: iscsi_trx going into D state
> 
> Sorry sent prematurely...
> 
> On Thu, Jan 12, 2017 at 2:22 PM, Robert LeBlanc <robert@leblancnet.us> wrote:
> > I'm having trouble replicating the D state issue on Infiniband (I was
> > able to trigger it reliably a couple weeks back, I don't know if OFED
> > to verify the same results happen there as well.
> 
> I'm having trouble replicating the D state issue on Infiniband (I was
> able to trigger it reliably a couple weeks back, I don't know if OFED
> being installed is altering things but it only installed for 3.10. The
> ConnectX-4-LX exposes the issue easily if you have those cards.) to
> verify the same results happen there as well.
> 
> ----------------
> Robert LeBlanc
> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

I am only back in the office next Wednesday.
I have this all setup using ConnectX-4 with IB/ISER but have no way of remotely creating the disconnect as I currently have it back-to-back.
Have run multiple tests with IB and ISER hard resting the client to break the IB connection but have not been able to reproduce as yet.
So it will have to wait until I can pull cables next week as that seemed to be the way you have been reproducing this.

This is in a code area I also don't have a lot of knowledge of the flow but have started trying to understand it better.

Thanks
Laurence
 
