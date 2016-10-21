From: Kashyap Desai <kashyap.desai@broadcom.com>
Subject: RE: [PATCH v2 4/7] megaraid_sas: Send SYNCHRONIZE_CACHE command to firmware
Date: Fri, 21 Oct 2016 19:09:41 +0530
Message-ID: <6837335a4ececfc172e61456afc5b0bd@mail.gmail.com>
References: <4bc9319fb76ad1a7b80df01beef33710@mail.gmail.com> <1477053404.2922.11.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1477053404.2922.11.camel@linux.vnet.ibm.com>
Sender: stable-owner@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>, Sumit Saxena <sumit.saxena@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> > >
> > > Can you please split this into two, so we can backport the bug fix
> > > without any of the feature addition junk?
> >
> > James  - I am sending new patch making two logical fix as you
> > requested. JBOD fix will be marked for CC:stable and for Virtual disk
> > I will post only for head (not for stable). Let me know if resending
> > complete series is good or resending this patch is better.
>
> This is up to Martin, because he has to sort it out, but I think we can
> cope with
> just the two patches.  The bug fix one has to go into the fixes branch for
> immediate application and the rest of the series will go into the misc
> branch for
> the 4.10 merge window.

I resend patch set ( v3 series) . Martin, please use latest resend v3 for
4.10 merge.

Need Reviewed-by tag for below patch as reworked from original submission.
[PATCH v3 3/8] megaraid_sas: Do not fire DCMDs during PCI shutdown/detach
[PATCH v3 4/8] megaraid_sas: Send SYNCHRONIZE_CACHE for non-raid to firmware
[PATCH v3 5/8] megaraid_sas: Send SYNCHRONIZE_CACHE for VD to firmware

>
> James
>
