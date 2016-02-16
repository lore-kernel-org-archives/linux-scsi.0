From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 5/6] hisi_sas: add hisi_sas_slave_configure()
Date: Tue, 16 Feb 2016 16:33:55 +0100
Message-ID: <56C34163.70606@suse.de>
References: <1455625351-165881-1-git-send-email-john.garry@huawei.com>
 <1455625351-165881-6-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1455625351-165881-6-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>, JBottomley@odin.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 02/16/2016 01:22 PM, John Garry wrote:
> In high-datarate aging tests, it is found that
> the SCSI framework can periodically
> issue lu resets to the device. This is because scsi
> commands begin to timeout. It is found that TASK SET
> FULL may be returned many times for the same command,
> causing the timeouts.
> To overcome this, the queue depth for the device needs
> to be reduced to 64 (from 256, set in
> sas_slave_configure()).
>=20
Hmm. TASK SET FULL should cause the queue depth to be reduced
automatically, no?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
