From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: drivers/scsi/aic7xxx/: How can I edit the _shipped files?
Date: Mon, 15 Nov 2004 11:44:09 -0500
Message-ID: <4198DCD9.5040907@adaptec.com>
References: <20041113161400.GA2249@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:13234 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261630AbUKOQoZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Nov 2004 11:44:25 -0500
In-Reply-To: <20041113161400.GA2249@stusta.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@stusta.de>
Cc: linux-scsi@vger.kernel.org

Adrian Bunk wrote:
 > How can I edit the _shipped files under drivers/scsi/aic7xxx/?
 >
 > The source files they claim to be built from aren't shipped with the
 > kernel.
 >

Hi Adrian,

Do you mind sharing why you need to change the _shipped files?

This is how I've changed them in the past: Make the changes in the
generator files (i.e. the ones the _shipped file(s) depends on),
build them and then rename them to _shipped.

	Luben


