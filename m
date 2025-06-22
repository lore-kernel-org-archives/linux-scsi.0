Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24A4A1487ED;
	Sun, 22 Jun 2025 10:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750589495; cv=none; b=u/ONEYviL98nfWbuFr3MDLl6CpeHRkG7qs1JPbLNjpJEkhHqVsC41liY9OIGbA2zROPCtkGkfj+V8fhMvdPWOJKoEZijoLrAISBELvCBX4VxF6EWWFoGvqzo/mkGmD1AArQGJyPzihYm2rUaLb9StvJWYm3ooVOxv1yePujG7nE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750589495; c=relaxed/simple;
	bh=9MSzFcDpy4n/gunIIBqUACEHh7/DmHDSqEBmInEMLRE=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=R3j2lbBhEqnkMB9RPl+8z2dToBNvixFhcaYfc2KUqx+XO6pPsmxgqkhf+WMNojfd6JmBuE1kV6UgFqD2c7+F/JM2O/wtW1tGVJmzCC0HNlzly02bs3LZVKgPXlNyxjxYrFrCr7FFn8etJ/mo+aXpqUg27flbURMSnh5IPjOK2EE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=ag+GgjNJ; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="ag+GgjNJ"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55MAoCMk022049;
	Sun, 22 Jun 2025 10:51:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	pBXbBlv9I6C6FSR5Kw14+0xZtNhfR0ySSaXaQFkKeI8=; b=ag+GgjNJ6BeNewlW
	zUMIzgUvYPNfUFBgcw5CAfORDAiWngG41LDbTojDVaGGLyhGPMpSjigePMIt326g
	nwwQnGQoenUH0ekm5Cc+VJfcnoZH170evmhtTJ2kF/W+7si7Jk2DJb4CmnorCzL8
	e783TQr8TzONe6/MAOXMVCxjQHLrX63MqsSKdLC6/2sreAr8e2BxUDReGxN0jzdt
	w4RUR60r8+3p8i0wGmo1sbRXopgIK2LhcJLG+Hi4iD2HVRO/NDU3xVgGO6qEsTCn
	509W0cU3T9xQiomx8gdxkLVT1vZYWWoOTcBZa04AYfrvrKAgsrOkSyAXhcQVoHCS
	Iy1wvg==
Received: from nalasppmta04.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 47ege0r01d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 22 Jun 2025 10:51:09 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA04.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 55MAp8R9010853
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 22 Jun 2025 10:51:08 GMT
Received: from [10.216.13.113] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Sun, 22 Jun
 2025 03:51:03 -0700
Message-ID: <118d58ab-b458-4472-a92b-00f98995bc79@quicinc.com>
Date: Sun, 22 Jun 2025 16:20:53 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: next-20250620: Qualcomm Dragonboard 845c Internal error Oops at
 ufs_qcom_setup_clocks
To: Naresh Kamboju <naresh.kamboju@linaro.org>
CC: open list <linux-kernel@vger.kernel.org>,
        Linux ARM
	<linux-arm-kernel@lists.infradead.org>,
        <lkft-triage@lists.linaro.org>,
        "Linux Regressions" <regressions@lists.linux.dev>,
        <linux-phy@lists.infradead.org>, <linux-scsi@vger.kernel.org>,
        Vinod Koul
	<vkoul@kernel.org>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Kishon Vijay
 Abraham I <kishon@kernel.org>,
        "James E.J. Bottomley"
	<James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen"
	<martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Bjorn
 Andersson <andersson@kernel.org>,
        <konrad.dybcio@oss.qualcomm.com>, <dmitry.baryshkov@oss.qualcomm.com>,
        Manivannan Sadhasivam <mani@kernel.org>
References: <CA+G9fYuOnfvm7N0pa=PNvq=tQsp6CVA34eDq5=rGthEBrdMJuQ@mail.gmail.com>
 <e392a025-2417-4df8-b3f6-853a33cc8fe2@quicinc.com>
 <CA+G9fYuFQ2dBvYm1iB6rbwT=4b1c8e4NJ3yxqFPGZGUKH3GmMA@mail.gmail.com>
Content-Language: en-US
From: Nitin Rawat <quic_nitirawa@quicinc.com>
In-Reply-To: <CA+G9fYuFQ2dBvYm1iB6rbwT=4b1c8e4NJ3yxqFPGZGUKH3GmMA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: -k8KxG-8C94D_j62VGzXz4sptFeJALed
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjIyMDA2NiBTYWx0ZWRfXwia1m7vneYwT
 rHe8zBqV1JQSS0qVdBZHp7tLkbCyHe5RxKN6w8GV8dOLqIXbD3TzCIbe/4wkGM2C3W8eDRktP0W
 Gb1XInKTMuAI5IxqqbHG1RzfYKRxEpZfvWdg8AWO6GV39np9iweYoLzhUsu/SaJ8sxTCc6528gt
 0V2PGBnBWH/HNk1VkctGDTdI+q2w1Rju947sLYhqkTBZOwAtL1H4SABVi2daixc5loNLMYKMHzj
 k2ZizeeI8KWL6MztiQCrsE84Cl6gDa7jgCl4Zwy77mBR7XnAcQ+Wk4mxa7ZI90fTrUZxR+4sE7f
 aYCRWTFvGxSIE6S5whLklT59PywmEjLxXCSZZW5kuIIlwRensmnZ9bExW2GG0SGxaWbhOTR4Fzt
 yFIe1vy432hUIfItVo2gcwkzDkZ8zFnPa2oJLI00QlX6T3rl4hRFqjxRoJTuCMB68vPquCL0
X-Authority-Analysis: v=2.4 cv=CesI5Krl c=1 sm=1 tr=0 ts=6857e01d cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=GEpy-HfZoHoA:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=KKAkSRfTAAAA:8
 a=Oh2cFVv5AAAA:8 a=21D8NHQQAAAA:8 a=COk6AnOGAAAA:8 a=DIQkKumCARwGTuhbXasA:9
 a=QEXdDO2ut3YA:10 a=cvBusfyB2V15izCimMoJ:22 a=7KeoIwV6GZqOttXkcoxL:22
 a=aE7_2WBlPvBBVsBbSUWX:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-GUID: -k8KxG-8C94D_j62VGzXz4sptFeJALed
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-22_03,2025-06-20_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 phishscore=0 clxscore=1015 spamscore=0 adultscore=0
 mlxlogscore=999 suspectscore=0 malwarescore=0 priorityscore=1501
 impostorscore=0 mlxscore=0 bulkscore=0 classifier=spam authscore=0 authtc=n/a
 authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2505280000 definitions=main-2506220066



On 6/22/2025 2:22 PM, Naresh Kamboju wrote:
> On Sat, 21 Jun 2025 at 22:45, Nitin Rawat <quic_nitirawa@quicinc.com> wrote:
>>
>>
>>
>> On 6/21/2025 1:40 PM, Naresh Kamboju wrote:
>>> Regressions noticed on the Qualcomm Dragonboard 845c device while booting the
>>> Linux next tags from next-20250616..next-20250620 the following kernel oops
>>> noticed and boot failed.
>>>
>>> Regressions found on Thundercomm Dragonboard 845c (DT)
>>> - Boot
>>>
>>> Regression Analysis:
>>> - New regression? Yes
>>> - Reproducibility? Yes
>>>
>>> First seen on the next-20250616
>>> Good: next-20250613
>>> Bad:  next-20250616
>>>
>>> Boot regression: Qualcomm Dragonboard 845c Internal error Oops at
>>> ufs_qcom_setup_clocks
>>>
>>> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
>>
>>
>> Hi Naresh,
>>
>> Thanks for testing and reporting this issue. Can you please
>> test with the attached fix and let me know if it helps.
> 
> The attached patch applied on top of the Linux next and
> boot test pass and also LTP smoke runs smooth.

Thank you, Naresh, for testing the fix. I have sent the patch for
review.

Thanks,
Nitin

> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> Boot test pass LAVA test jobs runs links,
> - https://lkft.validation.linaro.org/scheduler/job/8324919#L5075
> - https://lkft.validation.linaro.org/scheduler/job/8324918#L5105
>   - https://lkft.validation.linaro.org/scheduler/job/8324917#L5120
> 
> - Naresh
> 
>>
>> Regards,
>> Nitin
>>
>>
>>>
>>> ## Boot log
>>> [    6.446825] ufshcd-qcom 1d84000.ufshc: ufshcd_populate_vreg: Unable
>>> to find vccq2-supply regulator, assuming enabled
>>> [    6.448070] Unable to handle kernel NULL pointer dereference at
>>> virtual address 0000000000000000
>>> [    6.448080] Mem abort info:
>>> [    6.448086]   ESR = 0x0000000096000006
>>> [    6.448093]   EC = 0x25: DABT (current EL), IL = 32 bits
>>> [    6.448101]   SET = 0, FnV = 0
>>> [    6.448107]   EA = 0, S1PTW = 0
>>> [    6.448113]   FSC = 0x06: level 2 translation fault
>>> [    6.448120] Data abort info:
>>> [    6.448125]   ISV = 0, ISS = 0x00000006, ISS2 = 0x00000000
>>> [    6.448132]   CM = 0, WnR = 0, TnD = 0, TagAccess = 0
>>> [    6.448139]   GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
>>> [    6.448146] user pgtable: 4k pages, 48-bit VAs, pgdp=000000010447b000
>>> [    6.448154] [0000000000000000] pgd=080000010447d403,
>>> p4d=080000010447d403, pud=080000010447e403, pmd=0000000000000000
>>> [    6.448186] Internal error: Oops: 0000000096000006 [#1]  SMP
>>> [    6.448193] Modules linked in: qcom_q6v5_mss(+) ufs_qcom(+)
>>> cfg80211(+) coresight_stm stm_core phy_qcom_qmp_pcie rfkill qcom_wdt
>>> lmh(+) icc_osm_l3 qrtr slim_qcom_ngd_ctrl slimbus pdr_interface
>>> qcom_pdr_msg icc_bwmon qcom_q6v5_pas(+) llcc_qcom qcom_pil_info
>>> display_connector qcom_q6v5 qcom_sysmon drm_kms_helper qcom_common
>>> qcom_glink_smem mdt_loader qmi_helpers drm backlight socinfo rmtfs_mem
>>> [    6.448278] CPU: 6 UID: 0 PID: 385 Comm: (udev-worker) Not tainted
>>> 6.16.0-rc2-next-20250620 #1 PREEMPT
>>> [    6.448288] Hardware name: Thundercomm Dragonboard 845c (DT)
>>> [    6.448292] pstate: 20400005 (nzCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
>>> [    6.448299] pc : ufs_qcom_setup_clocks+0x28/0x148 ufs_qcom
>>> [    6.448317] lr : ufshcd_setup_clocks
>>> (drivers/ufs/core/ufshcd-priv.h:142 drivers/ufs/core/ufshcd.c:9290)
>>> [    6.448332] sp : ffff800081213640
>>> [    6.448335] x29: ffff800081213640 x28: 0000000000000001 x27: ffff00008b633270
>>> [    6.448347] x26: ffff00008b6332a0 x25: ffff00008b632870 x24: 0000000000000000
>>> [    6.448359] x23: ffff00008b633280 x22: ffff00008b6332a0 x21: 0000000000000000
>>> [    6.448369] x20: ffffd7eabf84d618 x19: ffff00008b632870 x18: 0000000000000000
>>> [    6.448380] x17: 5453595342555300 x16: 305f666d745f6973 x15: 0000000000000100
>>> [    6.448391] x14: ffffffffffffffff x13: 0000000000000030 x12: 0101010101010101
>>> [    6.448402] x11: ffff00008188ea18 x10: 0000000000000000 x9 : ffffd7eabd9c3c28
>>> [    6.448413] x8 : ffff8000812134b8 x7 : fefefefefefefefe x6 : 0000000000000001
>>> [    6.448423] x5 : ffffffffffffffc8 x4 : 00000000c0000000 x3 : ffffd7eab32aa058
>>> [    6.448433] x2 : 0000000000000000 x1 : 0000000000000001 x0 : ffff00008b632870
>>> [    6.448444] Call trace:
>>> [    6.448449] ufs_qcom_setup_clocks+0x28/0x148 ufs_qcom (P)
>>> [    6.448466] ufshcd_setup_clocks (drivers/ufs/core/ufshcd-priv.h:142
>>> drivers/ufs/core/ufshcd.c:9290)
>>> [    6.448477] ufshcd_init (drivers/ufs/core/ufshcd.c:9468
>>> drivers/ufs/core/ufshcd.c:10636)
>>> [    6.448485] ufshcd_pltfrm_init (drivers/ufs/host/ufshcd-pltfrm.c:504)
>>> [    6.448495] ufs_qcom_probe+0x28/0x68 ufs_qcom
>>> [    6.448508] platform_probe (drivers/base/platform.c:1404)
>>> [    6.448519] really_probe (drivers/base/dd.c:579 drivers/base/dd.c:657)
>>> [    6.448526] __driver_probe_device (drivers/base/dd.c:799)
>>> [    6.448532] driver_probe_device (drivers/base/dd.c:829)
>>> [    6.448539] __driver_attach (drivers/base/dd.c:1216)
>>> [    6.448545] bus_for_each_dev (drivers/base/bus.c:370)
>>> [    6.448556] driver_attach (drivers/base/dd.c:1234)
>>> [    6.448567] bus_add_driver (drivers/base/bus.c:678)
>>> [    6.448577] driver_register (drivers/base/driver.c:249)
>>> [    6.448584] __platform_driver_register (drivers/base/platform.c:868)
>>> [    6.448592] ufs_qcom_pltform_init+0x28/0xff8 ufs_qcom
>>> [    6.448605] do_one_initcall (init/main.c:1274)
>>> [    6.448615] do_init_module (kernel/module/main.c:3041)
>>> [    6.448626] load_module (kernel/module/main.c:3511)
>>> [    6.448635] init_module_from_file (kernel/module/main.c:3704)
>>> [    6.448644] __arm64_sys_finit_module (kernel/module/main.c:3715
>>> kernel/module/main.c:3741 kernel/module/main.c:3725
>>> kernel/module/main.c:3725)
>>> [    6.448653] invoke_syscall (arch/arm64/include/asm/current.h:19
>>> arch/arm64/kernel/syscall.c:54)
>>> [    6.448661] el0_svc_common.constprop.0
>>> (include/linux/thread_info.h:135 (discriminator 2)
>>> arch/arm64/kernel/syscall.c:140 (discriminator 2))
>>> [    6.448668] do_el0_svc (arch/arm64/kernel/syscall.c:152)
>>> [    6.448674] el0_svc (arch/arm64/include/asm/irqflags.h:82
>>> (discriminator 1) arch/arm64/include/asm/irqflags.h:123 (discriminator
>>> 1) arch/arm64/include/asm/irqflags.h:136 (discriminator 1)
>>> arch/arm64/kernel/entry-common.c:165 (discriminator 1)
>>> arch/arm64/kernel/entry-common.c:178 (discriminator 1)
>>> arch/arm64/kernel/entry-common.c:768 (discriminator 1))
>>> [    6.448685] el0t_64_sync_handler (arch/arm64/kernel/entry-common.c:787)
>>> [    6.448694] el0t_64_sync (arch/arm64/kernel/entry.S:600)
>>> [ 6.448705] Code: a90157f3 aa0003f3 f90013f6 f9405c15 (f94002b6)
>>> All code
>>> ========
>>>      0: a90157f3 stp x19, x21, [sp, #16]
>>>      4: aa0003f3 mov x19, x0
>>>      8: f90013f6 str x22, [sp, #32]
>>>      c: f9405c15 ldr x21, [x0, #184]
>>>     10:* f94002b6 ldr x22, [x21] <-- trapping instruction
>>>
>>> Code starting with the faulting instruction
>>> ===========================================
>>>      0: f94002b6 ldr x22, [x21]
>>> [    6.448710] ---[ end trace 0000000000000000 ]---
>>>
>>> ## Source
>>> * Kernel version: 6.16.0-rc2-next-20250620
>>> * Git tree: https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next.git
>>> * Git sha: 2c923c845768a0f0e34b8161d70bc96525385782
>>> * Git describe: next-20250620
>>> * Project details:
>>> https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20250620/
>>> * Architectures: arm64 Dragonboard 845c
>>> * Toolchains: gcc-13
>>> * Kconfigs: defconfig+lkfttestconfigs
>>>
>>> ## Build arm64
>>> * Test log: https://qa-reports.linaro.org/api/testruns/28811906/log_file/
>>> * Test Lava log: https://lkft.validation.linaro.org/scheduler/job/8323501#L5646
>>> * Test Lava log 2:
>>> https://lkft.validation.linaro.org/scheduler/job/8323351#L5682
>>> * Test details:
>>> https://regressions.linaro.org/lkft/linux-next-master/next-20250620/boot/gcc-13-lkftconfig/
>>> * Build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/2yj4otvwBRT4UktLTyKEN8ZtUQm/
>>> * Kernel config:
>>> https://storage.tuxsuite.com/public/linaro/lkft/builds/2yj4otvwBRT4UktLTyKEN8ZtUQm/config
>>>
>>> --
>>> Linaro LKFT
>>> https://lkft.linaro.org

