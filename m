From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH 16/17] lpfc: Use kzalloc instead of kmalloc
Date: Wed, 16 Dec 2015 18:04:28 -0600
Message-ID: <7D037592-6F10-44FE-8400-7E371D5089A6@linux.vnet.ibm.com>
References: <5671efc7.97bycJ6w84wBFCRH%james.smart@avagotech.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e11.ny.us.ibm.com ([129.33.205.201]:50351 "EHLO
	e11.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbbLQAEg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Dec 2015 19:04:36 -0500
Received: from localhost
	by e11.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Wed, 16 Dec 2015 19:04:36 -0500
Received: from d03av05.boulder.ibm.com (d03av05.boulder.ibm.com [9.17.195.85])
	by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id tBH04Xkq29950074
	for <linux-scsi@vger.kernel.org>; Wed, 16 Dec 2015 17:04:33 -0700
Received: from d03av05.boulder.ibm.com (localhost [127.0.0.1])
	by d03av05.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id tBH04V3R032703
	for <linux-scsi@vger.kernel.org>; Wed, 16 Dec 2015 17:04:32 -0700
In-Reply-To: <5671efc7.97bycJ6w84wBFCRH%james.smart@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@avagotech.com>
Cc: linux-scsi@vger.kernel.org

Reviewed-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>

