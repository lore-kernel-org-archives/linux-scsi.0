Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794270951;
	b=UvL/YHk0Ga02ZAJz2c6TLIPnz3NP8+4CUu/Azd8zyeoN1XyeppMFa25FlsHDH/0/NWN/
	 37lqXV8wVt7s3xtdE7MBQA3E7nMg+9V0FCTUDhZx/f3obtjodAyHAGOvhLI94ZZ/SLpyR
	 5PfdESWMsVjuFes1acfb6hJHpBZcQf1ipqfthKXp+Vlyra8eN3FT+pRIOk2tkjJZi9hZf
	 kVDII9ma0/mjoXCuskU/iKnacICdc6NUNzfLXrlwos8B5Myk93EO+/jyNhWzlliyGS7jz
	 h/aE6MHYBW1EFGyK/S6EpKX7B7Aq/ojbP2FcavwBGvP2+alEVrpveuIobdv0xL96VnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794270951;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:Content-Transfer-Encoding:In-Reply-To;
	bh=I1Cw3ZoxmSAJzaDBuoQ87U0eYP8SSK99naonS/OmSmU=;
	b=fR7L9rtVsr4gdw22VLyW8E3LY4t5RCXBFrDRFkKmZq/1xD6waeKUJBqA1LFwzpu0sK7E
	 FmFIqpcDQqdIr1brTJ9YRCd5nomH5JDR/+N0AUPw/gWGapwlaNLH+JWxx8Bn2aa3IAbKH
	 bTJUTIBv7GEYsgGNJ6Im0fC04o6m/pAHfwb2ur1alCA20jYqzQuNdgkgpjdsRZnz4ip6o
	 W/QgrBJO3JB3MIOVi2W/vefq3xQpSMPdOoKL21I7UAmC9VWR/A3AoAt2Aq5xsDb8Hjyyr
	 e08xKRmWJ8s/ayp+w6SidujKIKkXP8HeSSOHC7M+AGa0paAecs5FVInuz8/u7cF4yAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=il4JdFAg;
	arc=none smtp.remote-ip=198.175.65.14
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5301E606A32A;
	Tue, 10 Nov 2026 00:35:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5301E606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=il4JdFAg
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794270951; x=1825806951;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=5q6GQndC+NFUHcCSRf9aZxmvO/DSxUMmi0ovrumTT6A=;
  b=il4JdFAgWWGlGaa/Qu0J/suor4f5xIPptV2kg/PSTSveiMAMRYbGLaMa
   j/y3cRYxjU359M+INQd/Atsns2fGVIGu18Ua+MdHKQV5rkLUGS6luawF3
   Nzn9ZAxqpl8uZp5kKFQjktspLhBLQU7Oo2o4R9RBvf4LrTT/U2BkSwESg
   y9uNJXIMY2kvaBQF2zHrw2B4ZM/+A7tu/1fwaYWp4ebYwzLrmMpMQ95xC
   bT54otvMj4XoCuMRbHt+TmIU2RA3TJ8g791i5qZ0hXbdvFqaEKjSVafPK
   vW4ARaDCCIpsdtVHyL5JHPOgTn11LiehmW3Xazr2L6fq04lg6VEuzypij
   g==;
X-CSE-ConnectionGUID: IO6Vrmx7SUCrekYc9L5zUg==
X-CSE-MsgGUID: DjguNvIDROG1Iv/WRob1gg==
X-IronPort-AV: E=McAfee;i="6800,10657,11961"; a="2899943"
X-IronPort-AV: E=Sophos;i="6.27,204,1787036400"; 
   d="scan'208";a="2899943"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2026 16:35:51 -0800
X-CSE-ConnectionGUID: sKXdmChySgC0LQPhZyro7A==
X-CSE-MsgGUID: NngWVEzQR9iAH9NEKm5K7w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,204,1787036400"; 
   d="scan'208";a="8140979"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 09 Nov 2026 16:35:49 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xQZpy-00000000vdX-04Jo;
	Tue, 10 Nov 2026 00:35:46 +0000
Date: Tue, 10 Nov 2026 08:35:41 +0800
From: kernel test robot <lkp@intel.com>
To: =?iso-8859-1?Q?Adri=E1n_Garc=EDa?= Casado <adriangarciacasado42@gmail.com>,
	Nilesh Javali <njavali@marvell.com>,
	Manish Rangankar <mrangankar@marvell.com>,
	"Martin K . Petersen" <mkp@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev, GR-ETH-Storage-Upstream@marvell.com,
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	=?iso-8859-1?Q?Adri=E1n_Garc=EDa?= Casado <adriangarciacasado42@gmail.com>
Subject: Re: [PATCH] scsi: qedi: Add __printf to debug helpers and fix format
 strings
Message-ID: <202611100825.B5pebp4Q-lkp@intel.com>
References: <20261109141738.1624579-1-adriangarciacasado42@gmail.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20261109141738.1624579-1-adriangarciacasado42@gmail.com>

Hi Adri=E1n,

kernel test robot noticed the following build warnings:

[auto build test WARNING on jejb-scsi/for-next]
[also build test WARNING on mkp-scsi/for-next linus/master v7.4-rc2 next-20=
261109]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Adri-n-Garc-a-Casado=
/scsi-qedi-Add-__printf-to-debug-helpers-and-fix-format-strings/20261109-15=
1738
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-n=
ext
patch link:    https://lore.kernel.org/r/20261109141738.1624579-1-adriangar=
ciacasado42%40gmail.com
patch subject: [PATCH] scsi: qedi: Add __printf to debug helpers and fix fo=
rmat strings
config: csky-allmodconfig (https://download.01.org/0day-ci/archive/20261110=
/202611100825.B5pebp4Q-lkp@intel.com/config)
compiler: csky-linux-gcc (GCC) 16.2.0
reproduce (this is a W=3D1 build): (https://download.01.org/0day-ci/archive=
/20261110/202611100825.B5pebp4Q-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new versio=
n of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611100825.B5pebp4Q-lkp@i=
ntel.com/

All warnings (new ones prefixed by >>):

   In file included from drivers/scsi/qedi/qedi.h:19,
                    from drivers/scsi/qedi/qedi_main.c:27:
   drivers/scsi/qedi/qedi_main.c: In function 'qedi_alloc_nvm_iscsi_cfg':
>> drivers/scsi/qedi/qedi_main.c:1488:19: warning: format '%llx' expects ar=
gument of type 'long long unsigned int', but argument 7 has type 'dma_addr_=
t' {aka 'unsigned int'} [-Wformat=3D]
    1488 |                   "NVM BUF addr=3D0x%p dma=3D0x%llx.\n", qedi->i=
scsi_image,
         |                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    1489 |                   qedi->nvm_buf_dma);
         |                   ~~~~~~~~~~~~~~~~~
         |                       |
         |                       dma_addr_t {aka unsigned int}
   drivers/scsi/qedi/qedi_dbg.h:78:64: note: in definition of macro 'QEDI_I=
NFO'
      78 |                 qedi_dbg_info(pdev, __func__, __LINE__, level, f=
mt,     \
         |                                                                ^=
~~
   drivers/scsi/qedi/qedi_main.c:1488:47: note: format string is defined he=
re
    1488 |                   "NVM BUF addr=3D0x%p dma=3D0x%llx.\n", qedi->i=
scsi_image,
         |                                            ~~~^
         |                                               |
         |                                               long long unsigned=
 int
         |                                            %x
   drivers/scsi/qedi/qedi_main.c: In function 'qedi_alloc_global_queues':
   drivers/scsi/qedi/qedi_main.c:1754:1: error: could not split insn
    1754 | }
         | ^
   (insn 194 569 196 (set (reg:SI 3 a3 [orig:400 _253 ] [400])
           (xor:SI (reg:SI 2 a2 [orig:401 random_kmalloc_seed ] [401])
               (const:SI (plus:SI (symbol_ref:SI ("*.LANCHOR0") [flags 0x18=
2])
                       (const_int 625 [0x271]))))) "include/linux/slab.h":7=
62:52 288 {cskyv2_xorsi3}
        (expr_list:REG_DEAD (reg:SI 2 a2 [orig:401 random_kmalloc_seed ] [4=
01])
           (nil)))
   during RTL pass: final
   drivers/scsi/qedi/qedi_main.c:1754:1: internal compiler error: in final_=
scan_insn_1, at final.cc:2823
   0x7f356d763d64 __libc_start_main
   	???:0
   ../lib/gcc/csky-linux/16.2.0/ -D __KERNEL__ -D KBUILD_EXTRA_WARN1 -D CSK=
YCPU_DEF_NAME=3D"ck807f" -D MODULE -D KBUILD_BASENAME=3D"qedi_main" -D KBUI=
LD_MODNAME=3D"qedi" -D __KBUILD_MODNAME=3Dqedi -include include/linux/compi=
ler-version.h -include include/linux/kconfig.h -include include/linux/compi=
ler_types.h -MMD drivers/scsi/qedi/.qedi_main.o.d drivers/scsi/qedi/qedi_ma=
in.c -quiet -dumpdir drivers/scsi/qedi/ -dumpbase qedi_main.c -dumpbase-ext=
 .c -mlittle-endian -mcpu=3Dck807 -mfloat-abi=3Dsoft -mdiv -mno-stack-size =
-O2 -Wall -Wextra -Werror=3Dimplicit-function-declaration -Werror=3Dimplici=
t-int -Werror=3Dreturn-type -Werror=3Dstrict-prototypes -Wno-format-securit=
y -Wno-trigraphs -Wno-frame-address -Wno-address-of-packed-member -Wmissing=
-declarations -Wmissing-prototypes -Wframe-larger-than=3D1280 -Wno-main -Wn=
o-type-limits -Wdangling-pointer=3D0 -Wvla-larger-than=3D1 -Wno-pointer-sig=
n -Wcast-function-type -Wno-unterminated-string-initialization -Warray-boun=
ds=3D0 -Wstringop-overflow=3D0 -Walloc-size-larger-than=3D18446744073709551=
615EiB -Wimplicit-fallthrough=3D5 -Werror=3Ddate-time -Werror=3Dincompatibl=
e-pointer-types -Werror=3Ddesignated-init -Wenum-conversion -Wunused -Wsugg=
est-attribute=3Dformat -Wmissing-include-dirs -Wunused-const-variable=3D2 -=
Wno-missing-field-initializers -Wno-shift-negative-value -Wno-maybe-uniniti=
alized -Wno-sign-compare -Wno-unused-parameter -Wno-error=3Dreturn-type -Wr=
eturn-type -Wundef -std=3Dgnu11 -p -fmacro-prefix-map=3D=3D -fshort-wchar -=
fno-common -fno-PIE -fno-strict-aliasing -fms-extensions -fno-tree-vectoriz=
e -fno-delete-null-pointer-checks -fno-allow-store-data-races -fno-reorder-=
blocks -fno-ipa-cp-clone -fno-partial-inlining -fstack-protector-strong -ft=
rivial-auto-var-init=3Dpattern -fzero-init-padding-bits=3Dall -fno-stack-cl=
ash-protection -fdiagnostics-show-context=3D2 -fzero-call-used-regs=3Dused-=
gpr -fno-inline-functions-called-once -fstrict-flex-arrays=3D3 -fno-strict-=
overflow -fstack-check=3Dno -fconserve-stack -fno-builtin-wcslen -funsigned=
-char -falign-functions=3D64 -o -
   Please submit a full bug report, with preprocessed source (by using -fre=
port-bug).
   Please include the complete backtrace with any bug report.
   See <https://gcc.gnu.org/bugs/> for instructions.


vim +1488 drivers/scsi/qedi/qedi_main.c

c57ec8fb7c02532 Nilesh Javali    2017-06-27  1477 =20
c57ec8fb7c02532 Nilesh Javali    2017-06-27  1478  static int qedi_alloc_nv=
m_iscsi_cfg(struct qedi_ctx *qedi)
c57ec8fb7c02532 Nilesh Javali    2017-06-27  1479  {
750afb08ca71310 Luis Chamberlain 2019-01-04  1480  	qedi->iscsi_image =3D d=
ma_alloc_coherent(&qedi->pdev->dev,
872e192fab64388 Colin Ian King   2019-03-27  1481  					       sizeof(struc=
t qedi_nvm_iscsi_image),
750afb08ca71310 Luis Chamberlain 2019-01-04  1482  					       &qedi->nvm_b=
uf_dma, GFP_KERNEL);
c77a2fa3ff8f73d Nilesh Javali    2018-08-29  1483  	if (!qedi->iscsi_image)=
 {
c57ec8fb7c02532 Nilesh Javali    2017-06-27  1484  		QEDI_ERR(&qedi->dbg_ct=
x, "Could not allocate NVM BUF.\n");
c57ec8fb7c02532 Nilesh Javali    2017-06-27  1485  		return -ENOMEM;
c57ec8fb7c02532 Nilesh Javali    2017-06-27  1486  	}
c57ec8fb7c02532 Nilesh Javali    2017-06-27  1487  	QEDI_INFO(&qedi->dbg_ct=
x, QEDI_LOG_INFO,
c77a2fa3ff8f73d Nilesh Javali    2018-08-29 @1488  		  "NVM BUF addr=3D0x%p=
 dma=3D0x%llx.\n", qedi->iscsi_image,
c57ec8fb7c02532 Nilesh Javali    2017-06-27  1489  		  qedi->nvm_buf_dma);
c57ec8fb7c02532 Nilesh Javali    2017-06-27  1490 =20
c57ec8fb7c02532 Nilesh Javali    2017-06-27  1491  	return 0;
c57ec8fb7c02532 Nilesh Javali    2017-06-27  1492  }
c57ec8fb7c02532 Nilesh Javali    2017-06-27  1493 =20

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
