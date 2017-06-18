From: Guodong Xu <guodong.xu-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 3/5] arm64: dts: Add ufs dts node
Date: Sun, 18 Jun 2017 15:06:01 +0800
Message-ID: <CAFGCpxwKjvNAj1yVqstBmtxBexwpRrcPo+F3XJP9j-CZhuH0MQ@mail.gmail.com>
References: <20170616065119.10704-4-butao@hisilicon.com> <201706180814.Kte2462z%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201706180814.Kte2462z%fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Bu Tao <butao-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>, kbuild-all-JC7UmRfGjtg@public.gmane.org, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, "xuwei (O)" <xuwei5-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, vinholikatti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, Kevin Hilman <khilman-rdvid1DuHRBWk0Htik3J/w@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Gregory CLEMENT <gregory.clement-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Thomas Petazzoni <thomas.petazzoni-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Masahiro Yamada <yamada.masahiro-uWyLwvC0a2jby3iVrkZq2A@public.gmane.org>, Riku Voipio <riku.voipio-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Thierry Reding <treding-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Krzysztof Kozlowski <krzk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Eric Anholt <eric-WhKQ6XTQaPysTnJN9+BGXg@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TasMV2rI37PzA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, Jun 18, 2017 at 8:31 AM, kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> Hi Bu,
>
> [auto build test ERROR on mkp-scsi/for-next]
> [also build test ERROR on v4.12-rc5 next-20170616]
> [cannot apply to robh/for-next]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
>

It applies to:
 git://github.com/hisilicon/linux-hisi.git tags/hisi-arm64-dt-for-4.13-v2

> url:    https://github.com/0day-ci/linux/commits/Bu-Tao/scsi-ufs-add-ufs-driver-code-for-Hi3660-SoC/20170618-045141
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
> config: arm64-defconfig (attached as .config)
> compiler: aarch64-linux-gnu-gcc (Debian 6.1.1-9) 6.1.1 20160705
> reproduce:
>         wget https://raw.githubusercontent.com/01org/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # save the attached .config to linux build tree
>         make.cross ARCH=arm64
>
> All errors (new ones prefixed by >>):
>
>>> Error: arch/arm64/boot/dts/hisilicon/hi3660.dtsi:152.24-25 syntax error
>    FATAL ERROR: Unable to parse input tree

UFS node has a dependency on clock node <&crg_ctrl ...>, which is
submitted in another patchset [1]. [1] has been Ack'ed by platform
maintainer Wei Xu, and is available in the git repository at:

  git://github.com/hisilicon/linux-hisi.git tags/hisi-arm64-dt-for-4.13-v2

[1] hi3660-hikey960 dts base:
https://www.spinics.net/lists/kernel/msg2533737.html

-Guodong


>
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
