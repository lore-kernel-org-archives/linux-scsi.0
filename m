From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [Scst-devel] Fwd: Re: linuxcon 2010...
Date: Tue, 07 Sep 2010 01:52:29 +0400
Message-ID: <4C85629D.90101@vlnb.net>
References: <594039.74663.qm@web111905.mail.gq1.yahoo.com>	 <1282144271.3035.31.camel@mulgrave.site>	 <AANLkTinRDMXqyDAVkcbioD=L7XO-47KHL2qjR+8KA5m3@mail.gmail.com>	 <1282148296.3035.49.camel@mulgrave.site> <4C6C1D70.7020502@vlnb.net>	 <41A1E2691BBB412BADCDE5F515CD8EDA@usish.com.cn>	 <8A96806D-6CD7-44AD-8A9D-143C098C95A4@uni-paderborn.de>	 <1282256949.30453.278.camel@haakon2.linux-iscsi.org>	 <4C701E08.2020005@vlnb.net> <1282423398.3015.39.camel@mulgrave.site>	 <4C73DA15.2010207@vlnb.net> <1282661876.2993.20.camel@mulgrave.site>	 <4C7421FB.2060007@vlnb.net>	 <1282685014.32007.51.camel@haakon2.linux-iscsi.org>	 <4C76CA57.3050405@vlnb.net>	 <1282857806.32007.175.camel@haakon2.linux-iscsi.org>	 <4C79484B.3090607@vlnb.net>	 <1283028468.32007.357.camel@haakon2.linux-iscsi.org>	 <4C7C18CE.502010
 3@vlnb.net>	 <1283204792.32007.448.camel@haakon2.linux-iscsi.org>	 <4C7FFD1A.8090509@vlnb.net> <1283459158.5598.143.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:59853 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196Ab0IFVxA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Sep 2010 17:53:00 -0400
In-Reply-To: <1283459158.5598.143.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: James Bottomley <James.Bottomley@suse.de>, Dirk Meister <dmeister@uni-paderborn.de>, linux-scsi@vger.kernel.org, Chetan Loke <chetanloke@gmail.com>, Chetan Loke <generationgnu@yahoo.com>, scst-devel <scst-devel@lists.sourceforge.net>, linux-kernel@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Nicholas A. Bellinger, on 09/03/2010 12:25 AM wrote:
>>> Again, I still have no idea what you are trying to conjour up.  The
>>> passthrough for STGT compatibility with TCM_Loop via SG_IO and BSG has
>>> already been merged by Tomo-san into tgt.git.  Futhermore, we are using
>>> the same TCM_Loop high level multi-fabric WWPN emulation together with
>>> new (and old) QEMU HBA emulation into KVM guest using SG_IO and BSG as
>>> well.
>>
>> The patches were good, but don't mislead people about that. For sake of
>> clearness, what you called "the passthrough for STGT compatibility with
>> TCM_Loop via SG_IO and BSG" has nothing with LIO/TCM_Loop. What merged
>> fixed problems STGT had in the pass-through implementation. It at the
>> same time fixed problems with SCST's scst_local, so similarly can be
>> called "the passthrough for STGT compatibility with scst_local via SG_IO
>> and BSG".
>>
>
> Uh, I don't think TCM_Loop and scst_local are exactly comparable at this
> point.  TCM_Loop supports high level multi-fabric WWPN emulation that
> allows it to work transparently with inter-nexus SPC-4 PR operation.
> Therefore, using TCM_Loop, STGT userspace fabrics now support both PR
> and ALUA emulation from TCM_Loop LUNs.  This is done at struct
> config_group_ops->make_group() time to report $PROTO_IDENT and the
> necessary WWPN info to TCM Core logic.  TCM_Loop also uses the fabric
> indepent configfs handlers for pretty much all of it's control plane
> code.

TCM_Loop and scst_local are exactly comparable and do absolutely the 
same thing. If you see any difference, please be precise. Internal 
implementation doesn't matter as soon as it doesn't affect the 
functionality STGT uses.

>> I have no doubts in benefits to TCM. But I have asked about benefits
>> _for an average user_. STGT already can do what you listed above.
>>
>
> Again, from above how it benefits users:
>
> 1) a userspace library in intrepted languages and 2) create high level
> applications using said userspace libraries that allow compatiblity to
> be contained in the lib below.
>
> 2) create high level applications using said userspace libraries that
> allow compatiblity to be contained in the lib.

All those can be done for STGT. LIO isn't needed for that. So, value for 
STGT users still not questionable to me.

Vlad
