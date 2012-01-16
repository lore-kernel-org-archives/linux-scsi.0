From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [GIT PATCH v4 0/2] libsas: eh reworks (ata-eh vs discovery,
 races, ...)
Date: Mon, 16 Jan 2012 12:44:14 -0800
Message-ID: <CAA9_cmcJ7vnc1xq_3s1UU+nEF+bHS+O+xc65m3Mim6bWs1uTDQ@mail.gmail.com>
References: <20120110073647.4563.7504.stgit@localhost6.localdomain6>
	<1326223752.3264.43.camel@dabdike.int.hansenpartnership.com>
	<CABE8wwuBN45f2s-bcW3R=5VE1V3svtcrp93-9LW5zZ6VtZFqmQ@mail.gmail.com>
	<1326703228.2872.5.camel@dabdike>
	<1326733212.2548.3.camel@ultramagnus.opencreations.com>
	<1326745447.2872.28.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:44447 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756401Ab2APUoP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Jan 2012 15:44:15 -0500
In-Reply-To: <1326745447.2872.28.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, jack_wang@usish.com

On Mon, Jan 16, 2012 at 12:24 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>> I managed to confuse things by posting only incremental series... the
>> full set is in git, and I can repost as needed.
>
> Well, no, when I asked you said the libsas series was pending rewrite.
> Specifically
>
> [PATCH v3 03/14] libsas: prevent domain rediscovery competing with ata
> error handling
>
> I think ... have you reposted that?
>

Well, only in incremental diff form (at the start of this thread).
Let me go ahead repost v4 and include the patches that got refreshed.

...and we can leave off the regression fixes from v5 till post -rc1 I assume.

--
Dan
