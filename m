From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RFC 0/2] target refcounting infrastructure fixes for usb
Date: Fri, 03 Jan 2014 06:50:39 -0800
Message-ID: <1388760639.2202.3.camel@dabdike.int.hansenpartnership.com>
References: <20131220231810.GA2835@xanatos>
	 <Pine.LNX.4.44L0.1312211547490.12252-100000@netrider.rowland.org>
	 <20140103004551.GA2970@xanatos> <52C67B4D.9060101@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:40491 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751529AbaACOul (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jan 2014 09:50:41 -0500
In-Reply-To: <52C67B4D.9060101@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>, Alan Stern <stern@rowland.harvard.edu>, linux-scsi <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>

On Fri, 2014-01-03 at 09:56 +0100, Hans de Goede wrote:
> James, what is the status of getting the fix for the refcount issue into
> mainline ?

The plan is what I wrote in the patch intro:

        "Since it's a major change to the infrastructure, we'll incubate
        upstream first before backporting to stable."
        
That means with the merge window and delayed stable backport to make
sure it's sound.

James


