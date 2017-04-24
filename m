From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: Re: [PATCH 2/9] sd: Fix functions description
Date: Mon, 24 Apr 2017 09:21:46 +0900
Message-ID: <8ce95866-d2fb-0bb5-2731-876c380bd311@wdc.com>
References: <20170421091649.25287-1-damien.lemoal@wdc.com>
 <20170421091649.25287-3-damien.lemoal@wdc.com>
 <1492795708.2550.19.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:61350 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1163634AbdDXAV6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Apr 2017 20:21:58 -0400
In-Reply-To: <1492795708.2550.19.camel@sandisk.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "hch@lst.de" <hch@lst.de>, "hare@suse.de" <hare@suse.de>

Bart,

On 4/22/17 02:28, Bart Van Assche wrote:
> On Fri, 2017-04-21 at 18:16 +0900, damien.lemoal@wdc.com wrote:
>> - *   Returns 0 if successful. Returns a negated errno value in case
>> - *   of error.
>> + * Returns 0 if successful. Returns a negated errno value in case
>> + * of error.
> 
> Hello Damien,
> 
> The argument name fixes are definitely welcome in my opinion. But I see
> that this patch not only fixes argument names and function descriptions
> but also includes whitespace-only changes like the above. Sorry but I
> don't like whitespace-only changes ...

Yes, I understand, you were clear about that.
The "white space" changes intent are to match the preferred format for
functions documentation (From Documentation/doc-guide/kerne-doc.rst)

  /**
   * foobar() - Brief description of foobar.
   * @arg: Description of argument of foobar.
   *
   * Longer description of foobar.
   *
   * Return: Description of return value of foobar.
   */

If that is wrong/unnecessary, then I will rewrite that patch to only
limit its scope to the argument name fixes.

Best regards.

-- 
Damien Le Moal,
Western Digital
