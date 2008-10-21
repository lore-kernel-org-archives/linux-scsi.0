From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 21/22] sata_qstor: kill dummy BMDMA ops
Date: Tue, 21 Oct 2008 20:27:39 +0900
Message-ID: <48FDBCAB.7050702@kernel.org>
References: <1224580680-13698-1-git-send-email-tj@kernel.org> <1224580680-13698-22-git-send-email-tj@kernel.org> <48FDAAA2.7090002@ru.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:50266 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752703AbYJUL3w (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Oct 2008 07:29:52 -0400
In-Reply-To: <48FDAAA2.7090002@ru.mvista.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: jeff@garzik.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

Sergei Shtylyov wrote:
> Hello.
> 
> Tejun Heo wrote:
> 
>> Now that SFF and BMDMA are completely separate, sata_qstor which
>>   
> 
>   SFF and BMDMA being separate sounds funny. :-)

Yeah, I wish I could say "PIO TF and BMDMA" but, well, it's too late.
SFF is the new TF in libata.  I mean, who cares.  :-P

-- 
tejun
