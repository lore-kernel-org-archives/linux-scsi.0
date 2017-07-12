From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v3 0/7] Enhance libsas hotplug feature
Date: Wed, 12 Jul 2017 13:56:22 +0200
Message-ID: <20170712115622.GC4115@linux-x5ow.site>
References: <1499670369-44143-1-git-send-email-wangyijing@huawei.com>
 <153868d4-9aa6-21b5-81f3-868668218cb2@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <153868d4-9aa6-21b5-81f3-868668218cb2@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: Yijing Wang <wangyijing@huawei.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, chenqilin2@huawei.com, hare@suse.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, chenxiang66@hisilicon.com, huangdaode@hisilicon.com, wangkefeng.wang@huawei.com, zhaohongjiang@huawei.com, dingtianhong@huawei.com, guohanjun@huawei.com, yanaijie@huawei.com, hch@lst.de, dan.j.williams@intel.com, emilne@redhat.com, thenzl@redhat.com, wefu@redhat.com, charles.chenxin@huawei.com, chenweilong@huawei.com, Linuxarm <linuxarm@huawei.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jul 12, 2017 at 10:59:27AM +0100, John Garry wrote:
> After:
> ...
> root@(none)$ echo 0 > ./phy-0:7/sas_phy/phy-0:7/enable
> root@(none)$ [  446.193336] hisi_sas_v2_hw HISI0162:01: found dev[8:1] is
> gone
> [  446.249205] hisi_sas_v2_hw HISI0162:01: found dev[7:1] is gone
> [  446.325201] hisi_sas_v2_hw HISI0162:01: found dev[6:1] is gone
> [  446.373189] hisi_sas_v2_hw HISI0162:01: found dev[5:1] is gone
> [  446.421187] hisi_sas_v2_hw HISI0162:01: found dev[4:1] is gone
> [  446.457232] hisi_sas_v2_hw HISI0162:01: found dev[3:1] is gone
> [  446.477151] sd 0:0:1:0: [sdb] Synchronizing SCSI cache
> [  446.482373] sd 0:0:1:0: [sdb] Synchronize Cache(10) failed: Result:
> hostbyte=0x04 driverbyte=0x00
> [  446.491238] sd 0:0:1:0: [sdb] Stopping disk
> [  446.495419] sd 0:0:1:0: [sdb] Start/Stop Unit failed: Result:
> hostbyte=0x04 driverbyte=0x00
> [  446.525227] hisi_sas_v2_hw HISI0162:01: found dev[2:5] is gone
> [  446.569249] hisi_sas_v2_hw HISI0162:01: found dev[1:1] is gone
> [  446.576872] hisi_sas_v2_hw HISI0162:01: found dev[0:2] is gone
> 
> root@(none)$
> 
> So much nicer. BTW, /dev/sdb is a SATA disk, the rest are SAS.

This is awesome. I hope I have some time reviewing the patches themselfes
soon.

	Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
