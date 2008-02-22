From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: New 2.6.24.2 SG_IO SCSI problems
Date: Fri, 22 Feb 2008 10:50:19 -0600
Message-ID: <47BEFD4B.9060803@cs.wisc.edu>
References: <47BD9588.9080803@compro.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:59828 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755858AbYBVQua (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Feb 2008 11:50:30 -0500
In-Reply-To: <47BD9588.9080803@compro.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: markh@compro.net
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Mark Hounschell wrote:
> I seem to have run into some sort of regression in the SG_IO interface of 2.6.24.2. 
> I have an application that up until 2.6.24 worked fine. The 2.6.23.16 kernel works fine.
> 
> During reads I get these kernel messages. Writes and other functions _seem_ OK. Actually basic
> reads  are working. Its with large BC reads using an io_vec list that the problem shows up.
> 

Are you doing SG_IO to the sg device (/dev/sg*) or to the block device 
(/dev/sdX)?
