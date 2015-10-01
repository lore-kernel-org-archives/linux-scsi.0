From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH 0/3] scsi: Some miscellaneous fixes
Date: Thu, 1 Oct 2015 19:57:55 +0000
Message-ID: <BY2PR0301MB1654C23980B44BB16A5331DDA04C0@BY2PR0301MB1654.namprd03.prod.outlook.com>
References: <1442528938-3252-1-git-send-email-kys@microsoft.com>
 <87h9md2vui.fsf@vitty.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87h9md2vui.fsf@vitty.brq.redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Vitaly Kuznetsov <vkuznets@redhat.com>, "James E.J. Bottomley" <JBottomley@odin.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "ohering@suse.com" <ohering@suse.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "hch@infradead.org" <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "apw@canonical.com" <apw@canonical.com>, "jasowang@redhat.com" <jasowang@redhat.com>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Vitaly Kuznetsov [mailto:vkuznets@redhat.com]
> Sent: Tuesday, September 29, 2015 6:34 AM
> To: James E.J. Bottomley <JBottomley@odin.com>; KY Srinivasan
> <kys@microsoft.com>
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; ohering@suse.com;
> jbottomley@parallels.com; hch@infradead.org; linux-scsi@vger.kernel.org;
> apw@canonical.com; jasowang@redhat.com
> Subject: Re: [PATCH 0/3] scsi: Some miscellaneous fixes
> 
> "K. Y. Srinivasan" <kys@microsoft.com> writes:
> 
> [...]
> 
> >
> > Vitaly Kuznetsov (2):
> >   scsi_scan: don't dump trace when scsi_prep_async_scan() is called
> >     twice
> >   scsi: introduce short_inquiry flag for broken host adapters
> 
> James,
> 
> I'm sorry for the annoyance but when I asked about these patches last
> time you said we don't have them reviewed. Is it OK now when we have
> signed-off-by: from K. Y. or do we need to ask someone else?

We have tested these patches on various Hyper-V platforms. 

K. Y
> 
> Thanks,
> 
> --
>   Vitaly
