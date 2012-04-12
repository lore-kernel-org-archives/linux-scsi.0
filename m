From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Subject: Re: stuck in megaraid_sas.c megasas_adp_reset_gen2
Date: Thu, 12 Apr 2012 12:16:24 -0600
Message-ID: <201204121216.24519.thomas@fjellstrom.ca>
References: <201203211716.45418.thomas@fjellstrom.ca> <201204111544.27866.thomas@fjellstrom.ca> <CAHtARFHayv68BASrfCLYHQ0zZ1R8fvzfB-_fkBeG8H4g3OBZvg@mail.gmail.com>
Reply-To: thomas@fjellstrom.ca
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tomasu.net ([64.85.170.232]:39105 "EHLO mail.tomasu.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760966Ab2DLSQc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Apr 2012 14:16:32 -0400
In-Reply-To: <CAHtARFHayv68BASrfCLYHQ0zZ1R8fvzfB-_fkBeG8H4g3OBZvg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: adam radford <aradford@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

On Thu Apr 12, 2012, adam radford wrote:
> On Wed, Apr 11, 2012 at 2:44 PM, Thomas Fjellstrom <thomas@fjellstrom.ca> 
wrote:
> > megasas: [55] waiting for 1 commands to complete
> > ....
> > megasas: [175] waiting for 1 commands to complete
> 
> You still aren't getting interrupts from the card.  Can you re-try
> with megaraid_sas module parameter msix_disable ?
> If that doesn't work, contact LSI support and tell them which
> motherboard, any PCIe bridges, risers, etc you have.

No luck darn it. with either card.

> -Adam


-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
