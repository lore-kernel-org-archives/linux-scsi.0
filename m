From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: question on flushing buffers and spinning down disk
Date: Tue, 18 Sep 2007 09:01:01 -0500
Message-ID: <1190124061.3375.5.camel@localhost.localdomain>
References: <200709181032.29864.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:56861 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753383AbXIROBD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Sep 2007 10:01:03 -0400
In-Reply-To: <200709181032.29864.oliver@neukum.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-scsi@vger.kernel.org

On Tue, 2007-09-18 at 10:32 +0200, Oliver Neukum wrote:
> which function should a lldd call to make the scsi layer flush
> a device's buffers and spin it down? Which kind of locking is
> required?

Depends on the context. Is this for suspend? If so it's done
automatically by the sd driver, but the device has to be marked for it
in the manage_start_stop attributes.

James


