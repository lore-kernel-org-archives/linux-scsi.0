From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH 2.5.59] sim710: cleanup/remove most cli()'s
Date: Tue, 11 Feb 2003 11:55:33 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200302111155.33075@bilbo.math.uni-mannheim.de>
References: <200302041123.06204@bilbo.math.uni-mannheim.de> <200302070826.25941@bilbo.math.uni-mannheim.de> <1044676664.3564.107.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <1044676664.3564.107.camel@mulgrave>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org

Am Samstag, 8. Februar 2003 04:57 schrieben Sie:
> On Fri, 2003-02-07 at 01:26, Rolf Eike Beer wrote:
> > That would be fine, you know your code better than I ever will.
>
> OK, the attached works for me for the 3430 MCA internal SCSI chip and an
> HP EISA SCSI board.  Let me know how it works for the Compaq.

This is from my boot.msg:

<6>EISA bus registered
<6>EISA: Probing bus...
<6>EISA: Motherboard CPQ0601 detected
<6>EISA: slot 2 : CPQ3011 detected.
<6>EISA: slot 3 : CPQ6100 detected.
<6>EISA: slot 7 : CPQ4411 detected.
<6>EISA: slot 8 : CPQ4410 detected.
<6>EISA: Detected 4 cards.

[...]

<5>IRQ_INDEX 249, 5
<4>sim710: irq nasty

This is the Compaq NCR 53c710 on an EISA board, address 0x7000, IRQ 14 (and it 
works fine with the original sim710).

<5>IRQ_INDEX 2, 5
<5>sim710: Compaq Integrated 32-Bit Fast-SCSI-2 Controller
<5>sim710: irq = 15, clock = 50, base = 0x8000, scsi_id = 7
<5>53c700: Version 2.8 By James.Bottomley@HansenPartnership.com
<5>scsi0: 53c710 rev 2 
<6>scsi0 : LSI (Symbios) 710 MCA/EISA
<6>scsi0: (0:0) Synchronous at offset 8, period 100ns
<5>  Vendor: SEAGATE   Model: ST51080N          Rev: 0943
<5>  Type:   Direct-Access                      ANSI SCSI revision: 02
<6>scsi0: (1:0) Synchronous at offset 8, period 100ns
<5>  Vendor: SEAGATE   Model: ST51080N          Rev: 0943
<5>  Type:   Direct-Access                      ANSI SCSI revision: 02
<6>scsi0: (2:0) Synchronous at offset 8, period 100ns
<5>  Vendor: COMPAQ    Model: M2694ES-512       Rev: 952D
<5>  Type:   Direct-Access                      ANSI SCSI revision: 02
<6>scsi0: (3:0) Synchronous at offset 8, period 100ns
<5>  Vendor: COMPAQ    Model: M2694ES-512       Rev: 952D
<5>  Type:   Direct-Access                      ANSI SCSI revision: 02
<6>scsi0: (0:0) Enabling Tag Command Queuing

And this is the onboard NCR53c710. Works fine so far. Now we have to find a 
way to get the other board working, I want to use my external drive, too. 
I'll send some minor changes I made to the new code tomorrow or so.

Eike
