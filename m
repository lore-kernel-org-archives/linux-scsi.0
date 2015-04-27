From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH] lpfc: fix model description
Date: Mon, 27 Apr 2015 08:02:53 +0200
Message-ID: <553DD10D.8060407@sandisk.com>
References: <20150422231618.00005ec8@localhost> <5538A10E.10904@sandisk.com>
 <20150427003211.0000410a@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0090.outbound.protection.outlook.com ([207.46.100.90]:64977
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752200AbbD0GDB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Apr 2015 02:03:01 -0400
In-Reply-To: <20150427003211.0000410a@localhost>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sebastian Herbszt <herbszt@gmx.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, James Smart <James.Smart@Emulex.Com>

On 04/27/15 00:32, Sebastian Herbszt wrote:
> Bart Van Assche wrote:
>> * Switch from snprintf() to scnprintf() because the latter function
>>     guarantees '\0'-termination if the output has to be truncated.
>
> Doesn't snprintf() guarantee this too? The only difference between
> snprintf() and scnprintf() seems to be the return value.
> snprintf() calls vsnprintf() and scnprintf() calls vscnprintf() which
> calls vsnprintf() itself.

Hello Sebastian,

In my e-mail I was referring to the pre-C99 behavior of snprintf(). 
Apparently the snprintf() function in the Linux kernel is compliant with 
the C99 specs. See e.g. 
http://pubs.opengroup.org/onlinepubs/7908799/xsh/fprintf.html and 
http://pubs.opengroup.org/stage7tc1/functions/fprintf.html#. In the 
latter document it has been mentioned that "output bytes beyond the 
n-1st shall be discarded", something which has not been mentioned in the 
former document.

Bart.
