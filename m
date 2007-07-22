From: "jidong xiao" <jidong.xiao@gmail.com>
Subject: Re: What does scsi_level mean?
Date: Sun, 22 Jul 2007 18:42:14 +0800
Message-ID: <4104961b0707220342k1da5163cl9c3f077cfbe3cc06@mail.gmail.com>
References: <4104961b0707202239i3e4be45asb7b7697b5e366fba@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.180]:51995 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756445AbXGVKmP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Jul 2007 06:42:15 -0400
Received: by py-out-1112.google.com with SMTP id d32so2726811pye
        for <linux-scsi@vger.kernel.org>; Sun, 22 Jul 2007 03:42:14 -0700 (PDT)
In-Reply-To: <4104961b0707202239i3e4be45asb7b7697b5e366fba@mail.gmail.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Any one can kindly explain this?

Thanks
Jason Xiao

On 7/21/07, jidong xiao <jidong.xiao@gmail.com> wrote:
> I noticed that there is a char scsi_level in the struct scsi_device,
> what does scsi_level mean?
>
> struct scsi_device {
> ...
>        char scsi_level;
> ...
> }
>
> Is it SCSI revision?
> If the answer is true, then I am quite curious, from the code I have
> read, SCSI_2 is something special, see following function:
> picked up from drivers/scsi/scsi_sysfs.c:
> int scsi_sysfs_target_initialize(struct scsi_device *sdev){
>                /*
>                 * If there wasn't another lun already configured at
>                 * this target, then default this device to SCSI_2
>                 * until we know better
>                 */
>                sdev->scsi_level = SCSI_2;
> }
>
> Why SCSI_2 could be the default value, why not SCSI_1, why not SCSI_3,
> and etc.Seems SCSI_2 is distinguished from other levels,any reason for
> this?
>
> Thanks
> Jason Xiao
>
