From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [scsi:misc 35/39] drivers/scsi/qla2xxx/qla_iocb.c:1972:18:
 sparse: incorrect type in assignment (different base types)
Date: Wed, 26 Aug 2015 14:52:41 -0700
Message-ID: <55DE3529.2020703@sandisk.com>
References: <201508270507.SZtS5QlR%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0056.outbound.protection.outlook.com ([157.56.110.56]:27808
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751967AbbHZVwq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Aug 2015 17:52:46 -0400
In-Reply-To: <201508270507.SZtS5QlR%fengguang.wu@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kbuild test robot <fengguang.wu@intel.com>
Cc: "kbuild-all@01.org" <kbuild-all@01.org>, James Bottomley <JBottomley@Odin.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 08/26/2015 02:04 PM, kbuild test robot wrote:
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git misc
> head:   8d16366b5f23e928e5fd22eaeaceeb0356921fc0
> commit: 118e2ef9df2297147706d21d2a1dfeefea878c5a [35/39] qla2xxx: Avoid that sparse complains about duplicate [noderef] attributes
> reproduce:
>    # apt-get install sparse
>    git checkout 118e2ef9df2297147706d21d2a1dfeefea878c5a
>    make ARCH=x86_64 allmodconfig
>    make C=1 CF=-D__CHECK_ENDIAN__
>
>
> sparse warnings: (new ones prefixed by >>)
>
>>> drivers/scsi/qla2xxx/qla_iocb.c:1972:18: sparse: incorrect type in assignment (different base types)

Hello,

The scope of the patches that just have been queued in James' scsi-misc 
branch is to address the sparse warnings reported without 
CF=-D__CHECK_ENDIAN__. Addressing the endianness warnings in the qla2xxx 
driver is a separate (large) effort. If anyone is volunteering, please 
let me know.

Bart.
