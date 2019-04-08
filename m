From: Jin Cai <caijin.laurence-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH 1/1] scsi: sd: associate sd_probe_domain with scsi_disk
Date: Mon, 8 Apr 2019 19:58:08 +0800
Message-ID: <CAGRcXKYeDHYMP-KWfWmws3jnPr2AYMgCBpYhX0RcseNVVD=UBw@mail.gmail.com>
References: <1554419045-20873-1-git-send-email-minggr@gmail.com>
 <1554419045-20873-2-git-send-email-minggr@gmail.com> <c30820a9-5d35-c42f-b0a5-8d4ecdac36dd@acm.org>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <open-iscsi+bncBDG73N5U6QNBBP62V3SQKGQEQUT3AJY-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
In-Reply-To: <c30820a9-5d35-c42f-b0a5-8d4ecdac36dd-HInyCGIudOg@public.gmane.org>
List-Post: <https://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/open-iscsi
List-Subscribe: <https://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/open-iscsi/subscribe>
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Ming Lin <minggr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, wangqiang62-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Lee Duncan <lduncan-IBi9RG/b67k@public.gmane.org>, "James E.J. Bottomley" <jejb-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Hi, Bart

    It seems that the commit 21e6ba3 in branch 5.2/scsi-queue has
addressed the deadlock issue we encountered.

    We will backport that patch to our kernel version and verify it
with our test cases.

    Thanks

Best regards




On Sun, Apr 7, 2019 at 12:00 PM Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> wrote:
>
> On 4/4/19 4:04 PM, Ming Lin wrote:
> >       async_synchronize_full_domain(&scsi_sd_pm_domain);
> > -     async_synchronize_full_domain(&scsi_sd_probe_domain);
> > +     async_synchronize_full_domain(&sdkp->sd_probe_domain);
> >       device_del(&sdkp->dev);
> >       del_gendisk(sdkp->disk);
>
> SCSI patches should be prepared against Martin's most recent scsi-queue
> branch. If you have a look at that branch you will see that
> scsi_sd_pm_domain and scsi_sd_probe_domain are gone.
>
> Bart.

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
