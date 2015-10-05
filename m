From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 1/2] scsi: move Additional Sense Codes to separate file
Date: Mon, 5 Oct 2015 07:05:12 -0700
Message-ID: <56128398.8070908@sandisk.com>
References: <20151004080217.GA22816@infradead.org>
 <1444037200-14684-1-git-send-email-linux@rasmusvillemoes.dk>
 <1444037200-14684-2-git-send-email-linux@rasmusvillemoes.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0071.outbound.protection.outlook.com ([157.56.110.71]:45920
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751910AbbJEOFU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 Oct 2015 10:05:20 -0400
In-Reply-To: <1444037200-14684-2-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, "James E.J. Bottomley" <JBottomley@odin.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On 10/05/15 02:26, Rasmus Villemoes wrote:
> -	{0x041A, "Logical unit not ready, start stop unit command in "
> -	 "progress"},
> -	{0x041B, "Logical unit not ready, sanitize in progress"},
> -	{0x041C, "Logical unit not ready, additional power use not yet "
> -	 "granted"},

Please convert these multi-line strings into single line string 
constants such that users can look up these easily with grep.

 > +
 > +SENSE_CODE(0, NULL)

The above looks confusing to me. Please leave this out and add { 0, NULL 
} at the end of the additional[] array instead.

Thanks,

Bart.

