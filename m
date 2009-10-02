From: "H Hartley Sweeten" <hartleys@visionengravers.com>
Subject: RE: [PATCH] dc395x.h: use bitops.h BIT macro
Date: Fri, 2 Oct 2009 16:07:46 -0400
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190901DB753F@mi8nycmail19.Mi8.com>
References: <BD79186B4FD85F4B8E60E381CAEE190901DB7421@mi8nycmail19.Mi8.com> <1254510597.3874.135.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod6og101.obsmtp.com ([64.18.1.181]:50470 "HELO
	exprod6og101.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756736AbZJBUHn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Oct 2009 16:07:43 -0400
Content-class: urn:content-classes:message
In-Reply-To: <1254510597.3874.135.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, oliver@neukum.name, aliakc@web.de, lenehan@twibble.org

On Friday, October 02, 2009 12:10 PM, James Bottomley wrote:
> On Thu, 2009-10-01 at 19:28 -0400, H Hartley Sweeten wrote: 
>> Use BIT macro from linux/bitops.h instead of custom defines.
>> 
>> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
>> Cc: Oliver Neukum <oliver@neukum.name>
>> Cc: Ali Akcaagac <aliakc@web.de>
>> Cc: Jamie Lenehan <lenehan@twibble.org>
>> Cc: James E.J. Bottomley <James.Bottomley@suse.de>
>
> This is a really old driver; we try not to touch the ancient drivers at
> all unless absolutely necessary because they tend to come apart under
> the slightest pressure.
>
> Unless you actually have the hardware and are willing to maintain it,
> I'm not really interested in conversions like this.

Not a problem.  I was looking for something else in the kernel when I
saw this so I fired out the patch.  Please disregard.

Thanks,
Hartley
