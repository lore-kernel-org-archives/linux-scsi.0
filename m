From: Mike Snitzer <snitzer@gmail.com>
Subject: Re: [PATCH 0/4] notify userspace of offline->running transitions (v2)
Date: Tue, 26 Jun 2012 17:48:48 -0400
Message-ID: <CAMM=eLf++hxwoF9fiPU1fu4vB0KmH15h1H9gkJPbO_Q0j+GREg@mail.gmail.com>
References: <1337317019-12001-1-git-send-email-michaelc@cs.wisc.edu> <4FCFC934.8010009@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:59875 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393Ab2FZVtK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jun 2012 17:49:10 -0400
Received: by lbbgm6 with SMTP id gm6so666398lbb.19
        for <linux-scsi@vger.kernel.org>; Tue, 26 Jun 2012 14:49:09 -0700 (PDT)
In-Reply-To: <4FCFC934.8010009@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

On Wed, Jun 6, 2012 at 5:18 PM, Mike Christie <michaelc@cs.wisc.edu> wrote:
> Hey,
>
> Would it be ok to still merge patches 1 - 3? I think they are still
> useful on their own. They fix that issue where during fast io
> fail/replacement_timeout failures IO is failed, but the scsi_device
> state indicates the devices are still running.
>
> It seems Hannes was ok with them right?
>
> Drop patch 4 since we all seemed to agree we will do it a different way.

Hannes, James,

Please advise on including patches 1 -> 3 during the 3.6 merge.

Thanks,
Mike
