From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH RFC 4/9] [SCSI] Rename scsi_evt_xxx to sdev_evt_xxx and
 scsi_event to sdev_event
Date: Wed, 23 Jan 2013 16:08:51 -0500
Message-ID: <1358975331.4420.370.camel@localhost.localdomain>
References: <1358526434-1173-1-git-send-email-emilne@redhat.com>
	 <1358526434-1173-5-git-send-email-emilne@redhat.com>
	 <CAO+b5-qvyoSA1fSjZC-LLMPmzDUKhoCQTRCvxBe1+u3BgjYMpg@mail.gmail.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51156 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899Ab3AWVIx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Jan 2013 16:08:53 -0500
In-Reply-To: <CAO+b5-qvyoSA1fSjZC-LLMPmzDUKhoCQTRCvxBe1+u3BgjYMpg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: linux-scsi@vger.kernel.org

On Tue, 2013-01-22 at 10:33 -0700, Bart Van Assche wrote:
> On Fri, Jan 18, 2013 at 9:27 AM, Ewan D. Milne <emilne@redhat.com> wrote:
> >
> > @@ -2206,7 +2206,7 @@ static void scsi_evt_emit(struct scsi_device *sdev, struct scsi_event *evt)
> >   *     Dispatch queued events to their associated scsi_device kobjects
> >   *     as uevents.
> >   */
> > -void scsi_evt_thread(struct work_struct *work)
> > +void sdev_evt_thread(struct work_struct *work)
> >  {
> >         struct scsi_device *sdev;
> >         LIST_HEAD(event_list);
> 
> This code does not run as a long-living thread so please consider
> using the name "sdev_evt_work" instead.

Good idea.  I'll do that.

> 
> Bart.


