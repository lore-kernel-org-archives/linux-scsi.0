From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/1] aacraid: big endian issues
Date: Tue, 8 Jan 2008 14:39:29 -0700
Message-ID: <20080108213928.GL16309@parisc-linux.org>
References: <20071031150216.88cecc21.sfr@canb.auug.org.au> <20071101173221.2e1fea42.sfr@canb.auug.org.au> <jefxzqqeha.fsf@sykes.suse.de> <AE4F746F2AECFC4DA4AADD66A1DFEF01F95EF7@otce2k301.adaptec.com> <532ABFBDAAC3A34EB12EBA6CEC2838F40FE734@ADPE2K703.adaptec.com> <532ABFBDAAC3A34EB12EBA6CEC2838F40FE735@ADPE2K703.adaptec.com> <532ABFBDAAC3A34EB12EBA6CEC2838F40FE736@ADPE2K703.adaptec.com> <532ABFBDAAC3A34EB12EBA6CEC2838F40DC65D@ADPE2K703.adaptec.com> <da824cf30801081317q68516370x4a46f9eb80583d28@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:57412 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbYAHVja (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jan 2008 16:39:30 -0500
Content-Disposition: inline
In-Reply-To: <da824cf30801081317q68516370x4a46f9eb80583d28@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Grant Grundler <grundler@google.com>
Cc: "Salyzyn, Mark" <Mark_Salyzyn@adaptec.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Tue, Jan 08, 2008 at 01:17:15PM -0800, Grant Grundler wrote:
> Why apply le32_to_cpu() to the constant instead of the variable?
> On systems were le32_to_cpu() is doing something, can gcc or
> preprocessor optimize the constant?
> I've always assumed it could not but that might be wrong.

$ grep constant_p include/linux/byteorder/*
include/linux/byteorder/swabb.h:(__builtin_constant_p((__u32)(x)) ? \
include/linux/byteorder/swabb.h:(__builtin_constant_p((__u32)(x)) ? \
include/linux/byteorder/swab.h:(__builtin_constant_p((__u16)(x)) ? \
include/linux/byteorder/swab.h:(__builtin_constant_p((__u32)(x)) ? \
include/linux/byteorder/swab.h:(__builtin_constant_p((__u64)(x)) ? \

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
