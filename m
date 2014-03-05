From: Andy Grover <agrover@redhat.com>
Subject: Re: [PATCH 6/8] target_core_spc: Include target device descriptor
 in VPD page 83
Date: Wed, 05 Mar 2014 11:45:10 -0800
Message-ID: <53177EC6.6090300@redhat.com>
References: <1387268330-121064-1-git-send-email-hare@suse.de>	 <1387268330-121064-7-git-send-email-hare@suse.de>	 <1387309849.20247.306.camel@haakon3.risingtidesystems.com> <1387310505.20247.309.camel@haakon3.risingtidesystems.com> <52B168F5.9060300@suse.de> <53177DED.8050307@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9575 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753986AbaCETpP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Mar 2014 14:45:15 -0500
In-Reply-To: <53177DED.8050307@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Nic Bellinger <nab@daterainc.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

On 03/05/2014 11:41 AM, Andy Grover wrote:
> Hi, fbfe858 only bumps INQUIRY_BUF to 768 although the comment says
> 1024, is this expected and ok?

Doh, read the diff backwards, disregard. -- Andy

