From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: [PATCH 2/4] fusion - remove whitespace
Date: Wed, 1 Jun 2005 10:47:36 -0600
Message-ID: <200506011047.36655.Eric.Moore@lsil.com>
Reply-To: Eric.Moore@lsil.com
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_oaenCTLj7snwPkK"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:53733 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261462AbVFAQuy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jun 2005 12:50:54 -0400
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.8/8.12.8) with ESMTP id j51GlXo7007763
	for <linux-scsi@vger.kernel.org>; Wed, 1 Jun 2005 09:47:33 -0700 (PDT)
Received: from mailmux (popmil.lsil.com [147.145.13.217])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with SMTP id j51GorTv005816
	for <linux-scsi@vger.kernel.org>; Wed, 1 Jun 2005 09:50:53 -0700
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux scsi <linux-scsi@vger.kernel.org>


--Boundary-00=_oaenCTLj7snwPkK
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

mptfusion patch 2/4:

This patch can also be found at this URL:
ftp://ftp.lsil.com/HostAdapterDrivers/linux/Fusion-MPT/2.6-kernel/3.03.03/


Changelog:
* killing white space 

Signed-off-by: Eric.Moore<Eric.Moore@lsil.com>

--Boundary-00=_oaenCTLj7snwPkK
Content-Type: text/x-diff;
  charset="us-ascii";
  name="sas_upates2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="sas_upates2.patch"

--- b/drivers/message/fusion/mptlan.c	2005-05-10 14:27:13.000000000 -0600
+++ a/drivers/message/fusion/mptlan.c	2005-05-26 12:05:37.000000000 -0600
@@ -852,7 +852,7 @@
  */
 {
 	struct mpt_lan_priv *priv = dev->priv;
-	
+
 	if (test_and_set_bit(0, &priv->post_buckets_active) == 0) {
 		if (priority) {
 			schedule_work(&priv->post_buckets_task);
@@ -1169,22 +1169,22 @@
 			"(priv->buckets_out = %d)\n",
 			IOC_AND_NETDEV_NAMES_s_s(dev),
 			remaining, atomic_read(&priv->buckets_out));
-	
+
 	if ((remaining < priv->bucketthresh) &&
 	    ((atomic_read(&priv->buckets_out) - remaining) >
 	     MPT_LAN_BUCKETS_REMAIN_MISMATCH_THRESH)) {
-		
+
 		printk (KERN_WARNING MYNAM " Mismatch between driver's "
 			"buckets_out count and fw's BucketsRemaining "
 			"count has crossed the threshold, issuing a "
 			"LanReset to clear the fw's hashtable. You may "
 			"want to check your /var/log/messages for \"CRC "
 			"error\" event notifications.\n");
-		
+
 		mpt_lan_reset(dev);
 		mpt_lan_wake_post_buckets_task(dev, 0);
 	}
-	
+
 	return mpt_lan_receive_skb(dev, skb);
 }
 
@@ -1456,7 +1456,7 @@
 			       ioc->pfacts[i].PortNumber);
 			continue;
 		}
-		
+
 		printk(KERN_INFO MYNAM ": %s: Fusion MPT LAN device "
 		       "registered as '%s'\n", ioc->name, dev->name);
 		printk(KERN_INFO MYNAM ": %s/%s: "
@@ -1465,7 +1465,7 @@
 		       dev->dev_addr[0], dev->dev_addr[1],
 		       dev->dev_addr[2], dev->dev_addr[3],
 		       dev->dev_addr[4], dev->dev_addr[5]);
-	
+
 		ioc->netdev = dev;
 
 		return 0;
@@ -1513,7 +1513,7 @@
 	}
 
 	dlprintk((KERN_INFO MYNAM ": Registered for IOC reset notifications\n"));
-	
+
 	if (mpt_device_driver_register(&mptlan_driver, MPTLAN_DRIVER))
 		dprintk((KERN_INFO MYNAM ": failed to register dd callbacks\n"));
 	return 0;
--- b/drivers/message/fusion/mptspi.c	2005-05-05 10:19:45.000000000 -0600
+++ a/drivers/message/fusion/mptspi.c	2005-05-26 11:56:17.000000000 -0600
@@ -175,15 +175,15 @@
 	u8			*mem;
 	int			error=0;
 	int			r;
-	
+
 	if ((r = mpt_attach(pdev,id)) != 0)
 		return r;
-	
+
 	ioc = pci_get_drvdata(pdev);
 	ioc->DoneCtx = mptspiDoneCtx;
 	ioc->TaskCtx = mptspiTaskCtx;
 	ioc->InternalCtx = mptspiInternalCtx;
-	
+
 	/*  Added sanity check on readiness of the MPT adapter.
 	 */
 	if (ioc->last_state != MPI_IOC_STATE_OPERATIONAL) {
@@ -468,7 +468,7 @@
 mptspi_exit(void)
 {
 	pci_unregister_driver(&mptspi_driver);
-	
+
 	mpt_reset_deregister(mptspiDoneCtx);
 	dprintk((KERN_INFO MYNAM
 	  ": Deregistered for IOC reset notifications\n"));
--- b/drivers/message/fusion/mptfc.c	2005-05-10 14:59:11.000000000 -0600
+++ a/drivers/message/fusion/mptfc.c	2005-05-26 11:57:03.000000000 -0600
@@ -165,10 +165,10 @@
 	u8			*mem;
 	int			error=0;
 	int			r;
-		
+
 	if ((r = mpt_attach(pdev,id)) != 0)
 		return r;
-	
+
 	ioc = pci_get_drvdata(pdev);
 	ioc->DoneCtx = mptfcDoneCtx;
 	ioc->TaskCtx = mptfcTaskCtx;
@@ -336,7 +336,7 @@
 
 	ddvprintk((MYIOC_s_INFO_FMT
 		"mpt_pq_filter %x\n",
-		ioc->name, 
+		ioc->name,
 		mpt_pq_filter));
 
 	init_waitqueue_head(&hd->scandv_waitq);
@@ -413,7 +413,7 @@
 mptfc_exit(void)
 {
 	pci_unregister_driver(&mptfc_driver);
-	
+
 	mpt_reset_deregister(mptfcDoneCtx);
 	dprintk((KERN_INFO MYNAM
 	  ": Deregistered for IOC reset notifications\n"));

--Boundary-00=_oaenCTLj7snwPkK--
