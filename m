From: Boaz Harrosh <boaz@plexistor.com>
Subject: Re: [PATCH 0/17] Clear up bidi command confusion
Date: Thu, 29 Jan 2015 15:07:52 +0200
Message-ID: <54CA30A8.5020101@plexistor.com>
References: <54C2390A.3000700@sandisk.com> <20150123131249.GA8045@infradead.org> <54C60FCC.4060601@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:55854 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840AbbA2NHz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Jan 2015 08:07:55 -0500
Received: by mail-we0-f176.google.com with SMTP id w62so23330481wes.7
        for <linux-scsi@vger.kernel.org>; Thu, 29 Jan 2015 05:07:54 -0800 (PST)
In-Reply-To: <54C60FCC.4060601@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@infradead.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 01/26/2015 11:58 AM, Bart Van Assche wrote:

> Hello Christoph,
> 
> This makes sense to me. I will rework this patch series as you proposed.
> 

Do you have a bidi setup to test against?

Sending xor command to scsi_dbg is only half the test for me because, yes
there are two buffers, but they are of same size so bugs might be masked.
(From experience)

Thanks
Boaz

> Bart.

