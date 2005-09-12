From: Andrew Morton <akpm@osdl.org>
Subject: Re: Fw: [OOPS] 2.6.13-mm2 scsi, sata, ich5
Date: Mon, 12 Sep 2005 02:40:27 -0700
Message-ID: <20050912024027.39a1d7be.akpm@osdl.org>
References: <20050911232109.35720176.akpm@osdl.org>
	<6bffcb0e05091202296a07f1ad@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:42906 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751265AbVILJk5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Sep 2005 05:40:57 -0400
In-Reply-To: <6bffcb0e05091202296a07f1ad@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michal.k.k.piotrowski@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org


(re-adding linux-scsi)

Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
>
> Hi,
> 
> On 12/09/05, Andrew Morton <akpm@osdl.org> wrote:
> > 
> > This is a strange trace.   I assume one of the WARN_ON()s in
> > kref_put() has triggered and there's stack stuff missing.   Or
> > Maybe it's an oops under scsi_end_request(), but the oops trace doesn't
> > use show_trace(), whcih that output is from.   But if it's not
> > an oops, why is the Code: dump there.
> > 
> > Head spins.   Michal, can you try to gather another trace?   Is there
> > info missing from this one?
> > 
> > (It's quite possibly a scsi thing rather than a sata thing, btw).
> > 
> 
> The oops always hapen about 3 seconds after system start booting. When
> it hapen I can't see what is up, because shift+pageup doesn't work.
> So, AFAIK the only way to catch that oops is serial console?
> 
> Regards,
> Michal Piotrowski
