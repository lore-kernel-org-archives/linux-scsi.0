From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] libosd: Fix NULL dereference BUG when target is none
 OSD conformant
Date: Sun, 08 Feb 2009 16:09:13 +0200
Message-ID: <498EE789.2010507@panasas.com>
References: <498EE637.3030800@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:32846 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752843AbZBHOJR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Feb 2009 09:09:17 -0500
In-Reply-To: <498EE637.3030800@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Fuerst Lars <lars.fuerst@thomson.net>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd mailing-list <osd-dev@open-osd.org>

Boaz Harrosh wrote:
> Very old OSC's Target had a BUG in the Get/Set attributes where
> it was looking in the wrong places for attribute lists length.
> If used with the open-osd initiator, the initiator would dereference
> a NULL pointer when retrieving system_information attributes.
> 
> Checks are added if retrieval of each attributes was successful
> before accessing them.
> 
> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> ---

Lars I will need your Tested-by: ... here
I did not manage to run with your version of the target. It might crash
farther on now.

(Or if you can identify where on git://git.open-osd.org/osc-osd is the
point that best matches your version and I can test it here)

Thanks in advance
Boaz
