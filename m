From: Julian Calaby <julian.calaby@gmail.com>
Subject: Re: [PATCH for-next] scsi: qla2xxx: Hide unavailable firmware
Date: Thu, 8 Oct 2015 10:41:30 +1100
Message-ID: <CAGRGNgUBWaxVi6dWG=NAb3t+U_J+EBrV=pgxRmNqKtsKSsEWCg@mail.gmail.com>
References: <1432252831-7551-1-git-send-email-julian.calaby@gmail.com>
 <CAGRGNgVSuMD3B4B0Jr-TOT5Kr4NRvJR=0e3tu71OxUzQtrq2sg@mail.gmail.com> <56153682.1030801@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:34787 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251AbbJGXlu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Oct 2015 19:41:50 -0400
Received: by igcpb10 with SMTP id pb10so3252919igc.1
        for <linux-scsi@vger.kernel.org>; Wed, 07 Oct 2015 16:41:49 -0700 (PDT)
In-Reply-To: <56153682.1030801@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: qla2xxx-upstream@qlogic.com, linux-scsi <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@odin.com>, Linux Firmware Maintainers <linux-firmware@kernel.org>

Hi Xose,

On Thu, Oct 8, 2015 at 2:13 AM, Xose Vazquez Perez
<xose.vazquez@gmail.com> wrote:
> On Fri, May 22, 2015 at 10:00 AM, Julian Calaby <julian.calaby@gmail.com> wrote:
>
>> Some qla2xxx devices have firmware stored in flash on the device,
>> however for debugging and triage purposes, Qlogic staff like to
>> be able to load known-good versions of these firmwares through
>> request_firmware().
>>
>> These firmware files were never distributed and are unlikely to ever
>> be released publically, so to hide these missing firmware files from
>> scripts which check such things, (e.g. Debian's initramfs-tools) put
>> them behind a new EXPERT Kconfig option.
>
>
> What is state of this patch ?

Apparently nobody cared, either from qLogic or linux-scsi.

I'm not overly fussed whether it goes in or not, it was more a point
in the discussion that proceeded it, however it does solve the
problems in the discussion that preceded it.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
