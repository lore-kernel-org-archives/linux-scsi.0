From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] libsas: move SAM_STAT_CHECK_CONDITION out of switch
Date: Wed, 15 Feb 2012 15:47:08 -0800
Message-ID: <CAA9_cmf2fqobuHqgKPHQ9Eb=MRiGkM=br3=Cfvxpxdn-9L5VyQ@mail.gmail.com>
References: <1329230947-27675-1-git-send-email-danny.kukawka@bisect.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:59706 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756170Ab2BOXrJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Feb 2012 18:47:09 -0500
In-Reply-To: <1329230947-27675-1-git-send-email-danny.kukawka@bisect.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Danny Kukawka <danny.kukawka@bisect.de>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Danny Kukawka <dkukawka@suse.de>, Jeff Garzik <jgarzik@redhat.com>, Sergei Shtylyov <sshtylyov@ru.mvista.com>, Christoph Hellwig <hch@lst.de>, Paul Gortmaker <paul.gortmaker@windriver.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Feb 14, 2012 at 6:49 AM, Danny Kukawka <danny.kukawka@bisect.de=
> wrote:
> Move SAM_STAT_CHECK_CONDITION out of switch to fix:
>
> warning: case value =912=92 not in enumerated type =91enum exec_statu=
s=92
> =A0[-Wswitch]
>
> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>

Thanks Danny.  This warning got killed in the following commit that is
pending in -next.

http://git.kernel.org/?p=3Dlinux/kernel/git/djbw/isci.git;a=3Dcommitdif=
f;h=3D9540580ba80e2b3e61041ec935992a7a7d22ff89

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
