From: Matthew Jacob <mjacob@feral.com>
Subject: Re: QLA2200 driver
Date: Thu, 25 Apr 2002 09:03:02 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.BSF.4.21.0204250901270.34642-100000@beppo>
References: <3CC7E9E0.5050107@corp.home.nl>
Reply-To: mjacob@feral.com
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3CC7E9E0.5050107@corp.home.nl>
List-Id: linux-scsi@vger.kernel.org
To: Thomas Tonino <ttonino@corp.home.nl>
Cc: linux-scsi@vger.kernel.org

> Is there a reason why Feral's driver is not in the kernel? Having a 
> driver that is so non-functional is really bad, IMO.

Needs to:

	a) support SBus cards

	b) have more compilation options so that people only get teh
	functionality that they want

	c) have the f/w split off as a separate module

	d) handler 64 bit pci which it doesn't as yet

Don't forget that QLogic itself puts out an FC driver.


