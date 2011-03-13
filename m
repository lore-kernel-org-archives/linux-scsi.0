From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 0/2] ISCSID: Added vlan field to the iface struct
Date: Sun, 13 Mar 2011 03:11:34 -0500
Message-ID: <4D7C7C36.2040206@cs.wisc.edu>
References: <eddie.wai@broadcom.com> <1299810073-7339-1-git-send-email-eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:56831 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225Ab1CMILo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Mar 2011 04:11:44 -0400
In-Reply-To: <1299810073-7339-1-git-send-email-eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-iscsi@googlegroups.com
Cc: Eddie Wai <eddie.wai@broadcom.com>, James Bottomley <JBottomley@novell.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>

On 03/10/2011 08:21 PM, Eddie Wai wrote:
> Hello,
>
> This patch adds the iface.vlan field to the iface struct so that it
> can be defined in the iface file.

Does qlogic's patches do what you wanted? Please review those patches 
and work with them to figure out what works for both of you guys.
