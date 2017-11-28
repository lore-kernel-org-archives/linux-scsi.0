From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] libsas: flush pending destruct work in
 sas_unregister_domain_devices()
Date: Tue, 28 Nov 2017 09:20:49 +0100
Message-ID: <20171128082049.5smff3hvrkwrf77o@linux-x5ow.site>
References: <20171128002445.16594-1-xiyou.wangcong@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35308 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751900AbdK1IUu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 28 Nov 2017 03:20:50 -0500
Content-Disposition: inline
In-Reply-To: <20171128002445.16594-1-xiyou.wangcong@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, Praveen Murali <pmurali@logicube.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

On Mon, Nov 27, 2017 at 04:24:45PM -0800, Cong Wang wrote:
> We saw dozens of the following kernel waring:
> 
>  WARNING: CPU: 0 PID: 705 at fs/sysfs/group.c:224 sysfs_remove_group+0x54/0x88()
>  sysfs group ffffffff81ab7670 not found for kobject '6:0:3:0'
>  Modules linked in: cpufreq_ondemand x86_pkg_temp_thermal coretemp kvm_intel kvm microcode raid0 iTCO_wdt iTCO_vendor_support sb_edac edac_core lpc_ich mfd_core ioatdma i2c_i801 shpchp wmi hed acpi_cpufreq lp parport tcp_diag inet_diag ipmi_si ipmi_devintf ipmi_msghandler sch_fq_codel igb ptp pps_core i2c_algo_bit i2c_core crc32c_intel isci libsas scsi_transport_sas dca ipv6
>  CPU: 0 PID: 705 Comm: kworker/u240:0 Not tainted 4.1.35.el7.x86_64 #1

This should by now be fixed with commit fbce4d97fd43 ("scsi: fixup kernel
warning during rmmod()" which went into v4.14-rc6.

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
