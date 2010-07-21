From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 13/27] scsi: remove superfluous NULL pointer check from
 scsi_kill_request()
Date: Wed, 21 Jul 2010 10:21:41 -0700
Message-ID: <20100721102141.11311841.akpm@linux-foundation.org>
References: <201007202228.o6KMSrU1021751@imap1.linux-foundation.org>
	<201007211307.15762.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33962 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753069Ab0GURWB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Jul 2010 13:22:01 -0400
In-Reply-To: <201007211307.15762.bzolnier@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, corbet@lwn.net, error27@gmail.com, eteo@redhat.com

On Wed, 21 Jul 2010 13:07:15 +0200 Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:

> This one may be dropped as after almost a year of trying to get it
> merged [1] it seems that an added complexity of the patch is not worth
> the potential gains (although I can't tell for sure since feedback has
> been always 'minimal').

There's nothing wrong with the patch - the problem lies elsewhere.

For 2.6.36-rc1 I'll re-review these scsi patches and will directly
merge those which still look good to me.
