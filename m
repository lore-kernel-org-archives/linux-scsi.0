From: Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [kbuild-all] [target:master 1/2]
 drivers/target/target_core_transport.o: warning: objtool:
 __transport_wait_for_tasks()+0x22: function has unreachable instruction
Date: Wed, 20 Jul 2016 09:13:23 +0800
Message-ID: <20160720011323.GQ17027@wfg-t540p.sh.intel.com>
References: <201607192134.PEDWBapu%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <201607192134.PEDWBapu%fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, kbuild-all-JC7UmRfGjtg@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Hi Nicholas,

Sorry please ignore this one -- it looks like false warning from old
gcc 4.4 and 4.6 -- we just enabled old compiler tests which triggered
10k these warnings..

Thanks,
Fengguang

On Tue, Jul 19, 2016 at 09:43:35PM +0800, kbuild test robot wrote:
>tree:   https://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git master
>head:   39993fc9aebdf68a25134b140447b335a2418a76
>commit: 15ce22fa491aa3bab7acd89ac40a9fc27aeed915 [1/2] target: Fix for hang of Ordered task in TCM
>config: x86_64-randconfig-a0-07191719 (attached as .config)
>compiler: gcc-4.4 (Debian 4.4.7-8) 4.4.7
>reproduce:
>        git checkout 15ce22fa491aa3bab7acd89ac40a9fc27aeed915
>        # save the attached .config to linux build tree
>        make ARCH=x86_64
>
>All warnings (new ones prefixed by >>):
>
>>> drivers/target/target_core_transport.o: warning: objtool: __transport_wait_for_tasks()+0x22: function has unreachable instruction
>
>---
>0-DAY kernel test infrastructure                Open Source Technology Center
>https://lists.01.org/pipermail/kbuild-all                   Intel Corporation


>_______________________________________________
>kbuild-all mailing list
>kbuild-all-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
>https://lists.01.org/mailman/listinfo/kbuild-all

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
