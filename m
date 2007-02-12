From: Santiago Leon <sleon@vt.edu>
Subject: Re: [PATCH 1/2] ibmvscsi: allow for dynamic adjustment of server
 request_limit
Date: Mon, 12 Feb 2007 09:42:19 -0600
Message-ID: <45D08ADB.6030606@vt.edu>
References: <20070209174949.5080.69663.sendpatchset@toy> <20070209174955.5080.80326.sendpatchset@toy>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-06.texas.rr.com ([24.93.47.45]:45873 "EHLO
	ms-smtp-06.texas.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933009AbXBLPlP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Feb 2007 10:41:15 -0500
Received: from [192.168.0.100] (cpe-66-69-212-176.austin.res.rr.com [66.69.212.176])
	by ms-smtp-06.texas.rr.com (8.13.6/8.13.6) with ESMTP id l1CFfDdH016754
	for <linux-scsi@vger.kernel.org>; Mon, 12 Feb 2007 09:41:14 -0600 (CST)
In-Reply-To: <20070209174955.5080.80326.sendpatchset@toy>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Robert Jennings wrote:
> The request limit calculations used previously on the client failed to
> mirror the state of the server.  Additionally, when a value < 3 was provided
> there could be problems setting can_queue and handling abort and reset 
> commands.

Signed-off-by: Santiago Leon <santil@us.ibm.com>

> Signed-off-by: "Robert Jennings" <rcj@linux.vnet.ibm.com>
