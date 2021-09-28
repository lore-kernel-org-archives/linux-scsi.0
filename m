Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A3B1C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 18:45:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20BA661262
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 18:45:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242235AbhI1SrU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Sep 2021 14:47:20 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:31260 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242251AbhI1SrO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Sep 2021 14:47:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1632854734; x=1664390734;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=frcCV1k9oG9oKj3dpUqdJg1PxRT2RSN/XKdLCPjaYaY=;
  b=CCzwVnTn4H3+AD3F21wGpvMBVmIV4b7Vm6qK5Ozgg9L7FkOBm62pS+OI
   uVO+VC85Gi/vKVpa+hQRG2cAAJ0IknIsNN0IgGGy33yUXJohbe3YM0BhV
   y4IjL2OMqiBmeIpMMQJqGTXYJB3O+Vd1WLVFVFvbvb8byE0ChiyxVwNQu
   mUHUL6t6r/WiWU+hNTfVqutLYj6de9CuG3ARM4+9+/PPHC6djpOiR4YWl
   3oZJ0c5lQV+UqWWduA3IMkJAeg1P9St/nrHPvc9r/wh1h4X8AlkmQQ/Rc
   maCsp2DYbC4/G3UFRPeWx7RrEVg3bfQPKVVXlmBXhJvsN9H7qLL5OJr/T
   Q==;
IronPort-SDR: Hre3T5Rz2CPwRxCt3G1yE0aQTp/q88vozCArHYc3O/ShQ6UrxWKkaFG1/jzpn8ULuN9Rin3wX3
 Islyni054XtLs0DkFvVZsNzbHRbUQzm4cpkdKZzHrC/9Fgwx/RGiBvQZ+yH1tR19NNHtxFsLLN
 2X5P2v+6qtsV2ZlvCqQLmDG/PhO3Roi1GGFKxFpCoyD4jq+vwBTePEzt3c7NFoWBFbmcGxcL1D
 kVcD4xlbH5CYmyc/eozanwyYHFwPaKxoi6/aAAMeMYubcNcqmrJnqs/DZ1cmTPmaB602Ruc2tS
 +KJXIs9FRKYP2dFbcRc7IaOy
X-IronPort-AV: E=Sophos;i="5.85,330,1624345200"; 
   d="scan'208";a="138300193"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Sep 2021 11:45:34 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Tue, 28 Sep 2021 11:45:33 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2176.14 via Frontend
 Transport; Tue, 28 Sep 2021 11:45:33 -0700
Subject: [PATCH 10/11] smartpqi: add 3252-8i pci id
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Tue, 28 Sep 2021 13:45:33 -0500
Message-ID: <163285473297.194893.7771240849559575313.stgit@brunhilda.pdev.net>
In-Reply-To: <163285461769.194893.178408874562704189.stgit@brunhilda.pdev.net>
References: <163285461769.194893.178408874562704189.stgit@brunhilda.pdev.net>
User-Agent: StGit/1.1+40.g1b20.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


