From: Richard Knutsson <ricknu-0@student.ltu.se>
Subject: Re: [PATCH] drivers/scsi/aic7xxx_old: Convert to generic	boolean-values
Date: Sat, 10 Feb 2007 21:35:24 +0100
Message-ID: <45CE2C8C.80306@student.ltu.se>
References: <20070210174628.3764.89569.sendpatchset@thinktank.campus.ltu.se> <1171132062.3373.31.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gepetto.dc.ltu.se ([130.240.42.40]:64019 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860AbXBJUf3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Feb 2007 15:35:29 -0500
In-Reply-To: <1171132062.3373.31.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Sat, 2007-02-10 at 18:46 +0100, Richard Knutsson wrote:
>   
>> Convert:
>> FALSE -> false
>> TRUE  -> true
>>     
>
> Actually, downcasing true and false in this driver is pretty much a
> retrograde step.  The reason for their being uppercased is that they
> represent constants (and uppercase is the traditional defined constant
> specifier).
>   
I would argue that 'false' and 'true' are values and not constants, but 
further more C99 is defining them in lowercase (stdbool.h).
> When discussion about TRUE and FALSE came up a long time a go in the
> context of the mid layer we agreed to strip the defined constants out of
> that code and just go with 1 and 0 inline ... because the code was
> pretty much being rewritten.  We also decided to encourage but not force
> the driver writers simply to use 1 and 0 as well ... a lot of people are
> deeply wedded to the TRUE and FALSE defines, it turned out.
>   
As I have expressed before, I don't understand why people seem to 
dislike 'false'/'true' but anyway, since you seem to approve booleans, 
would it be possible to convert the obvious variables/functions into 
boolean-type?

Richard Knutsson

