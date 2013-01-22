From: Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: [PATCH RFC 4/9] [SCSI] Rename scsi_evt_xxx to sdev_evt_xxx and
 scsi_event to sdev_event
Date: Tue, 22 Jan 2013 10:33:18 -0700
Message-ID: <CAO+b5-qvyoSA1fSjZC-LLMPmzDUKhoCQTRCvxBe1+u3BgjYMpg@mail.gmail.com>
References: <1358526434-1173-1-git-send-email-emilne@redhat.com>
	<1358526434-1173-5-git-send-email-emilne@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oa0-f47.google.com ([209.85.219.47]:51673 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145Ab3AVRdT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Jan 2013 12:33:19 -0500
Received: by mail-oa0-f47.google.com with SMTP id h1so7406101oag.20
        for <linux-scsi@vger.kernel.org>; Tue, 22 Jan 2013 09:33:18 -0800 (PST)
In-Reply-To: <1358526434-1173-5-git-send-email-emilne@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ewan D. Milne" <emilne@redhat.com>
Cc: linux-scsi@vger.kernel.org

On Fri, Jan 18, 2013 at 9:27 AM, Ewan D. Milne <emilne@redhat.com> wrote:
>
> @@ -2206,7 +2206,7 @@ static void scsi_evt_emit(struct scsi_device *sdev, struct scsi_event *evt)
>   *     Dispatch queued events to their associated scsi_device kobjects
>   *     as uevents.
>   */
> -void scsi_evt_thread(struct work_struct *work)
> +void sdev_evt_thread(struct work_struct *work)
>  {
>         struct scsi_device *sdev;
>         LIST_HEAD(event_list);

This code does not run as a long-living thread so please consider
using the name "sdev_evt_work" instead.

Bart.
