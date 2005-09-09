From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] SAS transport class
Date: Fri, 09 Sep 2005 18:38:27 -0500
Message-ID: <1126309108.4799.57.camel@mulgrave>
References: <20050909142250.GA13136@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:3245 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932611AbVIIXih (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Sep 2005 19:38:37 -0400
In-Reply-To: <20050909142250.GA13136@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 2005-09-09 at 16:22 +0200, Christoph Hellwig wrote:
> I think this submission is ready for 2.6.14, but additional comments are
> of course very welcome.

Actually, you missed a prototype change for the class functions.

James

diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -156,7 +156,8 @@ sas_bitfield_name_search(linkspeed, sas_
  * SAS host attributes
  */
 
-static int sas_host_setup(struct device *dev)
+static int sas_host_setup(struct transport_container *tc, struct device *dev,
+			  struct class_device *cdev)
 {
 	struct Scsi_Host *shost = dev_to_shost(dev);
 	struct sas_host_attrs *sas_host = to_sas_host_attrs(shost);


