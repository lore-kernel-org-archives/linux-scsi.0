From: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
Subject: Re: [PATCH 4/5] SCSI: qla2xxx, fix NULL-ptr dereference
Date: Fri, 25 Sep 2009 00:36:36 -0700
Message-ID: <3B8522E6-D391-4057-9F9D-84FC1019B337@qlogic.com>
References: <1253715335-6723-1-git-send-email-jirislaby@gmail.com>
 <1253715335-6723-4-git-send-email-jirislaby@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:9133 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343AbZIYHgd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Sep 2009 03:36:33 -0400
In-Reply-To: <1253715335-6723-4-git-send-email-jirislaby@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jiri Slaby <jirislaby@gmail.com>
Cc: "James.Bottomley@suse.de" <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org Mailing List" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>


On Sep 23, 2009, at 7:15 AM, Jiri Slaby wrote:

> Stanse found a NULL-ptr dereference on one fail path in
> qla25xx_create_rsp_que. It jumps to que_failed label and
> qla25xx_free_rsp_que there dereferences rsp which is NULL.
>
> Return with ENOMEM directly instead.
>
Thanks for pointing it out. There is another code path (create_req_que)
where the same bug exists. I will send a patch that takes care of the  
both.

-Anirban
