From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH 01/34] scsi proc_ops: add struct scsi_host_template::proc_ops
Date: Wed, 29 Feb 2012 15:39:50 +0200
Message-ID: <CACVxJT_veCVyrdEfNoD=r6Aq3Bk5MdjgqXmt0ZxhPzV8nFsW5Q@mail.gmail.com>
References: <1329939985-26793-1-git-send-email-adobriyan@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43261 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757978Ab2B2Nju (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Feb 2012 08:39:50 -0500
Received: by iagj37 with SMTP id j37so2664019iag.19
        for <linux-scsi@vger.kernel.org>; Wed, 29 Feb 2012 05:39:50 -0800 (PST)
In-Reply-To: <1329939985-26793-1-git-send-email-adobriyan@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>

James, ping!

Are you going to apply this?
If not, what can I do to make them applied?

On Wed, Feb 22, 2012 at 10:45 PM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> The last user of ->write_proc interface is scsi_proc.c passing through
> data to individual drivers. There are still quite a few drivers using
> ->proc_info interface, so do conversion gradually.
>
> Introduce temporary logic allowing both ->proc_info and ->proc_ops
> with ->proc_ops being the first thing to check, convert drivers,
> remove ->proc_info interface.
>
> Removing all relevant SCSI proc files is risky because it'd take only one
> broken user to revert whole thing and do it right.
