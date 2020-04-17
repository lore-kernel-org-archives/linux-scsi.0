Return-Path: <SRS0=7BVi=6B=vger.kernel.org=linux-scsi-owner@kernel.org>
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E8BEC2BB1D
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Apr 2020 04:58:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1610F22202
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Apr 2020 04:58:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jRm034qB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbgDQE6X (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Apr 2020 00:58:23 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:60412 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726474AbgDQE6X (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Apr 2020 00:58:23 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03H4wIps083228;
        Fri, 17 Apr 2020 04:58:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=4fA+uo2+kbO1yrStw3/44Haes7+KfdjtvZ+XBtR/v08=;
 b=jRm034qBaO0DfV2lDCssiAOD2mKQija6OZb5kXkQsXx6WkeTEB+Nxm4zMXZiVv6dHrph
 IGptSbbF/Vp5xYcZ5NF0+rV1+veirMjNmOt+0KZs3Hdr1wNi3IpMl1qzoV3Hg7lss3YB
 7FBqedvob9EZM91L/mZboVZ0AoPdllF5Hi7WIj/CkAAq6465Pndh2tq58eqokyr4GDU8
 TrlFpdM/qoYL6fc7sjmv8sd4CJJzsPfPTeOsbvVPu0kXc8qRGeJGBMZGZH7DvuXON3zq
 WJoTswjOxxwe/RTRMsgy8tlqxY5Fy37qhE/LvFYe217YxiVxSgstRssyJavB7xyNA3xo zw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 30emejmtjw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Apr 2020 04:58:18 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03H4v8wS055625;
        Fri, 17 Apr 2020 04:58:18 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 30emeptj99-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Apr 2020 04:58:18 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03H4wHLx011804;
        Fri, 17 Apr 2020 04:58:17 GMT
Received: from [192.168.1.14] (/114.88.246.185)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 16 Apr 2020 21:58:17 -0700
Subject: Re: [scsi] a2ab7a1a38:
 WARNING:at_kernel/workqueue.c:#workqueue_sysfs_register
To:     kernel test robot <lkp@intel.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        lkp@lists.01.org
References: <20200417032305.GC26326@shao2-debian>
From:   Bob Liu <bob.liu@oracle.com>
Message-ID: <ff48bfdb-e8d4-58ec-8318-6fedd93488d8@oracle.com>
Date:   Fri, 17 Apr 2020 12:58:12 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200417032305.GC26326@shao2-debian>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9593 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004170037
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9593 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 impostorscore=0
 mlxscore=0 suspectscore=0 lowpriorityscore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 adultscore=0 phishscore=0 clxscore=1011 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004170037
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/17/20 11:23 AM, kernel test robot wrote:
> Greeting,
> > FYI, we noticed the following commit (built with gcc-7):
> 
> commit: a2ab7a1a38f4448a65b92bb1089f4feeb66f2015 ("[PATCH] scsi: iscsi: register sysfs for iscsi workqueue")
> url: https://urldefense.com/v3/__https://github.com/0day-ci/linux/commits/Bob-Liu/scsi-iscsi-register-sysfs-for-iscsi-workqueue/20200416-103108__;!!GqivPVa7Brio!Jjn2aP2TksliGs__LTE_GWRKPf7Vaiffy8tHW75AVPbDpSMnIP8aYAX9TnD7Vw$ 
> base: https://urldefense.com/v3/__https://git.kernel.org/cgit/linux/kernel/git/mkp/scsi.git__;!!GqivPVa7Brio!Jjn2aP2TksliGs__LTE_GWRKPf7Vaiffy8tHW75AVPbDpSMnIP8aYAVNDDBj1g$  for-next
> 

Thanks, let me check how to workaround this. 

> in testcase: boot
> 
> on test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 8G
> 
> caused below changes (please refer to attached dmesg/kmsg for entire log/backtrace):
> 
> 
> +---------------------------------------------------------+------------+------------+
> |                                                         | 1e4ffb8344 | a2ab7a1a38 |
> +---------------------------------------------------------+------------+------------+
> | boot_successes                                          | 16         | 0          |
> | boot_failures                                           | 0          | 12         |
> | WARNING:at_kernel/workqueue.c:#workqueue_sysfs_register | 0          | 11         |
> | RIP:workqueue_sysfs_register                            | 0          | 11         |
> | BUG:kernel_hang_in_boot_stage                           | 0          | 1          |
> +---------------------------------------------------------+------------+------------+
> 
> 
> If you fix the issue, kindly add following tag
> Reported-by: kernel test robot <lkp@intel.com>
> 
> 
> [    6.127134] WARNING: CPU: 1 PID: 1 at kernel/workqueue.c:5642 workqueue_sysfs_register+0x18/0x103
> [    6.128910] Modules linked in:
> [    6.128910] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 5.7.0-rc1-00026-ga2ab7a1a38f44 #1
> [    6.128910] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
> [    6.128910] RIP: 0010:workqueue_sysfs_register+0x18/0x103
> [    6.128910] Code: 00 48 89 d8 74 05 e8 38 51 fe ff 48 83 c4 48 5b 5d c3 66 66 66 66 90 41 57 41 56 41 55 41 54 55 53 f6 87 02 01 00 00 08 74 0d <0f> 0b 41 bd ea ff ff ff e9 d0 00 00 00 48 89 fd bf e8 02 00 00 41
> [    6.128910] RSP: 0000:ffffc90000013d80 EFLAGS: 00010202
> [    6.128910] RAX: 0000000000000000 RBX: ffff88820bf61a00 RCX: 0000000000000000
> [    6.128910] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88820bf61a00
> [    6.128910] RBP: ffffc90000013e48 R08: 000000000000000c R09: ffff88820befdc10
> [    6.128910] R10: ffff888226031080 R11: ffff88822a550800 R12: 0000000000000000
> [    6.128910] R13: ffff88820bf61a20 R14: ffff88820bf61a10 R15: ffff88820bf61ab0
> [    6.128910] FS:  0000000000000000(0000) GS:ffff88823fd00000(0000) knlGS:0000000000000000
> [    6.128910] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    6.128910] CR2: 00000000ffaddf14 CR3: 000000000280a000 CR4: 00000000000406e0
> [    6.128910] Call Trace:
> [    6.128910]  alloc_workqueue+0x36c/0x41f
> [    6.128910]  ? rdinit_setup+0x2b/0x2b
> [    6.128910]  ? fc_transport_init+0x8e/0x8e
> [    6.128910]  iscsi_transport_init+0x141/0x20b
> [    6.128910]  ? iscsi_free_session+0x6b/0x6b
> [    6.128910]  do_one_initcall+0x9d/0x1c0
> [    6.128910]  kernel_init_freeable+0x1e3/0x246
> [    6.128910]  ? rest_init+0xc6/0xc6
> [    6.128910]  kernel_init+0xa/0xff
> [    6.128910]  ret_from_fork+0x3a/0x50
> [    6.128910] ---[ end trace 4d791dec3fcee1ed ]---
> 
> 
> To reproduce:
> 
>         # build kernel
> 	cd linux
> 	cp config-5.7.0-rc1-00026-ga2ab7a1a38f44 .config
> 	make HOSTCC=gcc-7 CC=gcc-7 ARCH=x86_64 olddefconfig prepare modules_prepare bzImage
> 
>         git clone https://urldefense.com/v3/__https://github.com/intel/lkp-tests.git__;!!GqivPVa7Brio!Jjn2aP2TksliGs__LTE_GWRKPf7Vaiffy8tHW75AVPbDpSMnIP8aYAVgkKitTA$ 
>         cd lkp-tests
>         bin/lkp qemu -k <bzImage> job-script # job-script is attached in this email
> 
> 
> 
> Thanks,
> lkp
> 

