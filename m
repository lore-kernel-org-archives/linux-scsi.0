From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Enterprise patch needed - please help
Date: 30 May 2002 13:38:27 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1022762307.4123.364.camel@irongate.swansea.linux.org.uk>
References: <6BD67FFB937FD411A04F00D0B74FE87807C249F0@xrose06.rose.hp.com>
	<1022719300.4124.312.camel@irongate.swansea.linux.org.uk>
	<3CF5AEA4.4050404@metaparadigm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3CF5AEA4.4050404@metaparadigm.com>
List-Id: linux-scsi@vger.kernel.org
To: Michael Clark <michael@metaparadigm.com>
Cc: "HINCHMAN,PAUL    (HP-Roseville,ex1)" <paul_hinchman@hp.com>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

On Thu, 2002-05-30 at 05:46, Michael Clark wrote:
> Also, some devices need a BLIST_SPARSELUN added in scsi_scan.c - even if 
> the device
> reports SCSI-3, the scanning code by defaults stops when it finds a lun 
> that doesn't
> respond. It is quite common with enterpise storage to have sparse 
> between luns.

If we use report luns should we even be checking BLIST_SPARSELUN I
wonder

