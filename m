From: Kent Overstreet <koverstreet@google.com>
Subject: Re: [LSF/MM TOPIC] Thin provisioning SOFT_THRESHOLD error handling
Date: Tue, 5 Feb 2013 09:07:24 -0800
Message-ID: <CAH+dOxKyRCaJb1Pk6rb6RA435KVRLTWZmVL5REnexmazJ5MKVA@mail.gmail.com>
References: <510784DE.3000509@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qa0-f53.google.com ([209.85.216.53]:65020 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755778Ab3BERH0 (ORCPT
	<rfc822;Linux-scsi@vger.kernel.org>); Tue, 5 Feb 2013 12:07:26 -0500
Received: by mail-qa0-f53.google.com with SMTP id z4so233674qan.5
        for <Linux-scsi@vger.kernel.org>; Tue, 05 Feb 2013 09:07:25 -0800 (PST)
In-Reply-To: <510784DE.3000509@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: lsf-pc@lists.linux-foundation.org, Linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Tue, Jan 29, 2013 at 12:14 AM, Hannes Reinecke <hare@suse.de> wrote:
> Hi all,
>
> Thin-provisioned devices have the ability to set a 'soft threshold', which
> is triggered if the real free space for this device is beyond this mark.
>
> The intention behind this is to allow the system to induce some garbage
> collection with possibly freeing up unused space.
>
> Initially it would be possible to execute garbage collection on filesystems
> (eg for btrfs).
>
> However, as this concept applies to other areas within the kernel
> (like dm-thinp or even btrfs itself) it might be an idea to have
> a general mechanism / error handling etc in place.
>
> I would like to discuss at LSF the possible implementations
> and handling mechanism for this kind of failure scenarios.

Count me in too
