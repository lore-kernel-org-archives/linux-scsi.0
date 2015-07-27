From: Roland Dreier <roland@purestorage.com>
Subject: Re: [PATCH v2 1/8] qla2xxx: kill sessions/log out initiator on RSCN
 and port down events
Date: Mon, 27 Jul 2015 11:09:31 -0700
Message-ID: <CAL1RGDVUgZVsvh9ppP+c4BCbOOncCz=AUsDctYgQzHQVDKsyZw@mail.gmail.com>
References: <1436904049-27707-1-git-send-email-himanshu.madhani@qlogic.com>
 <1436904049-27707-2-git-send-email-himanshu.madhani@qlogic.com> <55B5E725.4020502@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:32985 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbbG0SJw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jul 2015 14:09:52 -0400
Received: by lbbyj8 with SMTP id yj8so59014798lbb.0
        for <linux-scsi@vger.kernel.org>; Mon, 27 Jul 2015 11:09:51 -0700 (PDT)
In-Reply-To: <55B5E725.4020502@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Himanshu Madhani <himanshu.madhani@qlogic.com>, James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-scsi <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>

On Mon, Jul 27, 2015 at 1:09 AM, Hannes Reinecke <hare@suse.de> wrote:
> Hmm? What happened to the original FIXME?
> Is it not required anymore?

Not sure I follow the question.  The original FIXME was "/* FIXME:
Re-enable Global event handling.. */" and this patch indeed re-enables
global event handling.  I don't think it's a separate patch, it's all
part of the same work.

Unless I'm misunderstanding...
