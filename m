From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] add ssleep(), kill scsi_sleep()
Date: Thu, 19 Aug 2004 11:24:32 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4124C630.1030007@pobox.com>
References: <412431D2.5080904@pobox.com> <20040818225853.183b9696.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:58537 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S266380AbUHSPZ1
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Aug 2004 11:25:27 -0400
In-Reply-To: <20040818225853.183b9696.akpm@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

Andrew Morton wrote:
> Jeff Garzik <jgarzik@pobox.com> wrote:
> 
>>So, the kernel needs a 'sleep', but that token is far too common, so I 
>> chose ssleep().
> 
> 
> Dorky name, but whatever.


Feel free to rename :)  I care mainly about the end results:

1) having a function that takes a 'seconds' argument, since that matches 
common usage in many places
2) killing scsi_sleep

