From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 01/34] scsi proc_ops: add struct
 scsi_host_template::proc_ops
Date: Wed, 29 Feb 2012 16:29:58 -0600
Message-ID: <1330554598.8846.31.camel@dabdike>
References: <1329939985-26793-1-git-send-email-adobriyan@gmail.com>
	 <CACVxJT_veCVyrdEfNoD=r6Aq3Bk5MdjgqXmt0ZxhPzV8nFsW5Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:47984 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964772Ab2B2WaC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Feb 2012 17:30:02 -0500
In-Reply-To: <CACVxJT_veCVyrdEfNoD=r6Aq3Bk5MdjgqXmt0ZxhPzV8nFsW5Q@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-scsi@vger.kernel.org

On Wed, 2012-02-29 at 15:39 +0200, Alexey Dobriyan wrote:
> James, ping!
> 
> Are you going to apply this?

I think so ... I've queued them for inspection and testing (probably
this weekend).

Ideally, I'd have liked some maintainer acks because the changes are
quite invasive, but I'm reasonably OK with pushing them as an
infrastructure change

> If not, what can I do to make them applied?

Well, next time around, a more conformant change log would have been
nice (saves me having to edit every commit).

the form is

[driver]: change

so instead of

scsi proc_ops: convert drivers/scsi/ips.c

it should be

ips: convert to proc_ops

James




