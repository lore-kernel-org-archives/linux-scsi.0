From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH V2] scsi_debug: add LBPRZ support
Date: Sat, 10 Mar 2012 19:45:15 +0100
Message-ID: <4F5BA13B.1040409@interlog.com>
References: <4F57C061.9020807@redhat.com> <4F58049C.5010505@interlog.com> <4F584BCF.7030803@redhat.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:40734 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751248Ab2CJSp7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Mar 2012 13:45:59 -0500
In-Reply-To: <4F584BCF.7030803@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, mkp@mkp.net, =?windows-1252?Q?Luk=E1=9A_Czerner?= <lczerner@redhat.com>

On 12-03-08 07:03 AM, Eric Sandeen wrote:
> Add LBPRZ support to scsi_debug; i.e. read zeros for
> unmapped blocks.
>
> Rather than checking for unmapped blocks at
> read time, this just zeroes them on the backing store
> at unmap time so it behaves the same way.
>
> This also adds a module parameter to disable it.
>
> lbprz, "unmapped blocks return 0 on read (def=1)"
>
> Signed-off-by: Eric Sandeen<sandeen@redhat.com>
> ---
>
> V2: set flag in inquiry_evpd_b2() as well, and rename *_zeroes
> type symbols to *_lbprz
>
> note, I didn't change the return value of inquiry_evpd_b2();
> that seems unrelated to this change, and should be a separate
> patch, no?
>
> Thanks,
> -Eric

Acked-by: Douglas Gilbert <dgilbert@interlog.com>
