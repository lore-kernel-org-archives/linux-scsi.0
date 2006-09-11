From: "G Shyam Sundar" <callshyam@gmail.com>
Subject: Re: status question - IP over FC for qla2xxx?
Date: Mon, 11 Sep 2006 16:59:47 +0530
Message-ID: <19dce7c30609110429g2f112019lb6bc158213293808@mail.gmail.com>
References: <20060909064916.GF12098@curie-int.orbis-terrarum.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:24239 "EHLO
	nf-out-0910.google.com") by vger.kernel.org with ESMTP
	id S932173AbWIKL3t (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Sep 2006 07:29:49 -0400
Received: by nf-out-0910.google.com with SMTP id o25so1143881nfa
        for <linux-scsi@vger.kernel.org>; Mon, 11 Sep 2006 04:29:48 -0700 (PDT)
In-Reply-To: <20060909064916.GF12098@curie-int.orbis-terrarum.net>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Robin H. Johnson" <robbat2@gentoo.org>
Cc: linux-scsi@vger.kernel.org

Hi,
  The latest qlogic drivers(7.07.05 and 8.01.05) do support IP over FC
for the 2 Gig Cards (so it should work in your case). The driver is
not stable for the 4 Gig cards yet, and if you want to use a 4Gig card
for IPFC, you may have to wait a bit longer. The 2 gig cards work
pretty fine with this driver and I'd recommend that you try it out.

-Shyam



On 9/9/06, Robin H. Johnson <robbat2@gentoo.org> wrote:
> Hi,
>
> I'm trying to establish the status of IPFC (IP over Fibre Channel) for
> the qla2xxx driver (and the QLA2312 chip in my specific deployment).
>
> Researching it, I see that there were some patchsets way back in the
> 2.4.20 days (http://ftp.parisc-linux.org/patches/diff-2.4.20-pa31), but
> I find nothing modern, nor any record of why it was ripped out.
>
> The kernel and -scsi mailing list archives don't even mention IPFC.
>
> This is maybe a question better directed at the network mailing lists,
> but I'm reasonably certain that Ravi Anand and some of the others from
> Qlogic hang out here.
>
> I'm not after IPFC for high bandwidth, just the ability to check
> connectivity without having the HBA binary libraries (my test platform
> has them available, but I don't have that luxury further down the line).
>
> While I'm at it, how's the IP support for other cards? I'm already
> committed to Qlogic here, but I'd appreciate it for future design
> choices.
>
> --
> Robin Hugh Johnson
> E-Mail     : robbat2@gentoo.org
> GnuPG FP   : 11AC BA4F 4778 E3F6 E4ED  F38E B27B 944E 3488 4E85
>
>
>
