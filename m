From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Is there any tool can perform a READ Capacity command?
Date: Thu, 02 Aug 2007 10:43:11 -0400
Message-ID: <yq13az2uhds.fsf@sermon.lab.mkp.net>
References: <4104961b0708020730r703557f4gf3df1dd508165a89@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:54366 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753262AbXHBOoU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Aug 2007 10:44:20 -0400
In-Reply-To: <4104961b0708020730r703557f4gf3df1dd508165a89@mail.gmail.com> (jidong xiao's message of "Thu, 2 Aug 2007 22:30:29 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jidong xiao <jidong.xiao@gmail.com>
Cc: linux-scsi@vger.kernel.org

>>>>> "jidong" == jidong xiao <jidong.xiao@gmail.com> writes:

jidong> I know sg_modes can help to perform a SCSI MODE SENSE command,
jidong> is there any tool/command that can perform a READ Capacity
jidong> command?

sg_readcap

-- 
Martin K. Petersen	Oracle Linux Engineering

