From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [Scst-devel] Fwd: Re: linuxcon 2010...
Date: Fri, 27 Aug 2010 00:11:03 +0400
Message-ID: <4C76CA57.3050405@vlnb.net>
References: <594039.74663.qm@web111905.mail.gq1.yahoo.com>	 <1282144271.3035.31.camel@mulgrave.site>	 <AANLkTinRDMXqyDAVkcbioD=L7XO-47KHL2qjR+8KA5m3@mail.gmail.com>	 <1282148296.3035.49.camel@mulgrave.site> <4C6C1D70.7020502@vlnb.net>	 <41A1E2691BBB412BADCDE5F515CD8EDA@usish.com.cn>	 <8A96806D-6CD7-44AD-8A9D-143C098C95A4@uni-paderborn.de>	 <1282256949.30453.278.camel@haakon2.linux-iscsi.org>	 <4C701E08.2020005@vlnb.net> <1282423398.3015.39.camel@mulgrave.site>	 <4C73DA15.2010207@vlnb.net> <1282661876.2993.20.camel@mulgrave.site>	 <4C7421FB.2060007@vlnb.net> <1282685014.32007.51.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:55193 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931Ab0HZULI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Aug 2010 16:11:08 -0400
In-Reply-To: <1282685014.32007.51.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: James Bottomley <James.Bottomley@suse.de>, Dirk Meister <dmeister@uni-paderborn.de>, linux-scsi@vger.kernel.org, Chetan Loke <chetanloke@gmail.com>, Chetan Loke <generationgnu@yahoo.com>, scst-devel <scst-devel@lists.sourceforge.net>, linux-kernel@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Nicholas A. Bellinger, on 08/25/2010 01:23 AM wrote:
> As mentioned explictly earlier in this thread, my WIP code for the
> kernel level subsystem backstore using STGT kernel<->  user CDB
> passthrough logic in drivers/target/target_core_stgt.c is a item on
> my TODO list, but I will repeat, is NOT being tagged as a mainline
> .37 item.

Hmm, I can't understand, if target_core_stgt.c is "NOT being tagged as a 
mainline .37 item", then the STGT ABI compatibility for being a drop in 
replacement for STGT isn't a requirement? Or am I missing something?

> Tomo-san, mnc, and other storage folks have been briefed on the
> remaining issues that would be involved to get a prototype
> functioning with drivers/target/target_core_stgt.c, and rough idea of
> what it would take in existing mainline drivers/scsi/scsi_tgt_*.c
> code.  With the current WIP code this will allow the userspace CDB ->
> LUN passthrough to function transparently with all TCM SPC-4
> compliant logic as a standalone struct se_subsystem_api
> tcm_core_stgt.ko backstore.

This is exactly what we are discussing.

Thanks,
Vlad
