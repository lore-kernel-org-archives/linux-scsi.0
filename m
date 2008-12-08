From: "Cheng Renquan" <crquan@gmail.com>
Subject: Re: [PATCH 2/2] mpt fusion: port "4.00.43.00" to mainstream git kernel
Date: Mon, 8 Dec 2008 10:51:48 +0800
Message-ID: <91b13c310812071851s5a82d52em63f86f1d3aa42ee9@mail.gmail.com>
References: <1228483610-18502-1-git-send-email-crquan@gmail.com>
	 <1228483610-18502-2-git-send-email-crquan@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.185]:38011 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754092AbYLHCvu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Dec 2008 21:51:50 -0500
Received: by mu-out-0910.google.com with SMTP id g7so926498muf.1
        for <linux-scsi@vger.kernel.org>; Sun, 07 Dec 2008 18:51:48 -0800 (PST)
In-Reply-To: <1228483610-18502-2-git-send-email-crquan@gmail.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Moore <Eric.Moore@lsi.com>
Cc: support@lsi.com, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>, chengrq@uit.com.cn

Hi, all,

I have tested and verified that these two patches can let my LSI-SAS-1068E
controllers work well with 2.6.26.2 kernels, perfect,

Tested-by: Cheng Renquan <crquan@gmail.com>

but the latest git kernel has not yet been tested. just buildable. I
personally suggest these patches integrated into Greg KH's staging
tree. It seems meet staging's purpose well?

The bugzilla page has been updated,

http://bugzilla.kernel.org/show_bug.cgi?id=12163


And the first patch, it's just integrating the vendor driver "4.00.43.00":

Subject:    [PATCH 1/2] mpt fusion: updated mpt drivers from lsi
upstream "4.00.43.00"

http://marc.info/?l=linux-scsi&m=122848357611653&w=2


To LSI staff:
  Please test it as soon, you have the resources. Please maintain your
driver update in latest git kernel besides and not only major
distrition kernels,
  We customers need to run your mpt controllers not only on major
distribution kernels but also the latest git kernel, you should at
least maintain an updated driver for some major later kernels, like
one for 2.6.24, one for 2.6.27, and one for the latest git tree. At
least the driver in the git tree should be always updated, this would
always keep your driver current.
  I'm your customer located in Shenzhen, China. Please know it and
keep co-operative with your customers and the Linux Kernel Development
Community. Thank you.



On Fri, Dec 5, 2008 at 9:26 PM,  <crquan@gmail.com> wrote:
> From: Cheng Renquan <crquan@gmail.com>
>
> this one just can build with mainstream git kernel, I did not even test it.
>
> I just have tested it with kernel 2.6.26.2, that patch is very similar to
> this, and it did work well with 2.6.26.2.
>
> Signed-off-by: Cheng Renquan <crquan@gmail.com>
> ---
>  drivers/message/fusion/linux_compat.h |    3 +-
>  drivers/message/fusion/mptbase.c      |   10 +-
>  drivers/message/fusion/mptbase.h      |    6 +-
>  drivers/message/fusion/mptfc.c        |    4 +-
>  drivers/message/fusion/mptsas.c       |   14 +---
>  drivers/message/fusion/mptscsih.c     |  169 +++++++++++++--------------------
>  drivers/message/fusion/mptscsih.h     |    2 +-
>  7 files changed, 79 insertions(+), 129 deletions(-)
>
[...]
> --
> 1.6.0.3

-- 
Cheng Renquan, Shenzhen, China
Steve Martin  - "I've got to keep breathing. It'll be my worst
business mistake if I don't."
