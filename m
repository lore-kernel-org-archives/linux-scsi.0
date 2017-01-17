From: Fam Zheng <famz@redhat.com>
Subject: Re: [PATCH 2/2] virtio_scsi: Implement fc_host
Date: Tue, 17 Jan 2017 11:40:21 +0800
Message-ID: <20170117034021.GB21563@lemon.Home>
References: <20170116160430.11815-3-famz@redhat.com>
	<201701170223.3QJ4sR4f%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <201701170223.3QJ4sR4f%fengguang.wu@intel.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: kbuild test robot <lkp@intel.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, kbuild-all@01.org, stefanha@redhat.com, Paolo Bonzini <pbonzini@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 01/17 03:02, kbuild test robot wrote:
> Hi Fam,
> 
> [auto build test ERROR on linus/master]
> [also build test ERROR on v4.10-rc4 next-20170116]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
> 
> url:    https://github.com/0day-ci/linux/commits/Fam-Zheng/virtio-scsi-Implement-FC_HOST-feature/20170117-011950
> config: i386-randconfig-r0-201703 (attached as .config)
> compiler: gcc-5 (Debian 5.4.1-2) 5.4.1 20160904
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=i386 
> 
> All errors (new ones prefixed by >>):
> 
>    drivers/built-in.o: In function `init':
> >> virtio_scsi.c:(.init.text+0x10d52): undefined reference to `fc_attach_transport'
>    drivers/built-in.o: In function `fini':
> >> virtio_scsi.c:(.exit.text+0x14a4): undefined reference to `fc_release_transport'

This is good catch.

Looks like virtio-scsi will now have to depend on fc, or we wrap the fc code
with #ifdef's.

Fam
