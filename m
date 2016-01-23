From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH] mptlan: add checks for dma mapping errors
Date: Sat, 23 Jan 2016 10:03:30 +0800
Message-ID: <201601231054.reic1pUd%fengguang.wu@intel.com>
References: <1453503833-9945-1-git-send-email-khoroshilov@ispras.ru>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="zhXaljGHf11kAtnf"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:33928 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754732AbcAWCEI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Jan 2016 21:04:08 -0500
Content-Disposition: inline
In-Reply-To: <1453503833-9945-1-git-send-email-khoroshilov@ispras.ru>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: kbuild-all@01.org, Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, Alexey Khoroshilov <khoroshilov@ispras.ru>, MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org


--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Alexey,

[auto build test WARNING on v4.4-rc8]
[also build test WARNING on next-20160122]
[if your patch is applied to the wrong git tree, please drop us a note to help improving the system]

url:    https://github.com/0day-ci/linux/commits/Alexey-Khoroshilov/mptlan-add-checks-for-dma-mapping-errors/20160123-070633
config: x86_64-randconfig-s1-01230930 (attached as .config)
reproduce:
        # save the attached .config to linux build tree
        make ARCH=x86_64 

All warnings (new ones prefixed by >>):

   In file included from include/uapi/linux/stddef.h:1:0,
                    from include/linux/stddef.h:4,
                    from include/uapi/linux/posix_types.h:4,
                    from include/uapi/linux/types.h:13,
                    from include/linux/types.h:5,
                    from include/linux/list.h:4,
                    from include/linux/module.h:9,
                    from drivers/message/fusion/mptlan.h:55,
                    from drivers/message/fusion/mptlan.c:55:
   drivers/message/fusion/mptlan.c: In function 'mpt_lan_sdu_send':
   drivers/message/fusion/mptlan.c:737:24: warning: passing argument 1 of 'dma_mapping_error' from incompatible pointer type [-Wincompatible-pointer-types]
     if (dma_mapping_error(mpt_dev->pcidev, dma)) {
                           ^
   include/linux/compiler.h:147:28: note: in definition of macro '__trace_if'
     if (__builtin_constant_p((cond)) ? !!(cond) :   \
                               ^
>> drivers/message/fusion/mptlan.c:737:2: note: in expansion of macro 'if'
     if (dma_mapping_error(mpt_dev->pcidev, dma)) {
     ^
   In file included from arch/x86/include/asm/dma-mapping.h:49:0,
                    from include/linux/dma-mapping.h:87,
                    from include/linux/skbuff.h:34,
                    from include/linux/if_ether.h:23,
                    from include/uapi/linux/ethtool.h:17,
                    from include/linux/ethtool.h:16,
                    from include/linux/netdevice.h:42,
                    from drivers/message/fusion/mptlan.h:58,
                    from drivers/message/fusion/mptlan.c:55:
   include/asm-generic/dma-mapping-common.h:316:19: note: expected 'struct device *' but argument is of type 'struct pci_dev *'
    static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
                      ^
   In file included from include/uapi/linux/stddef.h:1:0,
                    from include/linux/stddef.h:4,
                    from include/uapi/linux/posix_types.h:4,
                    from include/uapi/linux/types.h:13,
                    from include/linux/types.h:5,
                    from include/linux/list.h:4,
                    from include/linux/module.h:9,
                    from drivers/message/fusion/mptlan.h:55,
                    from drivers/message/fusion/mptlan.c:55:
   drivers/message/fusion/mptlan.c:737:24: warning: passing argument 1 of 'dma_mapping_error' from incompatible pointer type [-Wincompatible-pointer-types]
     if (dma_mapping_error(mpt_dev->pcidev, dma)) {
                           ^
   include/linux/compiler.h:147:40: note: in definition of macro '__trace_if'
     if (__builtin_constant_p((cond)) ? !!(cond) :   \
                                           ^
>> drivers/message/fusion/mptlan.c:737:2: note: in expansion of macro 'if'
     if (dma_mapping_error(mpt_dev->pcidev, dma)) {
     ^
   In file included from arch/x86/include/asm/dma-mapping.h:49:0,
                    from include/linux/dma-mapping.h:87,
                    from include/linux/skbuff.h:34,
                    from include/linux/if_ether.h:23,
                    from include/uapi/linux/ethtool.h:17,
                    from include/linux/ethtool.h:16,
                    from include/linux/netdevice.h:42,
                    from drivers/message/fusion/mptlan.h:58,
                    from drivers/message/fusion/mptlan.c:55:
   include/asm-generic/dma-mapping-common.h:316:19: note: expected 'struct device *' but argument is of type 'struct pci_dev *'
    static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
                      ^
   In file included from include/uapi/linux/stddef.h:1:0,
                    from include/linux/stddef.h:4,
                    from include/uapi/linux/posix_types.h:4,
                    from include/uapi/linux/types.h:13,
                    from include/linux/types.h:5,
                    from include/linux/list.h:4,
                    from include/linux/module.h:9,
                    from drivers/message/fusion/mptlan.h:55,
                    from drivers/message/fusion/mptlan.c:55:
   drivers/message/fusion/mptlan.c:737:24: warning: passing argument 1 of 'dma_mapping_error' from incompatible pointer type [-Wincompatible-pointer-types]
     if (dma_mapping_error(mpt_dev->pcidev, dma)) {
                           ^
   include/linux/compiler.h:158:16: note: in definition of macro '__trace_if'
      ______r = !!(cond);     \
                   ^
>> drivers/message/fusion/mptlan.c:737:2: note: in expansion of macro 'if'
     if (dma_mapping_error(mpt_dev->pcidev, dma)) {
     ^
   In file included from arch/x86/include/asm/dma-mapping.h:49:0,
                    from include/linux/dma-mapping.h:87,
                    from include/linux/skbuff.h:34,
                    from include/linux/if_ether.h:23,
                    from include/uapi/linux/ethtool.h:17,
                    from include/linux/ethtool.h:16,
                    from include/linux/netdevice.h:42,
                    from drivers/message/fusion/mptlan.h:58,
                    from drivers/message/fusion/mptlan.c:55:
   include/asm-generic/dma-mapping-common.h:316:19: note: expected 'struct device *' but argument is of type 'struct pci_dev *'
    static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
                      ^

vim +/if +737 drivers/message/fusion/mptlan.c

   721		ctx = priv->mpt_txfidx[priv->mpt_txfidx_tail--];
   722		spin_unlock_irqrestore(&priv->txfidx_lock, flags);
   723	
   724	//	dioprintk((KERN_INFO MYNAM ": %s/%s: Creating new msg frame (send).\n",
   725	//			IOC_AND_NETDEV_NAMES_s_s(dev)));
   726	
   727		pSendReq = (LANSendRequest_t *) mf;
   728	
   729		/* Set the mac.raw pointer, since this apparently isn't getting
   730		 * done before we get the skb. Pull the data pointer past the mac data.
   731		 */
   732		skb_reset_mac_header(skb);
   733		skb_pull(skb, 12);
   734	
   735	        dma = pci_map_single(mpt_dev->pcidev, skb->data, skb->len,
   736				     PCI_DMA_TODEVICE);
 > 737		if (dma_mapping_error(mpt_dev->pcidev, dma)) {
   738			netif_stop_queue(dev);
   739	
   740			printk (KERN_ERR "%s: dma mapping failed\n", __func__);
   741			return NETDEV_TX_BUSY;
   742		}
   743	
   744		priv->SendCtl[ctx].skb = skb;
   745		priv->SendCtl[ctx].dma = dma;

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--zhXaljGHf11kAtnf
Content-Type: application/octet-stream
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
w1ppRQPk/wOIIECU7HkBAA==

--zhXaljGHf11kAtnf--
