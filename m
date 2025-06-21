Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 482465D8F0;
	Sat, 21 Jun 2025 17:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750526174; cv=none; b=bw3vzv2i9cwC/0Ez0WrTYYVIEKh7CFWgFnznI51y+hefDPLEMHQ9iv8nNp+okm2MGwQwttxpzv5f+prY8EYArDF7UvM9ssBVTCJKKy1iU7EyZxhjwRnlQocTdrZPTkn1t/b//B2UJCZFX+olmioNhBLdXIckbOkyXNB84/09bPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750526174; c=relaxed/simple;
	bh=+gcvjGZwxdrnistOt45/AQ9QvQLHGQ1VDn3xcEGVmmQ=;
	h=Content-Type:Message-ID:Date:MIME-Version:Subject:To:CC:
	 References:From:In-Reply-To; b=Tip8UhgoBHXiOiHOV1K8Rzfe862gPK76ENWynSmBh9NxBXzuv3ypKDXAkyEfit4kwH0+5tNDBFum0YXwoex+2fhWDgrKqJL5n/QKWbkWIZVdHHKfZx7FHhNROIL82XrpqTYw808LN3+m0swqLoeJCfdopsbLcWUaCWsoOXfKI9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=Qcu/Nv8U; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="Qcu/Nv8U"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55LDbpMK029033;
	Sat, 21 Jun 2025 17:15:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=EWhAyY52R9B93tq46/GWTLOi
	WgtqM3fkKV1oXuaq+No=; b=Qcu/Nv8Uu27F4rb5vyW953hmmqtz5f7ASowCdYX1
	KQBah3TNtpaFQL7yVq0C89YfrHbqQT5A5/BHFU/2GTjiw8qaRcDuE14fLRrkBGpj
	l+l5SrRMWjxEOfX2kGnvGDayGCoC4ruADJm6ns+aQiu+UG3U07li784SDJO47Lyl
	1w0OEN05sZAtJgSqcamTWMhB2n2hpXR8s8zk4e8YBkxlRzEl/OMMY6LX/pVqtIwA
	/IInap47SUYvnCPoXZ7YE143dCp2z0StAT/kHIq/K6phYSmd0R2VQ/9N11QMvnXn
	jus+pqLSc0d2kcIjx7VnAEmdiNV95e+amV/ipQKMI5dnlA==
Received: from nalasppmta01.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 47dm2mgy2r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 21 Jun 2025 17:15:41 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA01.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 55LHFeUl024446
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 21 Jun 2025 17:15:40 GMT
Received: from [10.216.13.113] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Sat, 21 Jun
 2025 10:15:35 -0700
Content-Type: multipart/mixed;
	boundary="------------MYv0y4zmAFyzi5G04JjanIdp"
Message-ID: <e392a025-2417-4df8-b3f6-853a33cc8fe2@quicinc.com>
Date: Sat, 21 Jun 2025 22:45:32 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: next-20250620: Qualcomm Dragonboard 845c Internal error Oops at
 ufs_qcom_setup_clocks
To: Naresh Kamboju <naresh.kamboju@linaro.org>,
        open list
	<linux-kernel@vger.kernel.org>,
        Linux ARM
	<linux-arm-kernel@lists.infradead.org>,
        <lkft-triage@lists.linaro.org>,
        "Linux Regressions" <regressions@lists.linux.dev>,
        <linux-phy@lists.infradead.org>, <linux-scsi@vger.kernel.org>
CC: Vinod Koul <vkoul@kernel.org>, Neil Armstrong <neil.armstrong@linaro.org>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        "James E.J. Bottomley"
	<James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen"
	<martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Bjorn
 Andersson" <andersson@kernel.org>,
        <konrad.dybcio@oss.qualcomm.com>, <dmitry.baryshkov@oss.qualcomm.com>,
        Manivannan Sadhasivam <mani@kernel.org>
References: <CA+G9fYuOnfvm7N0pa=PNvq=tQsp6CVA34eDq5=rGthEBrdMJuQ@mail.gmail.com>
Content-Language: en-US
From: Nitin Rawat <quic_nitirawa@quicinc.com>
In-Reply-To: <CA+G9fYuOnfvm7N0pa=PNvq=tQsp6CVA34eDq5=rGthEBrdMJuQ@mail.gmail.com>
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: zwt2HxUhSi6xVY2923fndPMoZrIGRJ5P
X-Proofpoint-ORIG-GUID: zwt2HxUhSi6xVY2923fndPMoZrIGRJ5P
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjIxMDEwOSBTYWx0ZWRfXyCNU3s9oybwD
 lq9yQZMb3PkSGzBU2TbXwTZalsMMqyhThad9iH0AvnBESH2Ccn2cZnCm+G3MkYxu7x74w4wyigA
 oPGXjDwjeuwTqTCw0TYDuCvn6yqvJXx2NDot6J/c1ziklETEwMUbARqbERg+iHsr6VMf1Ga0rtx
 KasG0nIO6Zdz5TJzgkLOujtzJWlQ0RT05yYkPBQ/pcBrjhlpShE8RQqWM5rsjY3yAE0boCMs7rB
 qF6AkNlPerultpu9jTyWl3M0xx3VoA2494WlWcoHBSaNP49WY/bMSFBcSkgXpdNcbPLvVF4MthV
 x3Xf/7LjHmq4s2rExAv/LwtZBQtBd9lPxKlHRgg7Sp6XN0uaTFndng7H/0oje8dYsZYf7OJLhuv
 uMWEiaKpcZl77yPf+1OyL7z9WUgO5IUTp532aSGg8owHRzaJIvCnAls4xYmLMX7Rv6WTrdGX
X-Authority-Analysis: v=2.4 cv=Q93S452a c=1 sm=1 tr=0 ts=6856e8be cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=GEpy-HfZoHoA:10 a=6IFa9wvqVegA:10 a=Oh2cFVv5AAAA:8 a=KKAkSRfTAAAA:8
 a=21D8NHQQAAAA:8 a=IbvxqlhZ7zuPPwgKCwkA:9 a=QEXdDO2ut3YA:10
 a=09waTpoc23FLKGTpX6IA:9 a=B2y7HmGcmWMA:10 a=7KeoIwV6GZqOttXkcoxL:22
 a=cvBusfyB2V15izCimMoJ:22 a=aE7_2WBlPvBBVsBbSUWX:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-21_05,2025-06-20_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 adultscore=0 priorityscore=1501 mlxscore=0 suspectscore=0
 clxscore=1011 lowpriorityscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 impostorscore=0 bulkscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2506210109

--------------MYv0y4zmAFyzi5G04JjanIdp
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit



On 6/21/2025 1:40 PM, Naresh Kamboju wrote:
> Regressions noticed on the Qualcomm Dragonboard 845c device while booting the
> Linux next tags from next-20250616..next-20250620 the following kernel oops
> noticed and boot failed.
> 
> Regressions found on Thundercomm Dragonboard 845c (DT)
> - Boot
> 
> Regression Analysis:
> - New regression? Yes
> - Reproducibility? Yes
> 
> First seen on the next-20250616
> Good: next-20250613
> Bad:  next-20250616
> 
> Boot regression: Qualcomm Dragonboard 845c Internal error Oops at
> ufs_qcom_setup_clocks
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>


Hi Naresh,

Thanks for testing and reporting this issue. Can you please
test with the attached fix and let me know if it helps.

Regards,
Nitin


> 
> ## Boot log
> [    6.446825] ufshcd-qcom 1d84000.ufshc: ufshcd_populate_vreg: Unable
> to find vccq2-supply regulator, assuming enabled
> [    6.448070] Unable to handle kernel NULL pointer dereference at
> virtual address 0000000000000000
> [    6.448080] Mem abort info:
> [    6.448086]   ESR = 0x0000000096000006
> [    6.448093]   EC = 0x25: DABT (current EL), IL = 32 bits
> [    6.448101]   SET = 0, FnV = 0
> [    6.448107]   EA = 0, S1PTW = 0
> [    6.448113]   FSC = 0x06: level 2 translation fault
> [    6.448120] Data abort info:
> [    6.448125]   ISV = 0, ISS = 0x00000006, ISS2 = 0x00000000
> [    6.448132]   CM = 0, WnR = 0, TnD = 0, TagAccess = 0
> [    6.448139]   GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
> [    6.448146] user pgtable: 4k pages, 48-bit VAs, pgdp=000000010447b000
> [    6.448154] [0000000000000000] pgd=080000010447d403,
> p4d=080000010447d403, pud=080000010447e403, pmd=0000000000000000
> [    6.448186] Internal error: Oops: 0000000096000006 [#1]  SMP
> [    6.448193] Modules linked in: qcom_q6v5_mss(+) ufs_qcom(+)
> cfg80211(+) coresight_stm stm_core phy_qcom_qmp_pcie rfkill qcom_wdt
> lmh(+) icc_osm_l3 qrtr slim_qcom_ngd_ctrl slimbus pdr_interface
> qcom_pdr_msg icc_bwmon qcom_q6v5_pas(+) llcc_qcom qcom_pil_info
> display_connector qcom_q6v5 qcom_sysmon drm_kms_helper qcom_common
> qcom_glink_smem mdt_loader qmi_helpers drm backlight socinfo rmtfs_mem
> [    6.448278] CPU: 6 UID: 0 PID: 385 Comm: (udev-worker) Not tainted
> 6.16.0-rc2-next-20250620 #1 PREEMPT
> [    6.448288] Hardware name: Thundercomm Dragonboard 845c (DT)
> [    6.448292] pstate: 20400005 (nzCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> [    6.448299] pc : ufs_qcom_setup_clocks+0x28/0x148 ufs_qcom
> [    6.448317] lr : ufshcd_setup_clocks
> (drivers/ufs/core/ufshcd-priv.h:142 drivers/ufs/core/ufshcd.c:9290)
> [    6.448332] sp : ffff800081213640
> [    6.448335] x29: ffff800081213640 x28: 0000000000000001 x27: ffff00008b633270
> [    6.448347] x26: ffff00008b6332a0 x25: ffff00008b632870 x24: 0000000000000000
> [    6.448359] x23: ffff00008b633280 x22: ffff00008b6332a0 x21: 0000000000000000
> [    6.448369] x20: ffffd7eabf84d618 x19: ffff00008b632870 x18: 0000000000000000
> [    6.448380] x17: 5453595342555300 x16: 305f666d745f6973 x15: 0000000000000100
> [    6.448391] x14: ffffffffffffffff x13: 0000000000000030 x12: 0101010101010101
> [    6.448402] x11: ffff00008188ea18 x10: 0000000000000000 x9 : ffffd7eabd9c3c28
> [    6.448413] x8 : ffff8000812134b8 x7 : fefefefefefefefe x6 : 0000000000000001
> [    6.448423] x5 : ffffffffffffffc8 x4 : 00000000c0000000 x3 : ffffd7eab32aa058
> [    6.448433] x2 : 0000000000000000 x1 : 0000000000000001 x0 : ffff00008b632870
> [    6.448444] Call trace:
> [    6.448449] ufs_qcom_setup_clocks+0x28/0x148 ufs_qcom (P)
> [    6.448466] ufshcd_setup_clocks (drivers/ufs/core/ufshcd-priv.h:142
> drivers/ufs/core/ufshcd.c:9290)
> [    6.448477] ufshcd_init (drivers/ufs/core/ufshcd.c:9468
> drivers/ufs/core/ufshcd.c:10636)
> [    6.448485] ufshcd_pltfrm_init (drivers/ufs/host/ufshcd-pltfrm.c:504)
> [    6.448495] ufs_qcom_probe+0x28/0x68 ufs_qcom
> [    6.448508] platform_probe (drivers/base/platform.c:1404)
> [    6.448519] really_probe (drivers/base/dd.c:579 drivers/base/dd.c:657)
> [    6.448526] __driver_probe_device (drivers/base/dd.c:799)
> [    6.448532] driver_probe_device (drivers/base/dd.c:829)
> [    6.448539] __driver_attach (drivers/base/dd.c:1216)
> [    6.448545] bus_for_each_dev (drivers/base/bus.c:370)
> [    6.448556] driver_attach (drivers/base/dd.c:1234)
> [    6.448567] bus_add_driver (drivers/base/bus.c:678)
> [    6.448577] driver_register (drivers/base/driver.c:249)
> [    6.448584] __platform_driver_register (drivers/base/platform.c:868)
> [    6.448592] ufs_qcom_pltform_init+0x28/0xff8 ufs_qcom
> [    6.448605] do_one_initcall (init/main.c:1274)
> [    6.448615] do_init_module (kernel/module/main.c:3041)
> [    6.448626] load_module (kernel/module/main.c:3511)
> [    6.448635] init_module_from_file (kernel/module/main.c:3704)
> [    6.448644] __arm64_sys_finit_module (kernel/module/main.c:3715
> kernel/module/main.c:3741 kernel/module/main.c:3725
> kernel/module/main.c:3725)
> [    6.448653] invoke_syscall (arch/arm64/include/asm/current.h:19
> arch/arm64/kernel/syscall.c:54)
> [    6.448661] el0_svc_common.constprop.0
> (include/linux/thread_info.h:135 (discriminator 2)
> arch/arm64/kernel/syscall.c:140 (discriminator 2))
> [    6.448668] do_el0_svc (arch/arm64/kernel/syscall.c:152)
> [    6.448674] el0_svc (arch/arm64/include/asm/irqflags.h:82
> (discriminator 1) arch/arm64/include/asm/irqflags.h:123 (discriminator
> 1) arch/arm64/include/asm/irqflags.h:136 (discriminator 1)
> arch/arm64/kernel/entry-common.c:165 (discriminator 1)
> arch/arm64/kernel/entry-common.c:178 (discriminator 1)
> arch/arm64/kernel/entry-common.c:768 (discriminator 1))
> [    6.448685] el0t_64_sync_handler (arch/arm64/kernel/entry-common.c:787)
> [    6.448694] el0t_64_sync (arch/arm64/kernel/entry.S:600)
> [ 6.448705] Code: a90157f3 aa0003f3 f90013f6 f9405c15 (f94002b6)
> All code
> ========
>     0: a90157f3 stp x19, x21, [sp, #16]
>     4: aa0003f3 mov x19, x0
>     8: f90013f6 str x22, [sp, #32]
>     c: f9405c15 ldr x21, [x0, #184]
>    10:* f94002b6 ldr x22, [x21] <-- trapping instruction
> 
> Code starting with the faulting instruction
> ===========================================
>     0: f94002b6 ldr x22, [x21]
> [    6.448710] ---[ end trace 0000000000000000 ]---
> 
> ## Source
> * Kernel version: 6.16.0-rc2-next-20250620
> * Git tree: https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next.git
> * Git sha: 2c923c845768a0f0e34b8161d70bc96525385782
> * Git describe: next-20250620
> * Project details:
> https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20250620/
> * Architectures: arm64 Dragonboard 845c
> * Toolchains: gcc-13
> * Kconfigs: defconfig+lkfttestconfigs
> 
> ## Build arm64
> * Test log: https://qa-reports.linaro.org/api/testruns/28811906/log_file/
> * Test Lava log: https://lkft.validation.linaro.org/scheduler/job/8323501#L5646
> * Test Lava log 2:
> https://lkft.validation.linaro.org/scheduler/job/8323351#L5682
> * Test details:
> https://regressions.linaro.org/lkft/linux-next-master/next-20250620/boot/gcc-13-lkftconfig/
> * Build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/2yj4otvwBRT4UktLTyKEN8ZtUQm/
> * Kernel config:
> https://storage.tuxsuite.com/public/linaro/lkft/builds/2yj4otvwBRT4UktLTyKEN8ZtUQm/config
> 
> --
> Linaro LKFT
> https://lkft.linaro.org

--------------MYv0y4zmAFyzi5G04JjanIdp
Content-Type: text/plain; charset="UTF-8";
	name="0001-scsi-ufs-qcom-Fix-NULL-pointer-dereference-in-ufs_qc.patch"
Content-Disposition: attachment;
	filename*0="0001-scsi-ufs-qcom-Fix-NULL-pointer-dereference-in-ufs_qc.pa";
	filename*1="tch"
Content-Transfer-Encoding: base64

RnJvbSAzZjZhYmYwZjVhMWFkNmRiYTk3NTgyNGM5N2M5NGE3N2JhYmI5ZDM4IE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBOaXRpbiBSYXdhdCA8cXVpY19uaXRpcmF3YUBxdWlj
aW5jLmNvbT4KRGF0ZTogU2F0LCAyMSBKdW4gMjAyNSAyMTo0MDo0MiArMDUzMApTdWJqZWN0
OiBbUEFUQ0ggVjFdIHNjc2k6IHVmczogcWNvbSA6IEZpeCBOVUxMIHBvaW50ZXIgZGVyZWZl
cmVuY2UgaW4KIHVmc19xY29tX3NldHVwX2Nsb2NrcwoKRml4IGEgTlVMTCBwb2ludGVyIGRl
cmVmZXJlbmNlIGluIHVmc19xY29tX3NldHVwX2Nsb2NrcyBkdWUgdG8gYW4KdW5pbml0aWFs
aXplZCAnaG9zdCcgdmFyaWFibGUuIFRoZSB2YXJpYWJsZSAncGh5JyBpcyBub3cgYXNzaWdu
ZWQKYWZ0ZXIgY29uZmlybWluZyAnaG9zdCcgaXMgbm90IE5VTEwuCgpDYWxsIFN0YWNrOgoK
WyAgICA2LjQ0ODA3MF0gVW5hYmxlIHRvIGhhbmRsZSBrZXJuZWwgTlVMTCBwb2ludGVyIGRl
cmVmZXJlbmNlIGF0CnZpcnR1YWwgYWRkcmVzcyAwMDAwMDAwMDAwMDAwMDAwClsgICAgNi40
NDg0NDldIHVmc19xY29tX3NldHVwX2Nsb2NrcysweDI4LzB4MTQ4IHVmc19xY29tIChQKQpb
ICAgIDYuNDQ4NDY2XSB1ZnNoY2Rfc2V0dXBfY2xvY2tzIChkcml2ZXJzL3Vmcy9jb3JlL3Vm
c2hjZC1wcml2Lmg6MTQyKQpbICAgIDYuNDQ4NDc3XSB1ZnNoY2RfaW5pdCAoZHJpdmVycy91
ZnMvY29yZS91ZnNoY2QuYzo5NDY4KQpbICAgIDYuNDQ4NDg1XSB1ZnNoY2RfcGx0ZnJtX2lu
aXQgKGRyaXZlcnMvdWZzL2hvc3QvdWZzaGNkLXBsdGZybS5jOjUwNCkKWyAgICA2LjQ0ODQ5
NV0gdWZzX3Fjb21fcHJvYmUrMHgyOC8weDY4IHVmc19xY29tClsgICAgNi40NDg1MDhdIHBs
YXRmb3JtX3Byb2JlIChkcml2ZXJzL2Jhc2UvcGxhdGZvcm0uYzoxNDA0KQpbICAgIDYuNDQ4
NTE5XSByZWFsbHlfcHJvYmUgKGRyaXZlcnMvYmFzZS9kZC5jOjU3OSBkcml2ZXJzL2Jhc2Uv
ZGQuYzo2NTcpClsgICAgNi40NDg1MjZdIF9fZHJpdmVyX3Byb2JlX2RldmljZSAoZHJpdmVy
cy9iYXNlL2RkLmM6Nzk5KQpbICAgIDYuNDQ4NTMyXSBkcml2ZXJfcHJvYmVfZGV2aWNlIChk
cml2ZXJzL2Jhc2UvZGQuYzo4MjkpClsgICAgNi40NDg1MzldIF9fZHJpdmVyX2F0dGFjaCAo
ZHJpdmVycy9iYXNlL2RkLmM6MTIxNikKWyAgICA2LjQ0ODU0NV0gYnVzX2Zvcl9lYWNoX2Rl
diAoZHJpdmVycy9iYXNlL2J1cy5jOjM3MCkKWyAgICA2LjQ0ODU1Nl0gZHJpdmVyX2F0dGFj
aCAoZHJpdmVycy9iYXNlL2RkLmM6MTIzNCkKWyAgICA2LjQ0ODU2N10gYnVzX2FkZF9kcml2
ZXIgKGRyaXZlcnMvYmFzZS9idXMuYzo2NzgpClsgICAgNi40NDg1NzddIGRyaXZlcl9yZWdp
c3RlciAoZHJpdmVycy9iYXNlL2RyaXZlci5jOjI0OSkKWyAgICA2LjQ0ODU4NF0gX19wbGF0
Zm9ybV9kcml2ZXJfcmVnaXN0ZXIgKGRyaXZlcnMvYmFzZS9wbGF0Zm9ybS5jOjg2OCkKWyAg
ICA2LjQ0ODU5Ml0gdWZzX3Fjb21fcGx0Zm9ybV9pbml0KzB4MjgvMHhmZjggdWZzX3Fjb20K
WyAgICA2LjQ0ODYwNV0gZG9fb25lX2luaXRjYWxsIChpbml0L21haW4uYzoxMjc0KQpbICAg
IDYuNDQ4NjE1XSBkb19pbml0X21vZHVsZSAoa2VybmVsL21vZHVsZS9tYWluLmM6MzA0MSkK
WyAgICA2LjQ0ODYyNl0gbG9hZF9tb2R1bGUgKGtlcm5lbC9tb2R1bGUvbWFpbi5jOjM1MTEp
ClsgICAgNi40NDg2MzVdIGluaXRfbW9kdWxlX2Zyb21fZmlsZSAoa2VybmVsL21vZHVsZS9t
YWluLmM6MzcwNCkKWyAgICA2LjQ0ODY0NF0gX19hcm02NF9zeXNfZmluaXRfbW9kdWxlIChr
ZXJuZWwvbW9kdWxlL21haW4uYzozNzE1LgoKRml4ZXM6IDc3ZDJmYTU0YTk0NSAoInNjc2k6
IHVmczogcWNvbSA6IFJlZmFjdG9yIHBoeV9wb3dlcl9vbi9vZmYgY2FsbHMiKQpSZXBvcnRl
ZC1ieTogQWlzaHdhcnlhIDxhaXNod2FyeWEudGN2QGFybS5jb20+CkNsb3NlczogaHR0cHM6
Ly9sb3JlLmtlcm5lbC5vcmcvbGttbC8yMDI1MDYyMDIxNDQwOC4xMTAyOC0xLWFpc2h3YXJ5
YS50Y3ZAYXJtLmNvbS8KUmVwb3J0ZWQtYnk6IE5hcmVzaCBLYW1ib2p1IDxuYXJlc2gua2Ft
Ym9qdUBsaW5hcm8ub3JnPgpDbG9zZXM6IGh0dHBzOi8vbGttbC5vcmcvbGttbC8yMDI1LzYv
MjEvMTA3CkNvLWRldmVsb3BlZC1ieTogUmFtIEt1bWFyIER3aXZlZGkgPHF1aWNfcmR3aXZl
ZGlAcXVpY2luYy5jb20+ClNpZ25lZC1vZmYtYnk6IFJhbSBLdW1hciBEd2l2ZWRpIDxxdWlj
X3Jkd2l2ZWRpQHF1aWNpbmMuY29tPgpTaWduZWQtb2ZmLWJ5OiBOaXRpbiBSYXdhdCA8cXVp
Y19uaXRpcmF3YUBxdWljaW5jLmNvbT4KLS0tCiBkcml2ZXJzL3Vmcy9ob3N0L3Vmcy1xY29t
LmMgfCA0ICsrKy0KIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDEgZGVsZXRp
b24oLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Vmcy9ob3N0L3Vmcy1xY29tLmMgYi9kcml2
ZXJzL3Vmcy9ob3N0L3Vmcy1xY29tLmMKaW5kZXggYmE0YjI4ODAyNzljLi4zMThkY2E3ZmUz
ZDcgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvdWZzL2hvc3QvdWZzLXFjb20uYworKysgYi9kcml2
ZXJzL3Vmcy9ob3N0L3Vmcy1xY29tLmMKQEAgLTExMjQsNyArMTEyNCw3IEBAIHN0YXRpYyBp
bnQgdWZzX3Fjb21fc2V0dXBfY2xvY2tzKHN0cnVjdCB1ZnNfaGJhICpoYmEsIGJvb2wgb24s
CiAJCQkJIGVudW0gdWZzX25vdGlmeV9jaGFuZ2Vfc3RhdHVzIHN0YXR1cykKIHsKIAlzdHJ1
Y3QgdWZzX3Fjb21faG9zdCAqaG9zdCA9IHVmc2hjZF9nZXRfdmFyaWFudChoYmEpOwotCXN0
cnVjdCBwaHkgKnBoeSA9IGhvc3QtPmdlbmVyaWNfcGh5OworCXN0cnVjdCBwaHkgKnBoeTsK
IAlpbnQgZXJyOwoKIAkvKgpAQCAtMTEzNSw2ICsxMTM1LDggQEAgc3RhdGljIGludCB1ZnNf
cWNvbV9zZXR1cF9jbG9ja3Moc3RydWN0IHVmc19oYmEgKmhiYSwgYm9vbCBvbiwKIAlpZiAo
IWhvc3QpCiAJCXJldHVybiAwOwoKKwlwaHkgPSBob3N0LT5nZW5lcmljX3BoeTsKKwogCXN3
aXRjaCAoc3RhdHVzKSB7CiAJY2FzZSBQUkVfQ0hBTkdFOgogCQlpZiAob24pIHsKLS0KMi40
OC4xCgo=

--------------MYv0y4zmAFyzi5G04JjanIdp--
