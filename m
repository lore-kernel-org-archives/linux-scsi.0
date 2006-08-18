From: "adam radford" <aradford@gmail.com>
Subject: Re: 3ware driver maximum request size
Date: Fri, 18 Aug 2006 11:46:28 -0700
Message-ID: <b1bc6a000608181146i65700723y7d5971bd891714af@mail.gmail.com>
References: <44E4877F.2070708@xfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:39562 "EHLO
	nf-out-0910.google.com") by vger.kernel.org with ESMTP
	id S1751465AbWHRSq3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Aug 2006 14:46:29 -0400
Received: by nf-out-0910.google.com with SMTP id o25so1357531nfa
        for <linux-scsi@vger.kernel.org>; Fri, 18 Aug 2006 11:46:28 -0700 (PDT)
In-Reply-To: <44E4877F.2070708@xfs.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steve Lord <lord@xfs.org>
Cc: linux-scsi@vger.kernel.org

Steve,

It's capped at 128k per request because that is the max size the firmware
was tested with.  If you increase that number, it is at your own risk, and
you may have problems.

-Adam

On 8/17/06, Steve Lord <lord@xfs.org> wrote:
>
> Does anyone know why the 3ware driver caps I/O at 128K bytes per scsi
> request? The driver defines a scatter gather array which will always
> cope with at least twice this.
>
> I am running with the TW_MAX_SECTORS constant at 512 and getting
> 256K I/Os to a 6+1 raid5 lun on a 9550SX. By my calculations this
> does not exceed the defined sizes of the scatter gather arrays for
> this type of device (but would I guess for the escalade variant
> in the code).
>
> I know nothing about the hardware itself, but if this works it seems
> like a worthwhile change for the newer devices.
>
> Thanks
>
>    Steve Lord
>
>
