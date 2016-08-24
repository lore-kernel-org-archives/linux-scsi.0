From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v4 2/3] ses: use scsi_is_sas_rphy instead of
 is_sas_attached
Date: Wed, 24 Aug 2016 09:22:40 +0200
Message-ID: <20160824072240.a3urxirynhbpscmz@c203.arch.suse.de>
References: <34f1f359e3a7c5ca573c3ca52b110c13666fc22e.1471426748.git.jthumshirn@suse.de>
 <201608221651.bdFG6dJi%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201608221651.bdFG6dJi%fengguang.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: kbuild test robot <lkp@intel.com>
Cc: kbuild-all@01.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Aug 22, 2016 at 04:57:39PM +0800, kbuild test robot wrote:
> Hi Johannes,
> 
> [auto build test ERROR on scsi/for-next]
> [also build test ERROR on v4.8-rc3]
> [cannot apply to next-20160822]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
> [Suggest to use git(>=2.9.0) format-patch --base=<commit> (or --base=auto for convenience) to record what (public, well-known) commit your patch series was built on]
> [Check https://git-scm.com/docs/git-format-patch for more information]
> 
> url:    https://github.com/0day-ci/linux/commits/Johannes-Thumshirn/Fix-panic-when-a-SES-device-is-attached-to-a-hpsa-logical-volume/20160815-231901
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
> config: x86_64-randconfig-n0-08182202 (attached as .config)
> compiler: gcc-4.8 (Debian 4.8.4-1) 4.8.4
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=x86_64 
> 
> All errors (new ones prefixed by >>):
> 
>    drivers/built-in.o: In function `ses_match_to_enclosure':
> >> ses.c:(.text+0x548dae): undefined reference to `scsi_is_sas_rphy'

Sorry I was not able to reproduce this using the provided config
(neither with James' tree nor Martin's).

Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
