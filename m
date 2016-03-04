From: Yves-Alexis Perez <corsac@corsac.net>
Subject: Re: Page allocation failure (order 7) in UAS code
Date: Fri, 04 Mar 2016 14:28:11 +0100
Message-ID: <1457098091.23913.6.camel@corsac.net>
References: <1456825361.17330.9.camel@corsac.net>
	 <56D573CF.1000600@redhat.com> <1457075638.23913.4.camel@corsac.net>
	 <56D936A8.208@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pic75-3-78-194-244-226.fbxo.proxad.net ([78.194.244.226]:34878
	"EHLO molly.corsac.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852AbcCDN23 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Mar 2016 08:28:29 -0500
Received: from corsac.net (unknown [IPv6:2a01:e34:ec2f:4e20:6af7:28ff:fe8d:2119])
	by molly.corsac.net (Postfix) with ESMTPS id 98C8470
	for <linux-scsi@vger.kernel.org>; Fri,  4 Mar 2016 14:28:11 +0100 (CET)
In-Reply-To: <56D936A8.208@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

On ven., 2016-03-04 at 08:18 +0100, Hans de Goede wrote:
> Thanks for testing, there shouldn't be any side-effects, I'll turn this into
> a proper patch, add a:
> 
> Reported-and-tested-by: Yves-Alexis Perez <corsac@corsac.net>
> 
> line to the comit msg and submit this upstream.
> 
> 
Thanks,

I guess it can also be CC: stable@ since it started in 4.4.

Regards,
-- 
Yves-Alexis

