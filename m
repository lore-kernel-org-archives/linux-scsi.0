From: Don Brace <brace77070@gmail.com>
Subject: Re: [PATCH 19/21] hpsa: enhance device messages
Date: Mon, 26 Oct 2015 08:36:00 -0500
Message-ID: <562E2C40.1030504@pmcs.com>
References: <201510250406.gGhioqiY%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:35009 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872AbbJZNgC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Oct 2015 09:36:02 -0400
Received: by obctp1 with SMTP id tp1so115115893obc.2
        for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2015 06:36:01 -0700 (PDT)
In-Reply-To: <201510250406.gGhioqiY%fengguang.wu@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kbuild test robot <lkp@intel.com>
Cc: kbuild-all@01.org, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com, linux-scsi@vger.kernel.org

On 10/24/2015 03:19 PM, kbuild test robot wrote:
> Hi Don,
>
> [auto build test ERROR on scsi/for-next -- if it's inappropriate base, please suggest rules for selecting the more suitable base]
>
> url:    https://github.com/0day-ci/linux/commits/Don-Brace/hpsa-updates/20151025-040012
> config: x86_64-randconfig-x017-201543 (attached as .config)
> reproduce:
>          # save the attached .config to linux build tree
>          make ARCH=x86_64
>
> All error/warnings (new ones prefixed by >>):
>
>     drivers/scsi/hpsa.c: In function 'hpsa_show_dev_msg':
>>> drivers/scsi/hpsa.c:1182:2: error: expected expression before 'if'
>       if (dev == NULL)
>       ^
>>> drivers/scsi/hpsa.c:1181:75: warning: left-hand operand of comma expression has no effect [-Wunused-value]
>         "scsi %d:%d:%d:%d: %s %s %.8s %.16s %s SSDSmartPathCap%c En%c Exp=%d\n",
>                                                                                ^
>
> vim +/if +1182 drivers/scsi/hpsa.c
>
> 4e3d7818 Don Brace 2015-10-24  1175  		break;
> 4e3d7818 Don Brace 2015-10-24  1176  	default:
> 4e3d7818 Don Brace 2015-10-24  1177  		snprintf(label, LABEL_SIZE, "UNKNOWN");
> 4e3d7818 Don Brace 2015-10-24  1178  		break;
> 4e3d7818 Don Brace 2015-10-24  1179  	}
> 4e3d7818 Don Brace 2015-10-24  1180
> 4e3d7818 Don Brace 2015-10-24 @1181  			"scsi %d:%d:%d:%d: %s %s %.8s %.16s %s SSDSmartPathCap%c En%c Exp=%d\n",
> c59f371e Don Brace 2015-10-24 @1182  	if (dev == NULL)
> c59f371e Don Brace 2015-10-24  1183  		return;
> c59f371e Don Brace 2015-10-24  1184
> c59f371e Don Brace 2015-10-24  1185  	dev_warn(&h->pdev->dev,
>
> :::::: The code at line 1182 was first introduced by commit
> :::::: c59f371efab30f7066af482dc6a1b1cfddd562f0 hpsa: correct calls to dev_printk
>
> :::::: TO: Don Brace <don.brace@pmcs.com>
> :::::: CC: 0day robot <fengguang.wu@intel.com>
>
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

Wow. I had a merge conflict that kdiff3 auto-resolved.
Sorry about that. Anyone else ever have that happen?

I'll send out v1 soon.

Thanks
