From: Julian Calaby <julian.calaby@gmail.com>
Subject: Re: [PATCH 13/25] scsi: hisi_sas: add path from phyup irq to SAS framework
Date: Tue, 13 Oct 2015 11:27:05 +1100
Message-ID: <CAGRGNgVq_cKkWOC9hXH7kdkLw24atXB3+vqQMwpiLj63=oaS-Q@mail.gmail.com>
References: <1444663237-238302-14-git-send-email-john.garry@huawei.com> <201510130540.gVjgsIWc%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:36556 "EHLO
	mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009AbbJMA1Z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Oct 2015 20:27:25 -0400
In-Reply-To: <201510130540.gVjgsIWc%fengguang.wu@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kbuild test robot <lkp@intel.com>, kbuild-all@01.org
Cc: John Garry <john.garry@huawei.com>, Jej B <James.Bottomley@hansenpartnership.com>, linux-kernel@vger.kernel.com, devicetree <devicetree@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, linuxarm@huawei.com, zhangfei.gao@linaro.org, linux-scsi <linux-scsi@vger.kernel.org>, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, Hannes Reinecke <hare@suse.de>

Hi kbuild test robot people,

On Tue, Oct 13, 2015 at 9:03 AM, kbuild test robot <lkp@intel.com> wrote:
> Hi John,
>
> [auto build test WARNING on scsi/for-next -- if it's inappropriate base, please suggest rules for selecting the more suitable base]
>
> url:    https://github.com/0day-ci/linux/commits/John-Garry/HiSilicon-SAS-driver/20151012-231929
> reproduce:
>         # apt-get install sparse
>         make ARCH=x86_64 allmodconfig
>         make C=1 CF=-D__CHECK_ENDIAN__
>
>
> sparse warnings: (new ones prefixed by >>)

Your script seems to have lost the actual warnings here.

> Please review and possibly fold the followup patch.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
