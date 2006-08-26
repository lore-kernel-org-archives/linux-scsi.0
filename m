From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] aic94xx: add transport class phy reset capability
Date: Fri, 25 Aug 2006 21:09:55 -0400
Message-ID: <44EF9F63.2030305@torque.net>
References: <1156533974.3462.17.camel@mulgrave.il.steeleye.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:13986 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751049AbWHZBKD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Aug 2006 21:10:03 -0400
In-Reply-To: <1156533974.3462.17.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> This wires in the transport class hard and link reset phy ability.  It
> does local phy resets via the HBA callback functions, but it also does
> expander phy resets vi the SMP PHY_CONTROL messages.

James,
The ability to disable a phy (on a HBA or on an expander)
is also a very useful capability. Does the sas_transport
give us that capability?

There is a way to effectively disable a phy on a SAS disk
as well: use SEND DIAGNOSTIC to send the SAS protocol
specific diagnostic page to put the disk phy in CJTPAT
(jitter pattern) generation mode. However unless another
phy is accessible on that disk to clear that state, a
power cycle is needed to re-enable a phy in jitter pattern
generation mode.

Doug Gilbert
