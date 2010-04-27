From: Tejun Heo <tj@kernel.org>
Subject: Re: Using get_last_written() in sr.c causes problems with some usb
 devices (bz.kernel.org 9668)
Date: Tue, 27 Apr 2010 11:50:54 +0200
Message-ID: <4BD6B37E.2060205@kernel.org>
References: <4BD6B1B3.30707@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:40191 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754228Ab0D0JvM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Apr 2010 05:51:12 -0400
In-Reply-To: <4BD6B1B3.30707@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>
Cc: linux-scsi@vger.kernel.org, linux-usb <linux-usb@vger.kernel.org>

Hello,

On 04/27/2010 11:43 AM, Hans de Goede wrote:
> The only thing I can come up with to fix this is a device specific
> quirk. Either in sr.c or in ubs-storage. Which is not a very
> pretty solution, hence this mail in the hope someone has
> a clever idea.

For cases like this, I think quirking is the cleanest solution.
Trying to modify generic behavior to accomodate special cases
sometimes create unexpected subtle issues in other devices and as the
fix itself is buried in the general seemingly unrelated logic, it's
relatively easy to lose the workaround later during an unrelated
update.

Is the device uniquely identifiable?

Thanks.

-- 
tejun
