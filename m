From: "jidong xiao" <jidong.xiao@gmail.com>
Subject: Question about scsi_host_alloc
Date: Wed, 18 Jul 2007 19:00:01 +0800
Message-ID: <4104961b0707180400l62a7eda7p5ec0770ddb69651b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.176]:52537 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757514AbXGRLAE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Jul 2007 07:00:04 -0400
Received: by el-out-1112.google.com with SMTP id j27so5396elf
        for <linux-scsi@vger.kernel.org>; Wed, 18 Jul 2007 04:00:02 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I see this function,struct Scsi_Host *scsi_host_alloc(struct
scsi_host_template *, int), I am wondering what does the second
parameter used for?Say,

/**
 * scsi_host_alloc - register a scsi host adapter instance.
 * @sht:	pointer to scsi host template
 * @privsize:	extra bytes to allocate for driver
 *
 * Note:
 * 	Allocate a new Scsi_Host and perform basic initialization.
 * 	The host is not published to the scsi midlayer until scsi_add_host
 * 	is called.
 *
 * Return value:
 * 	Pointer to a new Scsi_Host
 **/
struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)

I mean the privsize, i.e. extra bytes, why do we need such extra
bytes?Who will use it?

Regards
Jason Xiao
